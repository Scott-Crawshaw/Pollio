//
//  FeedTableViewController.swift
//  PollApp
//
//  Created by Scott Crawshaw on 7/19/19.
//  Copyright © 2019 Crawtech. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class FeedTableViewController: UITableViewController, UITableViewDataSourcePrefetching {

    var data : [[String : Any]] = []
    var postLinks : [String] = []
    var lastCurrentPageDoc: DocumentSnapshot?
    let countPerPage = 10
    var totalCount = 0
    var isFetchInProgress = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.tableView.dataSource = self
        self.tableView.prefetchDataSource = self
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let db = Firestore.firestore()
        let docRef = db.document("/feed/" + Auth.auth().currentUser!.uid)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let docData : [String : Any] = document.data()!
                self.postLinks = docData["posts"] as! [String]
                self.fetch()
            }
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.totalCount
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell", for: indexPath) as! PollTableViewCell
        if isLoadingCell(for: indexPath) {
            return cell
        }
        return self.modifyCell(cell: cell, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        print("prefetch rows at index paths: \(indexPaths)")
        if indexPaths.contains(where: isLoadingCell) {
            fetch()
        }
    }
    
    func fetch() {
        guard !isFetchInProgress else {
            return
        }
        
        isFetchInProgress = true
        
        fetchTotalCountIfNeeded { (totalCount, err) in
            guard err == nil else {
                print("Error when get total count: \(err!)")
                return
            }
            
            self.totalCount = totalCount!
            print("total count: \(self.totalCount)")
            
            self.fetchFeed(completed: { (snapshot, err) in
                guard err == nil else {
                    print("Error when get feed: \(err!)")
                    return
                }
                
                guard let snapshot = snapshot else {
                    print("feed docs is null")
                    return
                }
                
                guard snapshot.documents.count > 0 else {
                    print("feed docs is empty")
                    return
                }
                
                let newData = snapshot.documents.compactMap({$0.data()})
                
                print("Fetched \(newData.count) posts")
                
                self.lastCurrentPageDoc = snapshot.documents.last
                
                if self.data.count == 0 {
                    self.data.append(contentsOf: newData)
                    self.tableView.reloadData()
                }
                else {
                    self.data.append(contentsOf: newData)
                    let range = (self.data.count - newData.count)..<self.data.count
                    let newIndexPathsToReload = range.map{ IndexPath(row: $0, section: 0) }
                    let indexPathsToReload = self.visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
                    if indexPathsToReload.count > 0 {
                        self.tableView.reloadRows(at: indexPathsToReload, with: .fade)
                    }
                }
                
                self.isFetchInProgress = false
            })
        }
    }
    
    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows ?? []
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }
    
    func fetchTotalCountIfNeeded(completed: @escaping (Int?, Error?)->Void) {
        guard totalCount == 0 else {
            completed(totalCount, nil)
            return
        }
        
        let usersCountRef = Firestore.firestore().collection("feedCount").document(Auth.auth().currentUser!.uid)
        usersCountRef.getDocument { (doc, error) in
            if let error = error {
                completed(nil, error)
            }
            else {
                let totalCount = doc!.data()!["count"] as! Int
                completed(totalCount, nil)
            }
        }
    }
    
    func fetchFeed(completed: @escaping (QuerySnapshot?, Error?)->Void) {
        let feedDB = Firestore.firestore().collection("feed").document(Auth.auth().currentUser!.uid)
        
        /*if self.data.count == 0 {
            query = feedDB
                .limit(to: countPerPage)
        }
        else {
            query = feedDB
                .limit(to: countPerPage)
                .start(afterDocument: lastCurrentPageDoc!)
        }
        query.getDocuments { (snapshot, err) in
            if let err = err {
                completed(nil, err)
            }
            else {
                completed(snapshot, nil)
            }
        }*/
    }
    
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= data.count
    }
    
    
    func modifyCell(cell : PollTableViewCell, indexPath : IndexPath) -> UITableViewCell{
        cell.username.text = data[indexPath.row]["username"] as? String ?? "Unknown"
        
        let FBtime : Timestamp = data[indexPath.row]["time"] as! Timestamp
        let time = FBtime.dateValue()
        var timeText = ""
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        if calendar.isDateInToday(time){
            timeText += "Today"
        }
        else if calendar.isDateInYesterday(time){
            timeText += "Yesterday"
        }
        else if calendar.isDate(Date(), equalTo: time, toGranularity: .year){
            dateFormatter.dateFormat = "MMM dd"
            timeText += dateFormatter.string(from: time)
        }
        else{
            dateFormatter.dateFormat = "MMM dd, yyyy"
            timeText += dateFormatter.string(from: time)
        }
        timeText += " at "
        dateFormatter.dateFormat = "h:mm a"
        timeText += dateFormatter.string(from: time)
        
        cell.time.text = timeText
        
        let visArr = data[indexPath.row]["visibility"] as? [String : Bool] ?? ["author":false, "viewers":false]
        
        if visArr["author"]! && visArr["viewers"]!{
            cell.visibility.text = "Public"
        }
        if visArr["author"]! && !visArr["viewers"]!{
            cell.visibility.text = "Private"
        }
        if !visArr["author"]! && !visArr["viewers"]!{
            cell.visibility.text = "Anonymous"
        }
        
        cell.question.text = data[indexPath.row]["question"] as? String ?? "Unknown"
        let options = data[indexPath.row]["options"] as? [String] ?? []
        
        cell.choice1_bar.isHidden = true
        cell.choice2_bar.isHidden = true
        cell.choice3_bar.isHidden = true
        cell.choice4_bar.isHidden = true
        
        cell.choice1_button.tag = indexPath.row
        cell.choice2_button.tag = indexPath.row
        cell.choice3_button.tag = indexPath.row
        cell.choice4_button.tag = indexPath.row
        
        cell.choice1_button.addTarget(self, action: #selector(vote(sender:)), for: .touchUpInside)
        cell.choice2_button.addTarget(self, action: #selector(vote(sender:)), for: .touchUpInside)
        cell.choice3_button.addTarget(self, action: #selector(vote(sender:)), for: .touchUpInside)
        cell.choice4_button.addTarget(self, action: #selector(vote(sender:)), for: .touchUpInside)

        
        if options.count == 2{
            cell.choice2_text.text = options[0]
            cell.choice3_text.text = options[1]
            
            cell.choice1_button.isHidden = true
            cell.choice1_text.isHidden = true
            cell.choice4_button.isHidden = true
            cell.choice4_text.isHidden = true
            
        }
        if options.count == 3{
            cell.choice2_text.text = options[0]
            cell.choice3_text.text = options[1]
            cell.choice4_text.text = options[2]
            
            cell.choice1_button.isHidden = true
            cell.choice1_text.isHidden = true
        }
        if options.count == 4{
            cell.choice1_text.text = options[0]
            cell.choice2_text.text = options[1]
            cell.choice3_text.text = options[2]
            cell.choice4_text.text = options[3]
        }
        return cell
    }
    
    @objc func vote(sender: UIButton){
        let index = sender.tag
        let indexPath = IndexPath(row: index, section: 0)
        let cell = tableView.cellForRow(at: indexPath)
        
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

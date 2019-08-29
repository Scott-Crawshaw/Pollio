//
//  FeedTableViewController.swift
//  PollApp
//
//  Created by Scott Crawshaw on 7/19/19.
//  Copyright © 2019 Crawtech. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFunctions
import FirebaseFirestore

class FeedTableViewController: UITableViewController, UITableViewDataSourcePrefetching, UIPopoverPresentationControllerDelegate {

    var data : [[String : Any]] = []
    var totalCount = 0
    var refresh = false
    let initialGet = 2
    
    @objc func refreshFeed(sender:AnyObject) {
        refresh = true
        data = []
        self.tableView.setEmptyMessage("Loading...")
        self.totalCount = 0
        self.tableView.reloadData()
        //tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .bottom, animated: false)

        self.fetchTotalCount { (count, err) in
            self.totalCount = count ?? 0
            if self.totalCount == 0{
                self.tableView.setEmptyMessage("It looks like your feed is empty.\n\nTry finding some friends using the search tab.")
                if(self.refresh){
                    self.refresh = false
                    self.refreshControl?.endRefreshing()
                }
                self.tableView.reloadData()
                return
            }
            self.data = Array(repeating: ["author" : "nil"], count: self.totalCount)
            self.tableView.reloadData()
            var initialRows : [Int] = []
            if self.totalCount > self.initialGet{
                initialRows = Array(0...self.initialGet)
            }
            else{
                initialRows = Array(0...self.totalCount-1)
            }
            self.newFetch(rows: initialRows, initial: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.tableView.dataSource = self
        self.tableView.prefetchDataSource = self
        self.refreshControl?.addTarget(self, action: #selector(refreshFeed), for: UIControl.Event.valueChanged)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Auth.auth().currentUser == nil{
            returnToLogin()
            return
        }
        DatabaseHelper.isUser(uid: Auth.auth().currentUser!.uid) { (res) in
            if !res{
                DatabaseHelper.deleteNumber()
                do{
                try Auth.auth().signOut()
                }
                catch{}
                self.returnToLogin()
            }
        }
        self.refreshFeed(sender: self)
        
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.totalCount
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell", for: indexPath) as! PollTableViewCell
        
        if isLoadingCell(for: indexPath) {
            cell.isHidden = true
            return cell
        }
        
        return self.modifyCell(cell: cell, indexPath: indexPath)
    }

    func returnToLogin(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "login") as! ViewController
        self.present(newViewController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if Auth.auth().currentUser == nil{
            returnToLogin()
            return
        }
        if !refresh{
            print("getting " + indexPaths.description)
            self.newFetch(rows: indexPaths.map({$0.row}), initial: false)
        }
    }

    
    func newFetch(rows : [Int], initial : Bool){
        var unfilledRows : [Int] = []
        for i in rows{
            if data.count > i{
                if data[i]["author"] as! String == "nil"{
                    unfilledRows.append(i)
                }
            }
        }
        if unfilledRows.count > 0{
            fetchFeed(rows: unfilledRows) { (newData, err) in
                
                if err != nil{
                    self.tableView.restore()
                    return
                }
                if newData.count > 0{
                    for i in 0...newData.count-1{
                        self.data[unfilledRows[i]] = newData[i]
                    }
                }
                
                if initial{
                    var firstPaths : [IndexPath] = []
                    for i in unfilledRows{
                        firstPaths.append(IndexPath(row: i, section: 0))
                    }
                    self.tableView.reloadRows(at: firstPaths, with: .none)
                    if(self.refresh){
                        self.refresh = false
                        self.refreshControl?.endRefreshing()
                    }
                    self.tableView.restore()
                }
                
            }
        }
    }
    
    
    func fetchTotalCount(completed: @escaping (Int?, Error?)->Void) {
        Firestore.firestore().collection("feedCount").document(Auth.auth().currentUser!.uid).getDocument { (doc, error) in
            if let error = error {
                completed(nil, error)
            }
            else {
                let totalC = doc?.data()?["count"] as? Int ?? 0
                completed(totalC, nil)
            }
        }
    }
    
    func fetchFeed(rows : [Int], completed: @escaping ([[String : Any]], Error?) -> Void) {
        let functions = Functions.functions()
        functions.httpsCallable("getFeed").call(["rows" : rows]) { (result, error) in
            let newData = result?.data as? [[String : Any]] ?? []
            completed(newData, nil)
        }
        
    }
    
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        if indexPath.row >= data.count{
            return true
        }
        return data[indexPath.row]["author"] as! String == "nil"
    }
    
    
    func modifyCell(cell : PollTableViewCell, indexPath : IndexPath) -> UITableViewCell{
        cell.resetCell()
        cell.currentUser = Auth.auth().currentUser!.uid
        cell.commentsDoc = data[indexPath.row]["comments"] as? String
        cell.postID = cell.commentsDoc.subString(from: 10, to: cell.commentsDoc.count-1)
        cell.username.text = data[indexPath.row]["username"] as? String ?? "Unknown"
        var author = data[indexPath.row]["author"] as? String ?? ""
        if author != ""{
            author = author.subString(from: 7, to: author.count-1)
        }
        cell.authorUID = author
        let timeMap = data[indexPath.row]["time"] as! [String : Any]
        let FBtime : Timestamp = Timestamp(seconds: timeMap["_seconds"] as! Int64, nanoseconds: timeMap["_nanoseconds"] as! Int32)
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
        
        cell.visibilityNum = 2
        
        if visArr["author"]! && visArr["viewers"]!{
            cell.visibility.text = "Public"
            cell.visibilityNum = 0
        }
        if visArr["author"]! && !visArr["viewers"]!{
            cell.visibility.text = "Private"
            cell.visibilityNum = 1
        }
        if !visArr["author"]! && !visArr["viewers"]!{
            cell.visibility.text = "Anonymous"
        }
        
        cell.question.text = data[indexPath.row]["question"] as? String ?? "Unknown"
        let options = data[indexPath.row]["options"] as? [String] ?? []
        
        
        cell.choice1_view.isHidden = true
        cell.choice2_view.isHidden = true
        cell.choice3_view.isHidden = true
        cell.choice4_view.isHidden = true
        
        let barHeight = cell.choice1_button.frame.height
        cell.choice1_view.frame.size = CGSize(width: 0, height: barHeight)
        cell.choice2_view.frame.size = CGSize(width: 0, height: barHeight)
        cell.choice3_view.frame.size = CGSize(width: 0, height: barHeight)
        cell.choice4_view.frame.size = CGSize(width: 0, height: barHeight)
        
        cell.choice1_view.layoutIfNeeded()
        cell.choice2_view.layoutIfNeeded()
        cell.choice3_view.layoutIfNeeded()
        cell.choice4_view.layoutIfNeeded()
        
        cell.choice1_button.tag = indexPath.row
        cell.choice2_button.tag = indexPath.row
        cell.choice3_button.tag = indexPath.row
        cell.choice4_button.tag = indexPath.row
        cell.resultsButton.tag = indexPath.row
        
        cell.choice1_button.addTarget(self, action: #selector(vote(sender:)), for: .touchUpInside)
        cell.choice2_button.addTarget(self, action: #selector(vote(sender:)), for: .touchUpInside)
        cell.choice3_button.addTarget(self, action: #selector(vote(sender:)), for: .touchUpInside)
        cell.choice4_button.addTarget(self, action: #selector(vote(sender:)), for: .touchUpInside)

        cell.resultsButton.addTarget(self, action: #selector(navToResults(sender:)), for: .touchUpInside)
        
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
        cell.generateListener()
    
        return cell
    }
    
    @objc func navToResults(sender: UIButton){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "results") as! ResultsViewController
        let res = (tableView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! PollTableViewCell).results ?? [:]
        for _ in 0...res.count-1{
            newViewController.uids.append([])
            newViewController.headers.append("")
        }
        for (option, users) in res{
            let optionInt = Int(option) ?? -1
            if optionInt != -1{
                newViewController.uids[optionInt] = users
                newViewController.headers[optionInt] = (data[sender.tag]["options"] as? [String] ?? ["","","",""])[optionInt]
            }
        }
        self.present(newViewController, animated: true, completion: nil)
    }
    
    @objc func vote(sender: UIButton){
        let index = sender.tag
        let indexPath = IndexPath(row: index, section: 0)
        guard let cell = tableView.cellForRow(at: indexPath) as? PollTableViewCell else{
            return
        }
        //let currentUID = Auth.auth().currentUser!.uid
        var option = "0"
        //var currData = data[index]
        //var res = currData["results"] as! [String : [String]]
        
        if cell.choice != "-1"{
            DatabaseHelper.removeVote(postID: cell.postID, option: cell.choice)
        }
        if sender == cell.choice1_button{
            option = "0"
        }
        if sender == cell.choice2_button{
            if cell.results.count != 4{
                option = "0"
            }
            else{
                option = "1"
            }
        }
        if sender == cell.choice3_button{
            if cell.results.count != 4{
                option = "1"
            }
            else{
                option = "2"
            }
        }
        if sender == cell.choice4_button{
            if cell.results.count != 4{
                option = "2"
            }
            else{
                option = "3"
            }
        }
        //cell.results[option]!.append(currentUID)
        //res[option]!.append(currentUID)
        //currData["results"] = res
        //data[index] = currData
        cell.choice = option
        DatabaseHelper.addVote(postID: cell.postID, option: option)
        //cell.showResults()
        
        
    }
    

}

extension UITableView {
    
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .gray
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 30)
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel;
    }
    
    func restore() {
        self.backgroundView = nil
    }
}

extension String {
    func subString(from: Int, to: Int) -> String {
        let startIndex = self.index(self.startIndex, offsetBy: from)
        let endIndex = self.index(self.startIndex, offsetBy: to)
        return String(self[startIndex...endIndex])
    }
}

//
//  MyProfileView.swift
//  PollApp
//
//  Created by Ben Stewart on 7/29/19.
//  Copyright © 2019 Crawtech. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFunctions
import FirebaseFirestore

class MyProfileView: UIViewController, UITableViewDataSource, UITableViewDataSourcePrefetching{
    
    @IBOutlet weak var label_username: UILabel!
    @IBOutlet weak var label_bio: UILabel!
    @IBOutlet weak var label_name: UILabel!
    @IBOutlet weak var label_following: UIButton!
    @IBOutlet weak var label_followers: UIButton!
    @IBOutlet weak var requestsButton: UIButton!
    
    @IBOutlet var tableView: UITableView!
    
    var data : [[String : Any]] = []
    var listeners : [ListenerRegistration] = []
    var totalCount = 0
    let initialGet = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let user = Auth.auth().currentUser?.uid else{
            self.view.window!.rootViewController?.dismiss(animated: false, completion: {
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "login") as! ViewController
                self.present(newViewController, animated: true, completion: nil)
            })
            
            return
        }
        self.refreshFeed(sender: self)
        let listen = DatabaseHelper.hasFollowRequestsListener(callback: doesUserHaveRequest) ?? nil
        if listen != nil{
            listeners.append(listen!)
        }
        listeners.append(DatabaseHelper.getUserByUIDListener(UID: user, callback: setInfo))
        listeners.append(DatabaseHelper.getFollowingCountListener(UID: user, callback: setFollowing))
        listeners.append(DatabaseHelper.getFollowersCountListener(UID: user, callback: setFollowers))
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.tableView.dataSource = self
        self.tableView.prefetchDataSource = self
        // Do any additional setup after loading the view.
    }
    
    deinit {
        listeners.forEach { (listener) in
            listener.remove()
        }
    }
    
    @objc func refreshFeed(sender:AnyObject) {
        data = []
        print("hit")
        self.tableView.setEmptyMessage("Loading...")
        self.totalCount = 10
        self.tableView.reloadData()
        
        self.fetchTotalCount { (count, err) in
            self.totalCount = count ?? 0
            print(self.totalCount)
            if self.totalCount == 0{
                self.tableView.setEmptyMessage("It looks like this user hasn't made any posts.")
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.totalCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "myFeedCell", for: indexPath) as! PollTableViewCell
        
        if isLoadingCell(for: indexPath) {
            cell.isHidden = true
            return cell
        }
        
        return self.modifyCell(cell: cell, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        self.newFetch(rows: indexPaths.map({$0.row}), initial: false)
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
                    return
                }
                if newData.count > 0{
                for i in 0...newData.count-1{
                    if unfilledRows[i] < self.data.count{
                        self.data[unfilledRows[i]] = newData[i]
                    }
                }
                }
                
                if initial{
                    var firstPaths : [IndexPath] = []
                    for i in unfilledRows{
                        firstPaths.append(IndexPath(row: i, section: 0))
                    }
                    self.tableView.reloadRows(at: firstPaths, with: .automatic)

                    self.tableView.restore()
                }
                
            }
        }
    }
    
    
    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows ?? []
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }
    
    func fetchTotalCount(completed: @escaping (Int?, Error?)->Void) {
        Firestore.firestore().collection("userPosts").document(Auth.auth().currentUser!.uid).getDocument { (doc, error) in
            if let error = error {
                completed(nil, error)
            }
            else {
                let allPosts = doc?.data()?["posts"] as? [String] ?? []
                completed(allPosts.count, nil)
            }
        }
    }
    
    func fetchFeed(rows : [Int], completed: @escaping ([[String : Any]], Error?) -> Void) {
        let functions = Functions.functions()
        
        functions.httpsCallable("getUserPosts").call(["rows" : rows, "uid" : Auth.auth().currentUser!.uid]) { (result, error) in
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
        cell.currentUser = Auth.auth().currentUser?.uid ?? ""
        cell.results = data[indexPath.row]["results"] as? [String : [String]]
        cell.commentsDoc = data[indexPath.row]["comments"] as? String
        cell.postID = cell.commentsDoc.subString(from: 10, to: cell.commentsDoc.count-1)
        cell.username.setTitle(data[indexPath.row]["username"] as? String ?? "Unknown", for: .normal)
        cell.username.tag = indexPath.row

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
        
        cell.username.addTarget(self, action: #selector(usernameClicked(sender:)), for: .touchUpInside)
        
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
    
    @objc func usernameClicked(sender: UILabel){
        guard let cell = tableView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as? PollTableViewCell else{
            return
        }
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        guard let uid = cell.authorUID else{
            return
        }
        if Auth.auth().currentUser!.uid != uid{
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "yourProfile") as! YourProfileView
            newViewController.uid = uid
            self.present(newViewController, animated: true, completion: nil)
        }
        else{
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "main") as! TabSuperview
            newViewController.selectedIndex = 3
            self.present(newViewController, animated: true, completion: nil)
        }
        
    }
    
    @objc func navToResults(sender: UIButton){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "results") as! ResultsViewController
        guard let res = (tableView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as? PollTableViewCell)?.results else{
            return
        }
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
        let cell = tableView.cellForRow(at: indexPath) as! PollTableViewCell
        //let currentUID = Auth.auth().currentUser!.uid
        var option = "0"
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
        cell.choice = option
        DatabaseHelper.addVote(postID: cell.postID, option: option)
        
    }
    
    func setFollowing(count: Int){
        label_following.setTitle("\(String(count)) Following", for: .normal)
    }
    
    func setFollowers(count: Int){
        label_followers.setTitle("\(String(count)) Followers", for: .normal)
    }
    
    func setInfo(user : [String : Any]?){
        if user != nil{
            label_username.text = user?["username"] as? String ?? ""
            label_bio.text = user?["bio"] as? String ?? ""
            label_name.text = user?["name"] as? String ?? ""
        }
        else{
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "main") as! TabSuperview
            self.present(newViewController, animated: true, completion: nil)
        }
    }
    
    @IBAction func settings(sender: UIButton){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "settings") as! SettingsViewController
        self.present(newViewController, animated: true, completion: nil)
    }
    
    @IBAction func followRequests(sender: UIButton){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "followerRequestView") as! FollowerRequestView
        
        newViewController.titleText = "Follow Requests"
        
        self.present(newViewController, animated: true, completion: nil)
        
    }
    
    func doesUserHaveRequest(requests: Bool){
        if(requests) {
            requestsButton.setImage(UIImage(named: "adduser_alert"), for: .normal)
        }
        else{
            requestsButton.setImage(UIImage(named: "adduser"), for: .normal)
        }
    }
    

    @IBAction func seeFollowing(_ sender: UIButton) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "userListView") as! UserListViewController
        
        newViewController.infoRef = "/following/" + Auth.auth().currentUser!.uid
        newViewController.arrName = "following"
        newViewController.titleText = "Following"
        
        self.present(newViewController, animated: true, completion: nil)
    }
    
    
    @IBAction func seeFollowers(_ sender: UIButton) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "userListView") as! UserListViewController
        
        newViewController.infoRef = "/followers/" + Auth.auth().currentUser!.uid
        newViewController.arrName = "followers"
        newViewController.titleText = "Followers"
        
        self.present(newViewController, animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

/*
extension MyProfileView
{
    
}
*/

//
//  UserListViewController.swift
//  PollApp
//
//  Created by Scott Crawshaw on 8/1/19.
//  Copyright © 2019 Crawtech. All rights reserved.
//

import UIKit

class FollowerRequestView: UITableViewController {
    
    var titleText : String = ""
    var tableData : [String : [String]] = [:]
    
    @IBOutlet var navTitle: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if titleText != ""{
            navTitle.title = titleText
            DatabaseHelper.getFollowRequests(callback: populateData)
            tableView.setEmptyMessage1("Loading...")
        }
        else{
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func populateData(result: [String : [String]]){
        //the only key is "results" and its value is an array that looks like this ["/users/dsahjdhj", "/users/shvjadvha"]
        if result["requests"] != nil {
            if result["requests"]!.count > 0{
                tableData = result
                tableView.restore1()
                self.tableView.reloadData()
            }
            else{
                tableView.setEmptyMessage1("No Follow Requests")
            }
        }
        else{
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tableData["requests"]?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! FollowerRequestCell
//        if(tableData["requests"]?[indexPath.row] != nil)
//        {
            var user = tableData["requests"]![indexPath.row]
            user = user.subString(from: 7, to: user.count-1)

            DatabaseHelper.getUserByUID(UID: user, callback: { (result) in
                cell.username_label.text = result?["username"] as? String ?? ""
                cell.name_label.text = result?["name"] as? String ?? ""
            })
            cell.uid = user

//        }
        return cell

        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "yourProfile") as! YourProfileView
        var user = tableData["requests"]![indexPath.row]
        user = user.subString(from: 7, to: user.count-1)
        newViewController.uid = user
        self.present(newViewController, animated: true, completion: nil)
    }
    
    
    @IBAction func goBack(sender: UIBarButtonItem){
        self.dismiss(animated: true, completion: nil)
    }
    
    
}

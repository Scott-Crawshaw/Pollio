//
//  ResultsViewController.swift
//  PollApp
//
//  Created by Scott Crawshaw on 8/11/19.
//  Copyright © 2019 Crawtech. All rights reserved.
//

import UIKit

class ResultsViewController: UITableViewController {

    var uids : [[String]] = []
    var tableData : [[[String : Any]]] = []
        
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.tableView.setEmptyMessage1("Loading...")
        self.tableView.reloadData()
        if uids.count < 2{
            self.dismiss(animated: true, completion: nil)
        }
        for _ in uids{
            tableData.append([])
        }
        print(uids)
        for x in 0...uids.count-1{
            for uid in uids[x]{
                DatabaseHelper.getUserByUID(UID: uid) { (userInfo) in
                    if userInfo != nil{
                        self.tableData[x].append(userInfo!)
                        self.tableView.reloadData()
                        //self.tableView.restore1()
                    }
                }
            }
        }
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        return "test"
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return tableData.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! UserListViewCell
        
        cell.username_label.text = tableData[indexPath.section][indexPath.row]["username"] as? String ?? "error"
        cell.name_label.text = tableData[indexPath.section][indexPath.row]["name"] as? String ?? "error"
        cell.uid = tableData[indexPath.section][indexPath.row]["user"] as? String ?? ""
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "yourProfile") as! YourProfileView
        let user = tableData[indexPath.section][indexPath.row]["uid"] as? String ?? ""
        if user.count < 8 { return }
        newViewController.uid = user.subString(from: 7, to: user.count-1)
        self.present(newViewController, animated: true, completion: nil)
    }
    
    
    @IBAction func goBack(sender: UIBarButtonItem){
        self.dismiss(animated: true, completion: nil)
    }

}

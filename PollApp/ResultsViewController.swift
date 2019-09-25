//
//  ResultsViewController.swift
//  PollApp
//
//  Created by Scott Crawshaw on 8/11/19.
//  Copyright © 2019 Crawtech. All rights reserved.
//

import UIKit
import FirebaseAuth

class ResultsViewController: UITableViewController {

    var uids : [[String]] = []
    var tableData : [[[String : Any]]] = []
    var headers : [String] = []
        
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.tableView.setEmptyMessage1("Loading...")
        self.tableView.reloadData()
        if uids.count < 2{
            self.dismiss(animated: true, completion: nil)
        }
        for _ in uids{
            tableData.append([["username" : "nil"]])
        }
        if uids.count == 0{
            return
        }
        for x in 0...uids.count-1{
            for uid in uids[x]{
                DatabaseHelper.getUserByUID(UID: uid) { (userInfo) in
                    if userInfo != nil{
                        if self.tableData[x][0]["username"] as? String ?? "nil" == "nil"{
                           self.tableData[x].removeAll()
                        }
                        self.tableData[x].append(userInfo!)
                        self.tableView.reloadData()
                    }
                }
            }
        }
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        return headers[section]
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return tableData.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableData[indexPath.section][indexPath.row]["username"] as? String ?? "nil" != "nil"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! UserListViewCell
            
            cell.username_label.text = tableData[indexPath.section][indexPath.row]["username"] as? String ?? "error"
            cell.name_label.text = tableData[indexPath.section][indexPath.row]["name"] as? String ?? "error"
            cell.uid = tableData[indexPath.section][indexPath.row]["user"] as? String ?? ""
            
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "emptyCell", for: indexPath)
        cell.textLabel?.text = "Nobody Voted For This Option"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        guard let uid = tableData[indexPath.section][indexPath.row]["uid"] as? String else{
            return
        }
        if Auth.auth().currentUser!.uid != uid{
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "yourProfile") as! YourProfileView
            let user = uid
            newViewController.uid = user
            self.present(newViewController, animated: true, completion: nil)
        }
        else{
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "main") as! TabSuperview
            newViewController.selectedIndex = 3
            newViewController.modalPresentationStyle = .overFullScreen
            self.present(newViewController, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func goBack(sender: UIBarButtonItem){
        self.dismiss(animated: true, completion: nil)
    }

}

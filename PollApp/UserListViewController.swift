//
//  UserListViewController.swift
//  PollApp
//
//  Created by Scott Crawshaw on 8/1/19.
//  Copyright © 2019 Crawtech. All rights reserved.
//

import UIKit

class UserListViewController: UITableViewController {

    var infoRef : String = ""
    var arrName : String = ""
    var titleText : String = ""
    var tableData : [[String : Any]] = []
    
    @IBOutlet var navTitle: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.setEmptyMessage1("Loading...")
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if infoRef != "" && arrName != "" && titleText != ""{
            navTitle.title = titleText
            DatabaseHelper.getUserList(ref: infoRef, arrName: arrName, callback: populateData)
        }
        else{
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func populateData(result: [[String : Any]]?){
        self.tableView.restore1()
        if result != nil{
            tableData = result!
            self.tableView.reloadData()
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
        return tableData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! UserListViewCell
        print("got cell")
        cell.username_label.text = tableData[indexPath.row]["username"] as? String ?? "error"
        cell.name_label.text = tableData[indexPath.row]["name"] as? String ?? "error"
        cell.uid = tableData[indexPath.row]["user"] as? String ?? ""

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "yourProfile") as! YourProfileView
        newViewController.uid = tableData[indexPath.row]["user"]! as! String
        self.present(newViewController, animated: true, completion: nil)
    }
    
    
    @IBAction func goBack(sender: UIBarButtonItem){
        self.dismiss(animated: true, completion: nil)
    }

}

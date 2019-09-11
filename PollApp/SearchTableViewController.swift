//
//  SearchTableViewController.swift
//  PollApp
//
//  Created by Scott Crawshaw on 7/15/19.
//  Copyright © 2019 Crawtech. All rights reserved.
//

import UIKit
import FirebaseAuth

class SearchTableViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {
    
    var tableData : [[String : Any]] = []
    var resultSearchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        definesPresentationContext = true
        resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            controller.searchBar.placeholder = "Search \"all\" to see everyone"
            
            tableView.tableHeaderView = controller.searchBar
            
            return controller
        })()
        
        resultSearchController.searchBar.delegate = self
        // Reload the table
        self.tableView.tableFooterView = UIView()
        tableView.reloadData()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func dismissSearch() {
        resultSearchController.dismiss(animated: false, completion: nil)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // 1
        // return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 2
        // return the number of rows
        return tableData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 3
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! SearchViewCell
        
        populateCell(cell: cell, indexPath: indexPath)
        
        return cell
    }
    
    func populateCell(cell: SearchViewCell, indexPath: IndexPath){
        var entry : [String : Any] = tableData[indexPath.row]
        

        cell.username_label.text? = entry["username"]! as! String
        cell.name_label.text? = "\(entry["name"]!)"
        cell.mutual_followers.text? = "\(entry["commonFollowersCount"]!) mutual followers"

        cell.uid = entry["user"]! as! String
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        guard let uid = tableData[indexPath.row]["user"] as? String else{
            return
        }
        if uid != Auth.auth().currentUser!.uid{
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
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        DatabaseHelper.searchUsers(search: resultSearchController.searchBar.text!, callback: self.updateData)
        tableView.setEmptyMessage1("Loading...")
        tableData = []
        self.tableView.reloadData()
        dismissSearch()
    }
    
    func updateData(data : [[String : Any]]){
        tableData = data
        if data.count > 0{
            tableView.restore1()
        }
        else{
            tableView.setEmptyMessage1("No Results Found")
        }
        self.tableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        //only would need this if i wanted the table to update for every letter typed
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

extension UITableView {
    
    func setEmptyMessage1(_ message: String) {
        self.separatorStyle = .none
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .gray
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 30)
        messageLabel.sizeToFit()
        self.backgroundView = messageLabel;
        
    }
    
    func restore1() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}

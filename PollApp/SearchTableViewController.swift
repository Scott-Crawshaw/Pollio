//
//  SearchTableViewController.swift
//  PollApp
//
//  Created by Scott Crawshaw on 7/15/19.
//  Copyright © 2019 Crawtech. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {
    
    var tableData : [[String : String]] = []
    var uids : [String] = []
    var resultSearchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            
            tableView.tableHeaderView = controller.searchBar
            
            return controller
        })()
        
        resultSearchController.searchBar.delegate = self
        
        // Reload the table
        tableView.reloadData()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SearchViewCell
        
        populateCell(cell: cell, indexPath: indexPath)
        
        return cell
    }
    
    func populateCell(cell: SearchViewCell, indexPath: IndexPath){
        var entry : [String : String] = tableData[indexPath.row]
        let mutualFollowerCount: Int = 0 //retrieve mutual followers per person and return here
        cell.username_label.text? = entry["username"]!
        cell.name_label.text? = "\(entry["name"]!)"
        cell.mutual_followers.text? = "\(mutualFollowerCount) mutual followers"

        cell.uid = entry["user"]!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "yourProfile") as! YourProfileView
        newViewController.uid = tableData[indexPath.row]["user"]!
        self.present(newViewController, animated: true, completion: nil)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        DatabaseHelper.searchUsers(search: resultSearchController.searchBar.text!, callback: self.updateData)
    }
    
    func updateData(data : [[[String : String]]]){
        tableData.removeAll(keepingCapacity: false)
        uids.removeAll(keepingCapacity: false)
        for array in data{
            for entry in array{
                if !(uids.contains(entry["user"]!)){
                    uids.append(entry["user"]!)
                    tableData.append(entry)
                }
                
            }
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

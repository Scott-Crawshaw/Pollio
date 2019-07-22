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

class FeedTableViewController: UITableViewController {

    var data : [[String : Any]] = []
    var postLinks : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.tableView.dataSource = self
        
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
            }
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell", for: indexPath) as! PollTableViewCell

        return self.modifyCell(cell: cell, indexPath: indexPath)
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

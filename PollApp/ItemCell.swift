//
//  ItemCell.swift
//  PollApp
//
//  Created by Ben Stewart on 7/9/19.
//  Copyright © 2019 Crawtech. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {

    @IBOutlet weak var adder: UIButton!
    var num_idData = UserDefaults.standard.array(forKey: "number_idData")
    var cellNum: String = ""

    @IBAction func contactSelected(sender: UIButton)
    {
        adder.backgroundColor = .black
        for person in num_idData!{
            let p = person as! [String:String]
            if p["number"] == cellNum {
                var selectedUsers = UserDefaults.standard.array(forKey: "selectedUsers") as! [String]
                selectedUsers.append(p["userID"] ?? "Unknown")
                UserDefaults.standard.set(selectedUsers, forKey: "selectedUsers")
                print(selectedUsers)
            }
        }
        
        
        
       // UserDefaults.standard.array
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

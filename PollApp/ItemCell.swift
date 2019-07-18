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
        for person in num_idData!{
            let p = person as! [String:String]
            if p["number"] == cellNum {
                var selectedUsers = UserDefaults.standard.array(forKey: "selectedUsers") as! [String]
                if(adder.isSelected == false)
                {
                    selectedUsers.append(p["user"] ?? "Unknown")
                    UserDefaults.standard.set(selectedUsers, forKey: "selectedUsers")
                    adder.isSelected = true
                }
                else{
                    let index = selectedUsers.firstIndex(of: p["user"]!)!
                    selectedUsers.remove(at: index)
                    UserDefaults.standard.set(selectedUsers, forKey: "selectedUsers")
                    adder.isSelected = false
                }
                
                //Below are print statements to check that the number/id/cellnumber swap is going ok.
                /*
                print("p[number] from num_idData is: \(String(describing: p["number"]))")
                print("cellNum is: \(cellNum)")
                print(selectedUsers)
                print("num_idData being loaded as: \(num_idData)")*/
                
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

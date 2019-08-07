//
//  UserListViewCell.swift
//  PollApp
//
//  Created by Scott Crawshaw on 8/1/19.
//  Copyright © 2019 Crawtech. All rights reserved.
//

import UIKit

class UserListViewCell: UITableViewCell {

    var uid : String = ""
    
    @IBOutlet var username_label: UILabel!
    @IBOutlet var name_label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}







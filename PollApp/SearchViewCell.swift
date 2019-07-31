//
//  SearchViewCell.swift
//  PollApp
//
//  Created by Scott Crawshaw on 7/31/19.
//  Copyright © 2019 Crawtech. All rights reserved.
//

import UIKit

class SearchViewCell: UITableViewCell {

    var uid : String = ""

    @IBOutlet weak var username_label: UILabel!
    @IBOutlet weak var name_label: UILabel!
    @IBOutlet weak var mutual_followers: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//
//  PollTableViewCell.swift
//  PollApp
//
//  Created by Scott Crawshaw on 7/18/19.
//  Copyright © 2019 Crawtech. All rights reserved.
//

import UIKit

class PollTableViewCell: UITableViewCell {

    @IBOutlet var choice4_bar: UILabel!
    @IBOutlet var choice3_bar: UILabel!
    @IBOutlet var choice2_bar: UILabel!
    @IBOutlet var choice1_bar: UILabel!
    @IBOutlet var comments_button: UIButton!
    @IBOutlet var choice4_button: UIButton!
    @IBOutlet var choice3_button: UIButton!
    @IBOutlet var choice2_button: UIButton!
    @IBOutlet var choice1_button: UIButton!
    @IBOutlet var choice4_text: UILabel!
    @IBOutlet var choice3_text: UILabel!
    @IBOutlet var choice2_text: UILabel!
    @IBOutlet var choice1_text: UILabel!
    @IBOutlet var question: UILabel!
    @IBOutlet var visibility: UILabel!
    @IBOutlet var time: UILabel!
    @IBOutlet var username: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

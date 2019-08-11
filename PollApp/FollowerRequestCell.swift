//
//  FollowerRequestCell.swift
//  PollApp
//
//  Created by Scott Crawshaw on 8/1/19.
//  Copyright © 2019 Crawtech. All rights reserved.
//

import UIKit
import FirebaseAuth

class FollowerRequestCell: UITableViewCell {
    
    var uid : String = ""
    
    @IBOutlet weak var username_label: UILabel!
    @IBOutlet weak var name_label: UILabel!
    @IBOutlet weak var accept_button: UIButton!
    @IBOutlet weak var decline_button: UIButton!
    @IBOutlet weak var request_button: RequestFollowButtonClass!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        request_button.isHidden = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    @IBAction func acceptedButton(_ sender: UIButton) {
        DatabaseHelper.acceptFollowRequest(requestUID: uid)
        //DatabaseHelper.getFollowingState(followerUID: Auth.auth().currentUser!.uid, followingUID: uid, callback: buttonDecision)
        request_button.createdBySuperview(id: uid)

        accept_button.isHidden = true
        decline_button.isHidden = true
        request_button.isHidden = false
    }

    @IBAction func declineButton(_ sender: UIButton) {
        DatabaseHelper.declineFollowRequest(requestUID: uid)
        //DatabaseHelper.getFollowingState(followerUID: Auth.auth().currentUser!.uid, followingUID: uid, callback: buttonDecision)
        request_button.createdBySuperview(id: uid)

        accept_button.isHidden = true
        decline_button.isHidden = true
        request_button.isHidden = false

    }
    
    
    @IBAction func sendRequestToButton(_ sender: RequestFollowButtonClass) {
        request_button.buttonPressed(sender)
    }
    
}







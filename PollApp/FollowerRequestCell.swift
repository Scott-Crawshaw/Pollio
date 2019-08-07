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
    @IBOutlet weak var request_button: UIButton!
    @IBOutlet weak var inactiveFollowing_button: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        inactiveFollowing_button.isHidden = true
        request_button.isHidden = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    @IBAction func acceptedButton(_ sender: UIButton) {
        
        DatabaseHelper.acceptFollowRequest(requestUID: uid)
        DatabaseHelper.getFollowingState(followerUID: Auth.auth().currentUser!.uid, followingUID: uid, callback: buttonDecision)
         
         accept_button.isHidden = true
         decline_button.isHidden = true
         
         inactiveFollowing_button.isHidden = false
         
         
         
         accept_button.isHidden = true
         decline_button.isHidden = true
         request_button.isHidden = false
        
        
        
    }
 
    func buttonDecision(state: Int){ //0 = not following, 1 = requested, 2 = currently following
        
    }
        
    @IBAction func declineButton(_ sender: UIButton) {
    
        /*if(user is already following the requester)
         {
         accept_button.isHidden = true
         decline_button.isHidden = true
         send decline request
         inactiveFollowing_button.isHidden = false
         }
         
         else
         {
         accept_button.isHidden = true
         decline_button.isHidden = true
         send decline request
         request_button.isHidden = false
         }
         */
    }
    
    
    
}







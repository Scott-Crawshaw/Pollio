//
//  RequestFollowButtonClass.swift
//  PollApp
//
//  Created by Ben Stewart on 8/6/19.
//  Copyright © 2019 Crawtech. All rights reserved.
//
import FirebaseAuth
import UIKit

class RequestFollowButtonClass: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var uid : String = ""
    var followState : Int = 0
    
    func createdBySuperview(id: String)
    {
        uid = id
        DatabaseHelper.getFollowingState(followerUID: Auth.auth().currentUser!.uid, followingUID: uid, callback: setButtonStatus)

    }
    
    func setButtonStatus(state: Int){
        if(state == 0) // not following
        {
            self.setTitle("Request to Follow", for: .normal)
            followState = state
        }
        if(state == 1) // requested
        {
            self.setTitle("Requested", for: .normal)
            followState = state
        }
        if(state == 2) // currently following
        {
            self.setTitle("Following", for: .normal)
            followState = state
        }
        
    }
    
    func buttonPressed(_ sendy: RequestFollowButtonClass)
    {
        if(followState == 0) // not following
        {
            DatabaseHelper.addFollowRequest(followUID: uid)
            setButtonStatus(state: 1)
        }
        
        if(followState == 1) // requested
        {
            self.setTitle("Requested", for: .normal)
        }
        

        if(followState == 3) //officially unfriended, see ya later
        {
            DatabaseHelper.unfollowUser(user: uid)
            setButtonStatus(state: 0)
        }
        
        if(followState == 2) // currently following
        {
            self.setTitle("Unfollow?", for: .normal)
            followState = 3 //ready to unfollow
        }
        
        
    }
}

//
//  RequestFollowButtonClass.swift
//  PollApp
//
//  Created by Ben Stewart on 8/6/19.
//  Copyright © 2019 Crawtech. All rights reserved.
//

import UIKit

class RequestFollowButtonClass: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    override func awakeFromNib() {
        //There needs to be 3 different states of a user's relationship with another
        //Not Following, Requested, and Following -- the button class needs to display different things for these:
        
        //IF FOLLOWING
        //check database OR userdefaults if you (the main user) is following someone else
        //if so, display "Following" on profile and remove user interaction
        self.setTitle("Following", for: .normal)
        
        //Requested
        self.setTitle("Requested", for: .normal)
        
        //Not Following
        self.setTitle("Request to Follow", for: .normal)
    }
}

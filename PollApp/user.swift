//
//  user.swift
//  PollApp
//
//  Created by Scott Crawshaw on 6/21/19.
//  Copyright © 2019 Crawtech. All rights reserved.
//

import Foundation

class User{
    var username, name, picture, followers, following, posts : String?
    
    init(){}
    
    func update(username : String, name : String, picture : String, followers : String, following : String, posts : String){
        self.username = username
        self.name = name
        self.picture = picture
        self.followers = followers
        self.following = following
        self.posts = posts
    }
}

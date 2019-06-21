//
//  API.swift
//  PollApp
//
//  Created by Scott Crawshaw on 6/21/19.
//  Copyright © 2019 Crawtech. All rights reserved.
//

import Foundation
import FirebaseDatabase

class DatabaseHelper{
    var ref: DatabaseReference!

    init(){
        self.ref = Database.database().reference()
    }
    
    func getUserByUID(UID: String) -> User{
        let user : User = User()
        ref.child("users").child(UID).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let username = value?["username"] as? String ?? ""
            let name = value?["name"] as? String ?? ""
            let followers = value?["followers"] as? String ?? ""
            let following = value?["following"] as? String ?? ""
            let picture = value?["picture"] as? String ?? ""
            let posts = value?["posts"] as? String ?? ""
            user.update(username: username, name: name, picture: picture, followers: followers, following: following, posts: posts)
        }) { (error) in
            print(error.localizedDescription)
        }
        return user

    }

}

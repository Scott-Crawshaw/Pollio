//
//  YourProfileView.swift
//  PollApp
//
//  Created by Ben Stewart on 7/29/19.
//  Copyright © 2019 Crawtech. All rights reserved.
//

import UIKit

class YourProfileView: UIViewController {
    
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var label_username: UILabel!
    @IBOutlet weak var label_bio: UILabel!
    @IBOutlet weak var label_name: UILabel!
    @IBOutlet weak var label_following: UIButton!
    @IBOutlet weak var label_followers: UIButton!
    
    var followers: Int = 0
    var following: Int = 0
    
    override func viewDidLoad() { // Initialize Profile View for OTHER USERS
        super.viewDidLoad()
        tabBar.selectedItem = tabBar.items?.first
        
        //Need to pull down user data from database
        
        //These will set following/er count once database pulls numbers into the Ints following/followers
        label_followers.setTitle("\(String(describing: followers)) Followers", for: .normal)
        label_following.setTitle("\(String(describing: following)) Following", for: .normal)
        
        
        // Do any additional setup after loading the view.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

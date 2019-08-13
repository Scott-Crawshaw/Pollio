//
//  TabSuperview.swift
//  PollApp
//
//  Created by Ben Stewart on 7/18/19.
//  Copyright © 2019 Crawtech. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class TabSuperview: UITabBarController {
    
    
    @IBOutlet var tab: [UITabBar]!
    var listeners : [ListenerRegistration] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        listeners.append(DatabaseHelper.hasFollowRequestsListener(callback: addBadge))
    }
    
    func addBadge(val: Bool)
    {
        if(val) {
            tab.first?.items?.last?.badgeValue = "!"
        }
        else{
            tab.first?.items?.last?.badgeValue = nil
        }
        
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

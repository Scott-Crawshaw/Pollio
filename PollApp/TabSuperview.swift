//
//  TabSuperview.swift
//  PollApp
//
//  Created by Ben Stewart on 7/18/19.
//  Copyright © 2019 Crawtech. All rights reserved.
//

import UIKit
import FirebaseAuth

class TabSuperview: UITabBarController {
    
    
    @IBOutlet var tab: [UITabBar]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        DatabaseHelper.hasFollowRequests(callback: addBadge)
        
//        for elements in tab
//        {
//            print(elements.items)
//        }
       
        // Do any additional setup after loading the view.
    }
    func addBadge(val: Bool)
    {
        if(val == true) {
            tab.first?.items?.last?.badgeValue = "!"
        }
        
    }
//
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

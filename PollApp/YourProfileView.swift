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
    
    @IBOutlet var back_button: UIButton!
    
    var uid : String = ""
    
    override func viewDidLoad() { // Initialize Profile View for OTHER USERS
        super.viewDidLoad()
        tabBar.selectedItem = tabBar.items?.first
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DatabaseHelper.getUserByUID(UID: uid, callback: setInfo)
        DatabaseHelper.getFollowingCount(UID: uid, callback: setFollowing)
        DatabaseHelper.getFollowersCount(UID: uid, callback: setFollowers)
    }
    
    func setFollowing(count: Int){
        label_following.setTitle("\(String(count)) Following", for: .normal)
    }
    
    func setFollowers(count: Int){
        label_followers.setTitle("\(String(count)) Followers", for: .normal)
    }
    
    func setInfo(user : [String : Any]?){
        if user != nil{
            label_username.text = user?["username"] as? String ?? ""
            label_bio.text = user?["bio"] as? String ?? ""
            label_name.text = user?["name"] as? String ?? ""
        }
        else{
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "main") as! TabSuperview
            self.present(newViewController, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func goBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
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

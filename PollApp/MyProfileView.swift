//
//  MyProfileView.swift
//  PollApp
//
//  Created by Ben Stewart on 7/29/19.
//  Copyright © 2019 Crawtech. All rights reserved.
//

import UIKit
import FirebaseAuth

class MyProfileView: UIViewController {
    
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var label_username: UILabel!
    @IBOutlet weak var label_bio: UILabel!
    @IBOutlet weak var label_name: UILabel!
    @IBOutlet weak var label_following: UIButton!
    @IBOutlet weak var label_followers: UIButton!
    
    let userID : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.selectedItem = tabBar.items?.first
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DatabaseHelper.getUserByUID(UID: Auth.auth().currentUser!.uid, callback: setInfo)
        DatabaseHelper.getFollowingCount(UID: Auth.auth().currentUser!.uid, callback: setFollowing)
        DatabaseHelper.getFollowersCount(UID: Auth.auth().currentUser!.uid, callback: setFollowers)
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
    
    @IBAction func settings(sender: UIButton){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "settings") as! SettingsViewController
        self.present(newViewController, animated: true, completion: nil)
    }
    

    @IBAction func seeFollowing(_ sender: UIButton) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "settings") as! SettingsViewController
        self.present(newViewController, animated: true, completion: nil)
    }
    
    
    @IBAction func seeFollowers(_ sender: UIButton) {
        
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

/*
extension MyProfileView
{
    
}
*/

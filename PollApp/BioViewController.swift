//
//  BioViewController.swift
//  PollApp
//
//  Created by Scott Crawshaw on 7/30/19.
//  Copyright © 2019 Crawtech. All rights reserved.
//

import UIKit
import FirebaseAuth

class BioViewController: UIViewController, UITextViewDelegate {

    @IBOutlet var bioTextView : UITextView!
    
    @IBOutlet var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setting up Text Field
        bioTextView.delegate = self
        bioTextView.layer.borderWidth = 3
        bioTextView.layer.borderColor = UIColor .darkGray .cgColor
        
        //setting up Button
        

        //submitButton.layer.borderWidth = 3
        //submitButton.layer.borderColor = UIColor .darkGray .cgColor
        submitButton.layer.cornerRadius = 3.5
        
        
        

        // Do any additional setup after loading the view.
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //setGradientBackground()
        super.viewWillAppear(animated)
        DatabaseHelper.getUserByUID(UID: Auth.auth().currentUser!.uid, callback: loadBio)
    }
    
    func loadBio(user : [String : Any]?){
        bioTextView.text = user?["bio"] as? String ?? ""
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars < 100    // 70 Limit Value
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitBio(_ sender: UIButton) {
        DatabaseHelper.editBio(bio: bioTextView.text)
        self.dismiss(animated: true, completion: nil)
    }
    /*
    func setGradientBackground() {
        let colorTop =  UIColor(red: 212/255.0, green: 119/255.0, blue: 230/255.0, alpha: 0.9).cgColor
        let colorBottom = UIColor(red: 161/255.0, green: 84/255.0, blue: 194/255.0, alpha: 1.0).cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop,colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.view.bounds
        
        self.view.layer.insertSublayer(gradientLayer, at:0)
    }
 */
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  VerifyViewController.swift
//  PollApp
//
//  Created by Scott Crawshaw on 6/18/19.
//  Copyright © 2019 Crawtech. All rights reserved.
//

import UIKit
import FirebaseAuth

class VerifyViewController: UIViewController {
    @IBOutlet var code: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        setGradientBackground()
        super.viewWillAppear(animated)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func submitCode(sender: UIButton) {
        let verificationCode = String(code.text!)
        let verificationID = String(UserDefaults.standard.string(forKey: "authVerificationID")!)

        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID,
            verificationCode: verificationCode)
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                self.showMessagePrompt(message: error.localizedDescription)
                return
            }
            
            //here is where we should do something with authResult
            //DatabaseHelper.getUserByUID(UID: (authResult?.user.uid)!, callback: self.testCallback)
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "SlideViewController") as! SlideViewController
            self.present(newViewController, animated: true, completion: nil)
//            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//            let newViewController = storyBoard.instantiateViewController(withIdentifier: "PollCreatorViewController") as! PollCreatorViewController
//            self.present(newViewController, animated: true, completion: nil)
        }
    }
    
    /*
    func testCallback(dict: Dictionary<String, Any>?){
        self.showMessagePrompt(message: dict!.description)
    }
     */
    
    func showMessagePrompt(message: String){
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Button", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func setGradientBackground() {
        let colorTop =  UIColor(red: 212/255.0, green: 119/255.0, blue: 230/255.0, alpha: 0.9).cgColor
        let colorBottom = UIColor(red: 161/255.0, green: 84/255.0, blue: 194/255.0, alpha: 1.0).cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop,colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.view.bounds
        
        self.view.layer.insertSublayer(gradientLayer, at:0)
    }
}

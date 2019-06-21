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
    @IBOutlet weak var code: UITextField!
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = "Enter Your Verification Code"
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
            let helper : DatabaseHelper = DatabaseHelper()
            let user = helper.getUserByUID(UID: (authResult?.user.uid)!)
            self.showMessagePrompt(message: user.name ?? "no name")
        }
    }
    
    func showMessagePrompt(message: String){
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Button", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}

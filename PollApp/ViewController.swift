//
//  ViewController.swift
//  PollApp
//
//  Created by Scott Crawshaw on 6/17/19.
//  Copyright © 2019 Crawtech. All rights reserved.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {

    @IBOutlet weak var field: UITextField!
    @IBOutlet weak var label: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        label.text = "Enter Your Phone Number"
    }
    
    @IBAction func sendText(sender: UIButton) {
        var number = String(field.text!).filter("01234567890".contains)
        if number.count == 10 {
            number = "1" + number
        }
        number = "+" + number
        
        PhoneAuthProvider.provider().verifyPhoneNumber(number, uiDelegate: nil) { (verificationID, error) in
            if let error = error {
                self.showMessagePrompt(message: error.localizedDescription)
                return
            }
            UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let resultViewController = storyBoard.instantiateViewController(withIdentifier: "VerifyViewController") as! VerifyViewController
            
            self.present(resultViewController, animated:true, completion:nil)
        }
    }
    
    func showMessagePrompt(message: String){
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Button", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }


}


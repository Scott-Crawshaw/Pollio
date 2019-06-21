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


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

    }
    
    override func viewWillAppear(_ animated: Bool) {
        setGradientBackground()
        super.viewWillAppear(animated)
    }
    
    @IBAction func sendText(sender: UIButton) {
        var number = String(field.text!).filter("01234567890".contains)
        
        if number.count == 10 {
            number = "1" + number
        }
        number = "+" + number
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let resultViewController = storyBoard.instantiateViewController(withIdentifier: "VerifyViewController") as! VerifyViewController
        
        self.present(resultViewController, animated:true, completion:nil)
        
        PhoneAuthProvider.provider().verifyPhoneNumber(number, uiDelegate: nil) { (verificationID, error) in
            if let error = error {
                self.showMessagePrompt(message: error.localizedDescription)
                return
            }
            UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
            

        }
    }
    
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


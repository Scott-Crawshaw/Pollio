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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setGradientBackground()
        super.viewWillAppear(animated)
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.synchronize()
    }
    
    @IBAction func sendText(sender: UIButton) {
        var number = String(field.text!).filter("01234567890".contains)
        if number.count < 10{
            let alert = UIAlertController(title: "Invalid Phone Number", message: "The phone number you entered is invalid. Please try again.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
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
    
    @IBAction func textFieldDidBeginEditing(_ textField: UITextField) {
        animateViewMoving(up: true, moveValue: 100)
    }
    
    @IBAction func textFieldDidEndEditing(_ textField: UITextField) {
        animateViewMoving(up: false, moveValue: 100)
    }
    
    func animateViewMoving (up:Bool, moveValue :CGFloat){
        let movementDuration:TimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
    


}


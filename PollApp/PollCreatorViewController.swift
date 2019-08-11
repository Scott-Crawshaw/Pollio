//
//  PollCreatorViewController.swift
//  PollApp
//
//  Created by Scott Crawshaw on 7/8/19.
//  Copyright © 2019 Crawtech. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class PollCreatorViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var questionView: UITextView!
    @IBOutlet weak var addChoice3: UIButton!
    @IBOutlet weak var addChoice4: UIButton!
    @IBOutlet weak var choice1: UITextField!
    @IBOutlet weak var choice2: UITextField!
    @IBOutlet weak var choice3: UITextField!
    @IBOutlet weak var choice4: UITextField!
    @IBOutlet weak var visibility: UISegmentedControl!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionView.delegate = self
        questionView.text = "Enter your question here"
        questionView.textColor = UIColor.lightGray
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setGradientBackground()
        super.viewWillAppear(animated)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    @IBAction func moreInformation(sender: UIButton){
        let message = "Public: You & your followers can see who voted for each choice.\n\n Private: Only you can see who voted for each choice.\n\n Anonymous: Nobody can see who voted for each choice."
        let alert = UIAlertController(title: "Results Visibility", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
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
    
    @IBAction func textFieldDidBeginEditing2(_ textField: UITextField) {
        animateViewMoving(up: true, moveValue: 100)
    }
    
    @IBAction func textFieldDidEndEditing2(_ textField: UITextField) {
        animateViewMoving(up: false, moveValue: 100)
    }
    
    @IBAction func textFieldDidBeginEditing3(_ textField: UITextField) {
        animateViewMoving(up: true, moveValue: 150)
    }
    
    @IBAction func textFieldDidEndEditing3(_ textField: UITextField) {
        animateViewMoving(up: false, moveValue: 150)
    }
    
    @IBAction func textFieldDidBeginEditing4(_ textField: UITextField) {
        animateViewMoving(up: true, moveValue: 200)
    }
    
    @IBAction func textFieldDidEndEditing4(_ textField: UITextField) {
        animateViewMoving(up: false, moveValue: 200)
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
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if questionView.textColor == UIColor.lightGray {
            questionView.text = ""
            questionView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if questionView.text == "" {
            
            questionView.text = "Enter your question here ..."
            questionView.textColor = UIColor.lightGray
        }
    }
    
    @IBAction func addChoice(sender: UIButton){ //342, 32
        if sender == addChoice3{
            choice3.isHidden = false
            addChoice3.isHidden = true
            addChoice4.isHidden = false
        }
        if sender == addChoice4{
            choice4.isHidden = false
            addChoice4.isHidden = true
        }
    }
    
    @IBAction func addPost(sender: UIButton){
        if choice1.text?.isEmpty == true || choice2.text?.isEmpty == true || questionView.text?.isEmpty == true{
            let message = "Polls must have a question and at least two choices. Make sure your poll contains all the required information."
            let alert = UIAlertController(title: "Missing Information", message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            let author = "/users/" + Auth.auth().currentUser!.uid
            let image = ""
            var options = [choice1.text, choice2.text]
            var results : [String : [String]] = ["0" : [], "1" : []]
            if choice3.text?.isEmpty == false{
                options.append(choice3.text)
                results["2"] = []
            }
            if choice4.text?.isEmpty == false{
                options.append(choice4.text)
                results["3"] = []
            }
            
            let question : String = questionView.text
            let time = Timestamp()
            var visibilityOpts : [String: Bool] = ["author" : false, "viewers": false]
        
            if visibility.selectedSegmentIndex == 0{
                visibilityOpts = ["author" : true, "viewers": true]
            }
            
            if visibility.selectedSegmentIndex == 1{
                visibilityOpts = ["author" : true, "viewers": false]
            }

            let data : [String : Any] = [
                "author" : author,
                "image" : image,
                "options" : options,
                "question" : question,
                "time" : time,
                "visibility" : visibilityOpts,
                "results" : results
            ]
        
            DatabaseHelper.addPost(data: data)
            
            
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

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
    @IBOutlet weak var visibilityPicker: UISegmentedControl!

    
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
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if questionView.textColor == UIColor.lightGray {
            questionView.text = ""
            questionView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if questionView.text == "" {
            
            questionView.text = "Placeholder text ..."
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
        let author = "/users/" + Auth.auth().currentUser!.uid
        let image = ""
        var options = [choice1.text, choice2.text]
        if choice3.text?.isEmpty == false{
            options.append(choice3.text)
        }
        if choice4.text?.isEmpty == false{
            options.append(choice4.text)
        }
        let question : String = questionView.text
        let time = Timestamp()
        var visibility : [String: Bool] = ["author" : false, "viewers": false]
        
        if visibilityPicker.selectedSegmentIndex == 0{
            visibility = ["author" : true, "viewers": true]
        }
        if visibilityPicker.selectedSegmentIndex == 1{
            visibility = ["author" : true, "viewers": false]
        }
        
        let comments = ""
        let votes = ""
        
        let data : [String : Any] = [
            "author" : author,
            "comments" : comments,
            "image" : image,
            "options" : options,
            "question" : question,
            "time" : time,
            "visibility" : visibility,
            "votes" : votes
        ]
        
        DatabaseHelper.addPost(data: data)
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

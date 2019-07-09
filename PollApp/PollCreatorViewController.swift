//
//  PollCreatorViewController.swift
//  PollApp
//
//  Created by Scott Crawshaw on 7/8/19.
//  Copyright © 2019 Crawtech. All rights reserved.
//

import UIKit

class PollCreatorViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var questionView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionView.delegate = self
        questionView.text = "Enter your question here"
        questionView.textColor = UIColor.lightGray

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setGradientBackground()
        super.viewWillAppear(animated)
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
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

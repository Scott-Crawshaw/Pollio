//
//  FeedbackViewController.swift
//  PollApp
//
//  Created by Scott Crawshaw on 9/2/19.
//  Copyright © 2019 Crawtech. All rights reserved.
//

import UIKit

class FeedbackViewController: UIViewController {

    @IBOutlet var submitButton: UIButton!
    @IBOutlet var feedTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        feedTextView.layer.borderWidth = 3
        feedTextView.layer.borderColor = UIColor .darkGray .cgColor
        
        submitButton.layer.cornerRadius = 3.5
        

    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitFeedback(_ sender: UIButton) {
        DatabaseHelper.submitFeedback(feedback: feedTextView.text)
        self.dismiss(animated: true, completion: nil)
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

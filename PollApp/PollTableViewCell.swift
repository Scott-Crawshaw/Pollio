//
//  PollTableViewCell.swift
//  PollApp
//
//  Created by Scott Crawshaw on 7/18/19.
//  Copyright © 2019 Crawtech. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class PollTableViewCell: UITableViewCell {

    @IBOutlet var choice4_button: UIButton!
    @IBOutlet var choice3_button: UIButton!
    @IBOutlet var choice2_button: UIButton!
    @IBOutlet var choice1_button: UIButton!
    @IBOutlet var choice4_text: UILabel!
    @IBOutlet var choice3_text: UILabel!
    @IBOutlet var choice2_text: UILabel!
    @IBOutlet var choice1_text: UILabel!
    @IBOutlet var question: UILabel!
    @IBOutlet var visibility: UILabel!
    @IBOutlet var time: UILabel!
    @IBOutlet var username: UILabel!
    @IBOutlet var resultsButton: UIButton!
    @IBOutlet var cellView: UIView!
    @IBOutlet var cView: UIView!
    @IBOutlet var choice1_view: UIView!
    @IBOutlet var choice2_view: UIView!
    @IBOutlet var choice3_view: UIView!
    @IBOutlet var choice4_view: UIView!
    var results : [String : [String]]!
    var choice = "-1"
    var commentsDoc : String!
    var postID : String!
    var listener : ListenerRegistration!
    var currentUser : String!
    var authorUID : String!
    var visibilityNum : Int!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func generateListener(){
        if postID == nil || postID.count == 0{
            return
        }
        
        listener = DatabaseHelper.getPostByIDListener(ID: postID, callback: updateResults)
        
    }
    
    func updateResults(data : [String : Any]?){
        if data == nil{
            return
        }
        
        results = data?["results"] as? [String : [String]] ?? results
        for (c, votes) in results {
            if votes.contains(currentUser){
                choice = c
                showResults()
                return
            }
        }
    }
    
    func resetCell(){
        self.isHidden = false
        if listener != nil{
            listener.remove()
            listener = nil
        }
        
        resultsButton.backgroundColor = UIColor(red: 111/255, green: 113/255, blue: 121/255, alpha: 0.5)
        resultsButton.isEnabled = false
        
        choice1_button.isHidden = false
        choice2_button.isHidden = false
        choice3_button.isHidden = false
        choice4_button.isHidden = false
        
        choice1_button.isEnabled = true
        choice2_button.isEnabled = true
        choice3_button.isEnabled = true
        choice4_button.isEnabled = true
        
        choice1_view.isHidden = true
        choice2_view.isHidden = true
        choice3_view.isHidden = true
        choice4_view.isHidden = true
        
        let barHeight = choice1_button.frame.height
        choice1_view.frame.size = CGSize(width: 0, height: barHeight)
        choice2_view.frame.size = CGSize(width: 0, height: barHeight)
        choice3_view.frame.size = CGSize(width: 0, height: barHeight)
        choice4_view.frame.size = CGSize(width: 0, height: barHeight)
        
        choice1_view.layoutIfNeeded()
        choice2_view.layoutIfNeeded()
        choice3_view.layoutIfNeeded()
        choice4_view.layoutIfNeeded()
        
        choice1_text.isHidden = false
        choice2_text.isHidden = false
        choice3_text.isHidden = false
        choice4_text.isHidden = false
        
        choice1_button.layer.borderWidth = 0.0
        choice2_button.layer.borderWidth = 0.0
        choice3_button.layer.borderWidth = 0.0
        choice4_button.layer.borderWidth = 0.0
        
        choice = "-1"
    
    }
    
    
    func showResults(){
        var totalVotes : Float = 0.0
        for (_, votes) in results{
            print(votes)
            totalVotes += Float(votes.count)
        }

        let fullWidth = choice1_button.frame.width
        let fullHeight = choice1_button.frame.height
        let animationLength = 1.0
        
        self.choice1_button.layer.borderWidth = 0
        self.choice2_button.layer.borderWidth = 0
        self.choice3_button.layer.borderWidth = 0
        self.choice4_button.layer.borderWidth = 0
        
        
        if (visibilityNum == 0) || (visibilityNum == 1 && authorUID == currentUser){
            resultsButton.isEnabled = true
            resultsButton.backgroundColor = UIColor(red: 111/255, green: 113/255, blue: 121/255, alpha: 1)
        }
        if results.count == 2{
            print(Float(results["0"]!.count).description + ", " + totalVotes.description)
            let firstBarPercent = Float(results["0"]!.count) / totalVotes
            let secondBarPercent = Float(results["1"]!.count) / totalVotes
            print(firstBarPercent.description + ", " + secondBarPercent.description)
            UIView.animate(withDuration: animationLength) {
                self.choice2_view.frame.size = CGSize(width: fullWidth * CGFloat(firstBarPercent), height: fullHeight)
                self.choice2_view.isHidden = false
                self.choice2_view.layoutIfNeeded()
                
                self.choice3_view.frame.size = CGSize(width: fullWidth * CGFloat(secondBarPercent), height: fullHeight)
                self.choice3_view.isHidden = false
                self.choice3_view.layoutIfNeeded()
                
                if self.choice == "0"{
                    self.choice2_button.layer.borderColor = UIColor.black.cgColor
                    self.choice2_button.layer.borderWidth = 1
                }
                if self.choice == "1"{
                    self.choice3_button.layer.borderColor = UIColor.black.cgColor
                    self.choice3_button.layer.borderWidth = 1
                }
                self.cView.layoutIfNeeded()

            }
            
        }
        if results.count == 3{
            let firstBarPercent = Float(results["0"]!.count) / totalVotes
            let secondBarPercent = Float(results["1"]!.count) / totalVotes
            let thirdBarPercent = Float(results["2"]!.count) / totalVotes
            UIView.animate(withDuration: animationLength) {
                
            self.choice2_view.frame.size = CGSize(width: fullWidth * CGFloat(firstBarPercent), height: fullHeight)
            self.choice2_view.isHidden = false
            self.choice2_view.layoutIfNeeded()
            
            self.choice3_view.frame.size = CGSize(width: fullWidth * CGFloat(secondBarPercent), height: fullHeight)
            self.choice3_view.isHidden = false
            self.choice3_view.layoutIfNeeded()
            
            self.choice4_view.frame.size = CGSize(width: fullWidth * CGFloat(thirdBarPercent), height: fullHeight)
            self.choice4_view.isHidden = false
            self.choice4_view.layoutIfNeeded()
            
            if self.choice == "0"{
                self.choice2_button.layer.borderColor = UIColor.black.cgColor
                self.choice2_button.layer.borderWidth = 1
            }
            if self.choice == "1"{
                self.choice3_button.layer.borderColor = UIColor.black.cgColor
                self.choice3_button.layer.borderWidth = 1
            }
            if self.choice == "2"{
                self.choice4_button.layer.borderColor = UIColor.black.cgColor
                self.choice4_button.layer.borderWidth = 1
            }
                
            }
            
        }
        if results.count == 4{
            let firstBarPercent = Float(results["0"]!.count) / totalVotes
            let secondBarPercent = Float(results["1"]!.count) / totalVotes
            let thirdBarPercent = Float(results["2"]!.count) / totalVotes
            let fourthBarPercent = Float(results["3"]!.count) / totalVotes

            UIView.animate(withDuration: animationLength) {
                
            self.choice1_view.frame.size = CGSize(width: fullWidth * CGFloat(firstBarPercent), height: fullHeight)
            self.choice1_view.isHidden = false
            self.choice1_view.layoutIfNeeded()
            
            self.choice2_view.frame.size = CGSize(width: fullWidth * CGFloat(secondBarPercent), height: fullHeight)
            self.choice2_view.isHidden = false
            self.choice2_view.layoutIfNeeded()
            
            self.choice3_view.frame.size = CGSize(width: fullWidth * CGFloat(thirdBarPercent), height: fullHeight)
            self.choice3_view.isHidden = false
            self.choice3_view.layoutIfNeeded()
                
            self.choice4_view.frame.size = CGSize(width: fullWidth * CGFloat(fourthBarPercent), height: fullHeight)
            self.choice4_view.isHidden = false
            self.choice4_view.layoutIfNeeded()
            
            if self.choice == "0"{
                self.choice1_button.layer.borderColor = UIColor.black.cgColor
                self.choice1_button.layer.borderWidth = 1
            }
            if self.choice == "1"{
                self.choice2_button.layer.borderColor = UIColor.black.cgColor
                self.choice2_button.layer.borderWidth = 1
            }
            if self.choice == "2"{
                self.choice3_button.layer.borderColor = UIColor.black.cgColor
                self.choice3_button.layer.borderWidth = 1
            }
            if self.choice == "3"{
                self.choice4_button.layer.borderColor = UIColor.black.cgColor
                self.choice4_button.layer.borderWidth = 1
            }
            }
        }
        /*choice1_button.isEnabled = false
        choice2_button.isEnabled = false
        choice3_button.isEnabled = false
        choice4_button.isEnabled = false*/

    }

}

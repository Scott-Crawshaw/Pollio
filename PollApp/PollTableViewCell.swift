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

    @IBOutlet var choice4_bar: UILabel!
    @IBOutlet var choice3_bar: UILabel!
    @IBOutlet var choice2_bar: UILabel!
    @IBOutlet var choice1_bar: UILabel!
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
    var results : [String : [String]]!
    var choice : String!
    var commentsDoc : String!
    var postID : String!
    var listener : ListenerRegistration!
    var currentUser : String!
    
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
        
        choice1_bar.isHidden = false
        choice2_bar.isHidden = false
        choice3_bar.isHidden = false
        choice4_bar.isHidden = false
        
        choice1_text.isHidden = false
        choice2_text.isHidden = false
        choice3_text.isHidden = false
        choice4_text.isHidden = false
        
        choice1_button.layer.borderWidth = 0.0
        choice2_button.layer.borderWidth = 0.0
        choice3_button.layer.borderWidth = 0.0
        choice4_button.layer.borderWidth = 0.0
    }
    
    
    func showResults(){
        var totalVotes : Float = 0.0
        for (_, votes) in results{
            totalVotes += Float(votes.count)
        }
        
        let fullWidth = choice1_button.frame.width
        let fullHeight = choice1_button.frame.height
        resultsButton.isEnabled = true
        resultsButton.backgroundColor = UIColor(red: 111/255, green: 113/255, blue: 121/255, alpha: 1)
        if results.count == 2{
            let firstBarPercent = Float(results["0"]!.count) / totalVotes
            let secondBarPercent = Float(results["1"]!.count) / totalVotes

            choice2_bar.frame.size = CGSize(width: fullWidth * CGFloat(firstBarPercent), height: fullHeight)
            choice2_bar.isHidden = false
            
            choice3_bar.frame.size = CGSize(width: fullWidth * CGFloat(secondBarPercent), height: fullHeight)
            choice3_bar.isHidden = false
            
            if choice == "0"{
                choice2_button.layer.borderColor = UIColor.black.cgColor
                choice2_button.layer.borderWidth = 1
            }
            if choice == "1"{
                choice3_button.layer.borderColor = UIColor.black.cgColor
                choice3_button.layer.borderWidth = 1
            }
            
        }
        if results.count == 3{
            let firstBarPercent = Float(results["0"]!.count) / totalVotes
            let secondBarPercent = Float(results["1"]!.count) / totalVotes
            let thirdBarPercent = Float(results["2"]!.count) / totalVotes
            
            choice2_bar.frame.size = CGSize(width: fullWidth * CGFloat(firstBarPercent), height: fullHeight)
            choice2_bar.isHidden = false
            
            choice3_bar.frame.size = CGSize(width: fullWidth * CGFloat(secondBarPercent), height: fullHeight)
            choice3_bar.isHidden = false
            
            choice4_bar.frame.size = CGSize(width: fullWidth * CGFloat(thirdBarPercent), height: fullHeight)
            choice4_bar.isHidden = false
            
            if choice == "0"{
                choice2_button.layer.borderColor = UIColor.black.cgColor
                choice2_button.layer.borderWidth = 1
            }
            if choice == "1"{
                choice3_button.layer.borderColor = UIColor.black.cgColor
                choice3_button.layer.borderWidth = 1
            }
            if choice == "2"{
                choice4_button.layer.borderColor = UIColor.black.cgColor
                choice4_button.layer.borderWidth = 1
            }
            
        }
        if results.count == 4{
            let firstBarPercent = Float(results["0"]!.count) / totalVotes
            let secondBarPercent = Float(results["1"]!.count) / totalVotes
            let thirdBarPercent = Float(results["2"]!.count) / totalVotes
            let fourthBarPercent = Float(results["3"]!.count) / totalVotes

            
            choice1_bar.frame.size = CGSize(width: fullWidth * CGFloat(firstBarPercent), height: fullHeight)
            choice1_bar.isHidden = false
            
            choice2_bar.frame.size = CGSize(width: fullWidth * CGFloat(secondBarPercent), height: fullHeight)
            choice2_bar.isHidden = false
            
            choice3_bar.frame.size = CGSize(width: fullWidth * CGFloat(thirdBarPercent), height: fullHeight)
            choice3_bar.isHidden = false
            
            choice4_bar.frame.size = CGSize(width: fullWidth * CGFloat(fourthBarPercent), height: fullHeight)
            choice4_bar.isHidden = false
            
            if choice == "0"{
                choice1_button.layer.borderColor = UIColor.black.cgColor
                choice1_button.layer.borderWidth = 1
            }
            if choice == "1"{
                choice2_button.layer.borderColor = UIColor.black.cgColor
                choice2_button.layer.borderWidth = 1
            }
            if choice == "2"{
                choice3_button.layer.borderColor = UIColor.black.cgColor
                choice3_button.layer.borderWidth = 1
            }
            if choice == "3"{
                choice4_button.layer.borderColor = UIColor.black.cgColor
                choice4_button.layer.borderWidth = 1
            }
        }
        choice1_button.isEnabled = false
        choice2_button.isEnabled = false
        choice3_button.isEnabled = false
        choice4_button.isEnabled = false

    }

}

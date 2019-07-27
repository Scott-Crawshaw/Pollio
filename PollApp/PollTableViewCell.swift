//
//  PollTableViewCell.swift
//  PollApp
//
//  Created by Scott Crawshaw on 7/18/19.
//  Copyright © 2019 Crawtech. All rights reserved.
//

import UIKit

class PollTableViewCell: UITableViewCell {

    @IBOutlet var choice4_bar: UILabel!
    @IBOutlet var choice3_bar: UILabel!
    @IBOutlet var choice2_bar: UILabel!
    @IBOutlet var choice1_bar: UILabel!
    @IBOutlet var comments_button: UIButton!
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
    var results : [String : [String]]!
    var commentsDoc : String!
    var postID : String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func showResults(){
        var totalVotes = 0
        for (_, votes) in results{
            totalVotes += votes.count
        }
        
        let fullWidth = choice1_button.frame.width
        let fullHeight = choice1_button.frame.height

        if results.count == 2{
            let firstBarPercent = results["0"]!.count / totalVotes
            let secondBarPercent = results["1"]!.count / totalVotes
            
            choice2_bar.frame.size = CGSize(width: fullWidth * CGFloat(firstBarPercent), height: fullHeight)
            choice2_bar.isHidden = false
            
            choice3_bar.frame.size = CGSize(width: fullWidth * CGFloat(secondBarPercent), height: fullHeight)
            choice3_bar.isHidden = false
            
        }
        if results.count == 3{
            let firstBarPercent = results["0"]!.count / totalVotes
            let secondBarPercent = results["1"]!.count / totalVotes
            let thirdBarPercent = results["2"]!.count / totalVotes
            
            choice1_bar.frame.size = CGSize(width: fullWidth * CGFloat(firstBarPercent), height: fullHeight)
            choice1_bar.isHidden = false
            
            choice2_bar.frame.size = CGSize(width: fullWidth * CGFloat(secondBarPercent), height: fullHeight)
            choice2_bar.isHidden = false
            
            choice3_bar.frame.size = CGSize(width: fullWidth * CGFloat(thirdBarPercent), height: fullHeight)
            choice3_bar.isHidden = false
            
        }
        if results.count == 4{
            let firstBarPercent = results["0"]!.count / totalVotes
            let secondBarPercent = results["1"]!.count / totalVotes
            let thirdBarPercent = results["2"]!.count / totalVotes
            let fourthBarPercent = results["3"]!.count / totalVotes

            
            choice1_bar.frame.size = CGSize(width: fullWidth * CGFloat(firstBarPercent), height: fullHeight)
            choice1_bar.isHidden = false
            
            choice2_bar.frame.size = CGSize(width: fullWidth * CGFloat(secondBarPercent), height: fullHeight)
            choice2_bar.isHidden = false
            
            choice3_bar.frame.size = CGSize(width: fullWidth * CGFloat(thirdBarPercent), height: fullHeight)
            choice3_bar.isHidden = false
            
            choice4_bar.frame.size = CGSize(width: fullWidth * CGFloat(fourthBarPercent), height: fullHeight)
            choice4_bar.isHidden = false
        }
        choice1_button.isEnabled = false
        choice2_button.isEnabled = false
        choice3_button.isEnabled = false
        choice4_button.isEnabled = false


    }

}

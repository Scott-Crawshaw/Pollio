//
//  Slide.swift
//  PollApp
//
//  Created by Ben Stewart on 6/25/19.
//  Copyright © 2019 Crawtech. All rights reserved.
//

import UIKit

class Slide: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
     //hopefully this shit fucking works...
    func viewWillAppear(_ animated: Bool) {
        setGradientBackground()
        self.viewWillAppear(animated)
    }
    
    func setGradientBackground() {
        let colorTop =  UIColor(red: 212/255.0, green: 119/255.0, blue: 230/255.0, alpha: 0.9).cgColor
        let colorBottom = UIColor(red: 161/255.0, green: 84/255.0, blue: 194/255.0, alpha: 1.0).cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop,colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.bounds
        
        self.layer.insertSublayer(gradientLayer, at:0)
    }

}

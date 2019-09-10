//
//  MainCreateViewController.swift
//  PollApp
//
//  Created by Scott Crawshaw on 9/4/19.
//  Copyright © 2019 Crawtech. All rights reserved.
//

import UIKit

class MainCreateViewController: UIViewController {

    @IBOutlet weak var scrollview: UIScrollView!
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var heightConst: NSLayoutConstraint!
    
    @IBOutlet var mainView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setGradientBackground()
        if heightConst.constant < mainView.frame.height - mainView.safeAreaInsets.bottom - mainView.safeAreaInsets.top{
            heightConst.constant = mainView.frame.height - mainView.safeAreaInsets.bottom - mainView.safeAreaInsets.top - 100
            mainView.layoutIfNeeded()
            contentView.layoutIfNeeded()
        }
        //scrollview.contentSize = CGSize(width: self.contentView.frame.width, height: self.contentView.frame.height+1000)

        // Do any additional setup after loading the view.
    }
    func setGradientBackground() {
        let colorTop =  UIColor(red: 212/255.0, green: 119/255.0, blue: 230/255.0, alpha: 0.9).cgColor
        let colorBottom = UIColor(red: 161/255.0, green: 84/255.0, blue: 194/255.0, alpha: 0.9).cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop,colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.view.bounds
        
        self.view.layer.insertSublayer(gradientLayer, at:0)
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

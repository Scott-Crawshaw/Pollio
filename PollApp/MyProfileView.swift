//
//  MyProfileView.swift
//  PollApp
//
//  Created by Ben Stewart on 7/29/19.
//  Copyright © 2019 Crawtech. All rights reserved.
//

import UIKit

class MyProfileView: UIViewController {
    
    @IBOutlet weak var scroller: UIPickerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        scroller.delegate = self
        scroller.dataSource = self

        // Do any additional setup after loading the view.
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

extension MyProfileView: UIPickerViewDelegate, UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 2
    }
    
    
}

//
//  Slide.swift
//  PollApp
//
//  Created by Ben Stewart on 6/25/19.
//  Copyright © 2019 Crawtech. All rights reserved.
//

import UIKit
import Contacts
import FirebaseAuth


class Slide: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! ItemCell
        let key = numArray[indexPath.item]
        cell.textLabel?.text = (cDict[key])
        cell.cellNum = key
        return cell
    }
    

    @IBOutlet var contactSwitch: UISwitch!
    @IBOutlet var loadPrompt: UIActivityIndicatorView!
    @IBOutlet weak var tabView: UITableView!
    @IBOutlet var username : UITextField!
    @IBOutlet var name : UITextField!

    
    
    var cDict: [String: String] = [:]
    var numArray: [String] = []
    var selectedUsers: [String] = []
    
    override func viewDidLoad() {
    }

    override func viewWillAppear(_ animated: Bool) {
        setGradientBackground()
        super.viewWillAppear(animated)
    }
    
    
    @IBAction func isSwitched(sender: UISwitch) {
        if contactSwitch.isOn == false {loadPrompt.stopAnimating(); tabView.isHidden = true; return}
        loadPrompt.startAnimating()
        
        let store = CNContactStore()
        store.requestAccess(for: .contacts, completionHandler: {
            granted, error in
            
            guard granted else {
                let alert = UIAlertController(title: "Can't access contact", message: "Please go to Settings -> Pollio to enable contact permission", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                //self.inputViewController(alert, animated: true, completion: nil)
                return
            }
            
            let keysToFetch = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName), CNContactPhoneNumbersKey] as [Any]
            let request = CNContactFetchRequest(keysToFetch: keysToFetch as! [CNKeyDescriptor])
            var cnContacts = [CNContact]()
            
            do {
                try store.enumerateContacts(with: request){
                    (contact, cursor) -> Void in
                    cnContacts.append(contact)
                }
            } catch let error {
                NSLog("Fetch contact error: \(error)")
            }
            
            for contact in cnContacts {
                let fullName = CNContactFormatter.string(from: contact, style: .fullName) ?? "No Name"
                for ind in 0..<contact.phoneNumbers.count
                {
                    var number = contact.phoneNumbers[ind].value.stringValue.filter("0123456789".contains)
                    if number.count == 10 {
                        number = "1" + number
                    }
                    number = "+" + number
                    
                    self.cDict[number] = "\(fullName)"
                }
                
            }
            DatabaseHelper.getUsersFromNumbers(numbers: Array(self.cDict.keys), callback: self.populateTableView)
        })

        
    }
    
    func populateTableView(contacts: [[String: Any]]){
        //this is where you fill the table view. the format of the data is as follows
        //[[number:+16176108187, userID:djakdn23rj2k3nds], [number:+17815550111, userID:djakdn23rj2k3nds]]
        
        for c in contacts{
            if c["number"] as? String != Auth.auth().currentUser?.phoneNumber{
                numArray.append(c["number"] as! String)
            }
        }
        
        UserDefaults.standard.set(contacts, forKey: "number_idData")
        UserDefaults.standard.set(cDict, forKey: "number_nameDict")
        UserDefaults.standard.set(selectedUsers, forKey: "selectedUsers")
        
        
        //pulling up the next VC
        tabView.isHidden = false
        tabView.reloadData()
        loadPrompt.stopAnimating()

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

}

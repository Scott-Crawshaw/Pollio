//
//  API.swift
//  PollApp
//
//  Created by Scott Crawshaw on 6/21/19.
//  Copyright © 2019 Crawtech. All rights reserved.
//

import Foundation
import FirebaseFirestore

class DatabaseHelper{
    static var db: Firestore!
    
    static func getUserByUID(UID: String, callback: @escaping (Dictionary<String, Any>?) -> Void) {
        db = Firestore.firestore()
        let docRef = db.collection("users").document(UID)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                callback(document.data())
            }
            else{
                callback(nil)
            }
        }
    }
    
    static func getPostByID(ID: String, callback: @escaping (Dictionary<String, Any>?) -> Void){
        db = Firestore.firestore()
        let docRef = db.collection("posts").document(ID)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                callback(document.data())
            }
            else{
                callback(nil)
            }
        }
    }
    
    
    static func getDocumentByReference(reference: String, callback: @escaping (Dictionary<String, Any>?) -> Void){
        db = Firestore.firestore()
        let docRef = db.document(reference)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                callback(document.data())
            }
            else{
                callback(nil)
            }
        }
    }
    
    
}

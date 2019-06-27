//
//  API.swift
//  PollApp
//
//  Created by Scott Crawshaw on 6/21/19.
//  Copyright © 2019 Crawtech. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import FirebaseFunctions

class DatabaseHelper{

    static func getUserByUID(UID: String, callback: @escaping (Dictionary<String, Any>?) -> Void) {
        let db = Firestore.firestore()
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
        let db = Firestore.firestore()
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
        let db = Firestore.firestore()
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
    
    static func uploadImage(localPath: String, cloudPath: String) -> StorageUploadTask{
        let storage = Storage.storage().reference()
        return storage.child(cloudPath).putFile(from: URL(string: localPath)!)
    }
    
    static func getImageReference(cloudPath: String) -> StorageReference{
        return Storage.storage().reference(forURL: cloudPath)
    }
    
    static func getUsersFromNumbers(numbers: [String], callback: @escaping ([[String: Any]]) -> Void){
        let functions = Functions.functions()
        functions.httpsCallable("getFriends").call(["numbers": numbers]) { (result, error) in
            callback(result?.data as? [[String: Any]] ?? [[:]])
        }

    }
}

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
    
    static func getUsersFromNumbers(numbers: [String], callback: @escaping ([[String: String]]) -> Void){
        let functions = Functions.functions()
        functions.httpsCallable("getFriends").call(["numbers": numbers]) { (result, error) in
            let map = (result?.data as! [[String: String]]).filter({$0 != ["delete":"true"]})
            callback(map)
        }

    }
    
    static func followUsers(user: String, follows: [String]){
        let db = Firestore.firestore()
        db.collection("following").document(user).updateData(["following": FieldValue.arrayUnion(follows)])
    }
    
    static func unfollowUsers(user: String, follows: [String]){
        let db = Firestore.firestore()
        db.collection("following").document(user).updateData(["following": FieldValue.arrayRemove(follows)])
    }
    
    static func addPost(data: [String: Any]){
        let db = Firestore.firestore()
        let newPost = db.collection("posts").document()
        var full_data = data
        full_data["comments"] = "/comments/" + newPost.documentID
        full_data["votes"] = "/votes/" + newPost.documentID
        newPost.setData(full_data)
    }
    
    static func searchUsers(search: String, callback: @escaping ([[String : String]]) -> Void){
        callback([["name":"Scott Crawshaw", "uid":"dafefkw"], ["name":"Ben Stewart", "uid":"fasads"], ["name":"Tommy Elliott", "uid":"dafesfaadfkw"]])
    }
}

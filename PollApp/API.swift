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
import FirebaseAuth


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
    
    static func searchUsers(search: String, callback: @escaping ([[[String : String]]]) -> Void){
        let searchTerm = search.lowercased()
        let functions = Functions.functions()
        functions.httpsCallable("searchUsers").call(["search": searchTerm]) { (result, error) in
            callback(result?.data as! [[[String : String]]])
        }
    }
    
    static func checkUsername(username: String, callback: @escaping (Bool) -> Void){
        let db = Firestore.firestore()
        let query = db.collection("users").whereField("username", isEqualTo: username).limit(to: 1)
        query.getDocuments { (result, error) in
            if result!.isEmpty {
                callback(true)
            }
            else{
                callback(false)
            }
        }
    }
    
    static func addUser(name: String, username: String, followMethod: @escaping (Bool) -> Void){
        let searchName = name.lowercased().replacingOccurrences(of: " ", with: "")
        let time = Timestamp()
        let uid = Auth.auth().currentUser!.uid
        let followers = "/followers/" + uid
        let following = "/following/" + uid
        let posts = "/posts/" + uid
        let picture = ""
        
        let data : [String : Any] = [
            "creation" : time,
            "followers" : followers,
            "following" : following,
            "name" : name,
            "picture" : picture,
            "posts" : posts,
            "searchName" : searchName,
            "username" : username
        ]
        
        let db = Firestore.firestore()
        db.collection("users").document(uid).setData(data){ err in
            if err != nil{
                followMethod(false)
            }
            else{
                db.collection("phoneNumbers").document(Auth.auth().currentUser!.phoneNumber!).setData(["user" : "/users/" + uid])
                followMethod(true)
            }
        }
        
    }
}

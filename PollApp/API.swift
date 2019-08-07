//
//  API.swift
//  PollApp
//
//  Created by Scott Crawshaw on 6/21/19.
//  Copyright © 2019 Crawtech. All rights reserved.
// yeet

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
    
    static func getFollowingCount(UID: String, callback: @escaping (Int) -> Void) {
        let db = Firestore.firestore()
        let docRef = db.collection("following").document(UID)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let followingArr : [String] = document.data()?["following"] as? [String] ?? []
                callback(followingArr.count)
            }
            else{
                callback(0)
            }
        }
    }
    
    static func getFollowersCount(UID: String, callback: @escaping (Int) -> Void) {
        let db = Firestore.firestore()
        let docRef = db.collection("followers").document(UID)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let followingArr : [String] = document.data()?["followers"] as? [String] ?? []
                callback(followingArr.count)
            }
            else{
                callback(0)
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
    
    static func initialFollowUsers(user: String, follows: [String]){
        let db = Firestore.firestore()
        db.collection("following").document(user).setData(["following": []])
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
        newPost.setData(full_data)
    }
    
    static func searchUsers(search: String, callback: @escaping ([[String : Any]]) -> Void){
        let searchTerm = search.lowercased()
        let functions = Functions.functions()
        functions.httpsCallable("searchUsers").call(["search": searchTerm]) { (result, error) in
            callback(result?.data as! [[String : Any]])
        }
    }
    
    static func getUserList(ref: String, arrName: String, callback: @escaping ([[String : Any]]?) -> Void){
        let functions = Functions.functions()
        functions.httpsCallable("getUserList").call(["ref": ref, "arrName" : arrName]) { (result, error) in
            callback(result?.data as? [[String : Any]])
        }
    }
    
    static func getUserPosts(uid: String, callback: @escaping ([[String : Any]]?) -> Void){
        let functions = Functions.functions()
        functions.httpsCallable("getUserPosts").call(["uid": uid]) { (result, error) in
            callback(result?.data as? [[String : Any]])
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
    
    static func addFollowRequest(followUID: String){
        let uid = Auth.auth().currentUser!.uid
        let db = Firestore.firestore()
        
        db.collection("followRequests").document(followUID).updateData(["requests" : FieldValue.arrayUnion(["/users/" + uid])])
    }
    
    static func removeFollowRequest(followUID: String){
        let db = Firestore.firestore()
        let uid = Auth.auth().currentUser!.uid
        
        db.collection("followRequests").document(followUID).updateData(["requests" : FieldValue.arrayRemove(["/users/" + uid])])
    }
    
    static func acceptFollowRequest(requestUID: String){
        let db = Firestore.firestore()
        let uid = Auth.auth().currentUser!.uid
        
        db.collection("followRequests").document(uid).updateData(["requests" : FieldValue.arrayRemove(["/users/" + requestUID])])
        
        db.collection("following").document(requestUID).updateData(["following" : FieldValue.arrayUnion(["/users/" + uid])])
    }
    
    static func declineFollowRequest(requestUID: String){
        let db = Firestore.firestore()
        let uid = Auth.auth().currentUser!.uid
        
        db.collection("followRequests").document(uid).updateData(["requests" : FieldValue.arrayRemove(["/users/" + requestUID])])
        
    }
    
    static func getFollowRequests(callback: @escaping ([String : [String]]) -> Void){
        let db = Firestore.firestore()
        let uid = Auth.auth().currentUser!.uid
        
        db.collection("followRequests").document(uid).getDocument { (snap, err) in
            callback(snap?.data() as? [String : [String]] ?? ["requests" : []])
        }
    }
    
    static func getFollowingState(callback: @escaping ([String : [String]]) -> Void){
        let db = Firestore.firestore()
        let uid = Auth.auth().currentUser!.uid
        
        db.collection("followRequests").document(uid).getDocument { (snap, err) in
            callback(snap?.data() as? [String : [String]] ?? ["requests" : []])
        }
    }
    
    static func deleteAccount(){
        let uid = Auth.auth().currentUser!.uid
        let db = Firestore.firestore()
        
        db.collection("users").document(uid).delete()
        do{
        try Auth.auth().signOut()
        }
        catch{}
    }
    
    static func editBio(bio: String){
        let uid = Auth.auth().currentUser!.uid
        let db = Firestore.firestore()
        db.collection("users").document(uid).updateData(["bio":bio])
    }
    
    static func addVote(postID: String, option: String){
        let db = Firestore.firestore()
        db.collection("posts").document(postID).updateData(["results." + option : FieldValue.arrayUnion([Auth.auth().currentUser!.uid])])
    }
    
    static func addUser(name: String, username: String, followMethod: @escaping (Bool) -> Void){
        let searchName = name.lowercased().replacingOccurrences(of: " ", with: "")
        let time = Timestamp()
        let uid = Auth.auth().currentUser!.uid
        let followers = "/followers/" + uid
        let following = "/following/" + uid
        let posts = "/posts/" + uid
        let picture = ""
        let bio = ""
        
        let data : [String : Any] = [
            "creation" : time,
            "followers" : followers,
            "following" : following,
            "name" : name,
            "picture" : picture,
            "posts" : posts,
            "searchName" : searchName,
            "username" : username,
            "bio" : bio
        ]
        
        let db = Firestore.firestore()
        db.collection("users").document(uid).setData(data){ err in
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
                if err != nil{
                    followMethod(false)
                }
                else{
                    followMethod(true)
                }
            })
            
        }
        
    }
}

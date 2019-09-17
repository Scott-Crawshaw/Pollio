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
    
    static func getUserByUIDListener(UID: String, callback: @escaping (Dictionary<String, Any>?) -> Void) -> ListenerRegistration{
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(UID)
        
        return docRef.addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
                callback(nil)
                return
            }
            guard let data = document.data() else {
                callback(nil)
                return
            }
            callback(data)
        }
    }
    
    static func deletePost(pid : String, callback : @escaping (AnyObject) -> Void){
        let db = Firestore.firestore()
        db.collection("posts").document(pid).delete()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5), execute: {
            callback(self)
        })
        
    }
    
    static func submitFeedback(feedback: String){
        let db = Firestore.firestore()
        db.collection("feedback").addDocument(data: ["uid" : Auth.auth().currentUser!.uid, "feedback" : feedback, "time" : FieldValue.serverTimestamp(), "version" : Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "unknown", "ios" : UIDevice.current.systemVersion])
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
    
    static func getFollowingCountListener(UID: String, callback: @escaping (Int) -> Void) -> ListenerRegistration {
        let db = Firestore.firestore()
        let docRef = db.collection("following").document(UID)
        
        return docRef.addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
                callback(0)
                return
            }
            guard let data = document.data() else {
                callback(0)
                return
            }
            let followingArr : [String] = data["following"] as? [String] ?? []
            callback(followingArr.count)
        }
    }
    
    static func getFollowersCountListener(UID: String, callback: @escaping (Int) -> Void) -> ListenerRegistration {
        let db = Firestore.firestore()
        let docRef = db.collection("followers").document(UID)
        return docRef.addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
                callback(0)
                return
            }
            guard let data = document.data() else {
                callback(0)
                return
            }
            let followingArr : [String] = data["followers"] as? [String] ?? []
            callback(followingArr.count)
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
    
    static func getPostByIDListener(ID: String, callback: @escaping (Dictionary<String, Any>?) -> Void) -> ListenerRegistration{
        let db = Firestore.firestore()
        let docRef = db.collection("posts").document(ID)
        
        return docRef.addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
                callback(nil)
                return
            }
            guard let data = document.data() else {
                callback(nil)
                return
            }
            
            callback(data)
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
        for follow in follows{
            addFollowRequest(followUID: follow.subString(from: 7, to: follow.count-1))
        }
    }
    
    static func unfollowUser(user: String){
        let db = Firestore.firestore()
        let uid = Auth.auth().currentUser!.uid
        db.collection("following").document(uid).updateData(["following": FieldValue.arrayRemove(["/users/"+user])])
    }
    
    static func addPost(data: [String: Any]){
        let db = Firestore.firestore()
        let newPost = db.collection("posts").document()
        var full_data = data
        full_data["comments"] = "/comments/" + newPost.documentID
        newPost.setData(full_data)
    }
    
    static func searchUsers(search: String, callback: @escaping ([[String : Any]]) -> Void){
        let searchTerm = search.lowercased().replacingOccurrences(of: " ", with: "")
        let functions = Functions.functions()
        functions.httpsCallable("searchUsers").call(["search": searchTerm]) { (result, error) in
            callback(result?.data as? [[String : Any]] ?? [])
        }
    }
    
    static func getUserList(ref: String, arrName: String, callback: @escaping ([[String : Any]]?) -> Void){
        let functions = Functions.functions()
        functions.httpsCallable("getUserList").call(["ref": ref, "arrName" : arrName]) { (result, error) in
            callback(result?.data as? [[String : Any]] ?? [])
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
        if username == "all" || username == " " || username == ""{
            callback(false)
            return
        }
        let query = db.collection("users").whereField("username", isEqualTo: username).limit(to: 1)
        query.getDocuments { (result, error) in
            guard let res = result else{
                callback(false)
                return
            }
            if res.isEmpty {
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
    
    static func hasFollowRequestsListener(callback: @escaping (Bool) -> Void) -> ListenerRegistration?{
        let db = Firestore.firestore()
        let uid = Auth.auth().currentUser?.uid ?? nil
        
        if uid == nil{
            callback(false)
            return nil
        }
        
        return db.collection("followRequests").document(uid!)
            .addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    callback(false)
                    return
                }
                guard let data = document.data() else {
                    callback(false)
                    return
                }
                if (data["requests"] as? [String] ?? []).count > 0{
                    callback(true)
                }
                else {
                    callback(false)
                }
        }

    }
    
    static func countFollowRequestsListener(callback: @escaping (Int) -> Void) -> ListenerRegistration?{
        let db = Firestore.firestore()
        let uid = Auth.auth().currentUser?.uid ?? nil
        
        if uid == nil{
            callback(0)
            return nil
        }
        
        return db.collection("followRequests").document(uid!)
            .addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    callback(0)
                    return
                }
                guard let data = document.data() else {
                    callback(0)
                    return
                }
                
                callback((data["requests"] as? [String] ?? []).count)

        }
        
    }
    
    static func getFollowingState(followerUID: String, followingUID: String, callback: @escaping (Int) -> Void){
        let db = Firestore.firestore()
        //0 : not following, 1 : requested, 2 : following
        //followerUID : UID of the person who would hypothetically be following the other person
        //followingUID : the person who would hypothetically be being followed
        db.collection("following").document(followerUID).getDocument { (snap, err) in
            let result = snap?.data() as? [String : [String]] ?? ["following" : []]
            if result["following"]!.contains("/users/" + followingUID){
                callback(2)
            }
            else{
                db.collection("followRequests").document(followingUID).getDocument(completion: { (snap, err) in
                    let result = snap?.data() as? [String : [String]] ?? ["requests" : []]
                    if result["requests"]!.contains("/users/" + followerUID){
                        callback(1)
                    }
                    else{
                        callback(0)
                    }
                })
            }
        }
    }
    
    static func deleteNumber(){
        let functions = Functions.functions()
        functions.httpsCallable("deleteNumber").call() { (result, error) in
        }
    }
    
    static func deleteAccount(){
        let uid = Auth.auth().currentUser!.uid
        let db = Firestore.firestore()
        
        db.collection("users").document(uid).delete(){ (err) in
            if err != nil{
                return
            }
            do{
                try Auth.auth().signOut()
            }
            catch{}
        }
        
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
    
    static func removeVote(postID: String, option: String){
        let db = Firestore.firestore()
        db.collection("posts").document(postID).updateData(["results." + option : FieldValue.arrayRemove([Auth.auth().currentUser!.uid])])
    }
    
    static func isUser(uid: String, callback: @escaping (Bool) -> Void){
        let db = Firestore.firestore()
        db.collection("users").document(uid).getDocument { (document, err) in
            if let document = document, document.exists {
                callback(true)
            } else {
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
            "bio" : bio,
            "uid" : uid
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

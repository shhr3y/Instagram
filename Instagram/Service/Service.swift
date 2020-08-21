//
//  Service.swift
//  Instagram
//
//  Created by Shrey Gupta on 24/07/20.
//  Copyright © 2020 Shrey Gupta. All rights reserved.
//

import Firebase

//    MARK: - Database References
let DB_REF = Database.database().reference()
let DB_REF_USERS = DB_REF.child("users")
let DB_REF_USER_FOLLOWING = DB_REF.child("user-following")
let DB_REF_USER_FOLLOWER = DB_REF.child("user-follower")
let DB_REF_POSTS = DB_REF.child("posts")
let DB_REF_USER_POSTS = DB_REF.child("user-posts")

struct Service {
    static let shared = Service()
    
    func fetchUserData(forUID uid: String, completion: @escaping(User) -> Void){
        DB_REF_USERS.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            guard let userDictionary = snapshot.value as? [String: Any] else { return }
            let user = User(uid: snapshot.key, dictionary: userDictionary)
            
            completion(user)
        }
    }
    
    func fetchAllUsers(completion: @escaping(User) -> Void){
        DB_REF_USERS.observe(.childAdded) { (snapshot) in
            let uid = snapshot.key
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            
            let user = User(uid: uid, dictionary: dictionary)
            completion(user)
        }
    }
    
    func fetchUsers(type: FollowControllerType, forUID uid: String, completion: @escaping([String: Any]) -> Void){
        let ref: DatabaseReference!
        switch type {
        case .follower:
            ref = DB_REF_USER_FOLLOWER
        case .following:
            ref = DB_REF_USER_FOLLOWING
        }
        
        ref.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            if let snapshot = snapshot.value as? [String: Any] {
                completion(snapshot)
            }
        }
    }
    
    func followUser(currentUserUID: String, userUID: String) {
        DB_REF_USER_FOLLOWING.child(currentUserUID).updateChildValues([userUID: 1])
        DB_REF_USER_FOLLOWER.child(userUID).updateChildValues([currentUserUID: 1])
    }
    
    func unFollowUser(currentUserUID: String, userUID: String) {
        DB_REF_USER_FOLLOWING.child(currentUserUID).child(userUID).removeValue()
        DB_REF_USER_FOLLOWER.child(userUID).child(currentUserUID).removeValue()
    }
    
    func checkIfUserIsFollowing(currentUserUID: String, userUID: String, completion: @escaping(Bool) -> Void) {
        DB_REF_USER_FOLLOWING.child(currentUserUID).observeSingleEvent(of: .value) { (snapshot) in
            completion(snapshot.hasChild(userUID))
        }
    }
    
    func getUserStats(for uid: String, completion: @escaping([String: Int]) -> Void){
        //get followers
        var userStats = [String: Int]()
        var noOfFollowers: Int = 0
        var noOfFollowing: Int = 0
        var noOfPosts: Int = 0

        DB_REF_USER_FOLLOWER.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            if let snapshot = snapshot.value as? [String: Any] {
                noOfFollowers = snapshot.count
            }
            
            DB_REF_USER_FOLLOWING.child(uid).observeSingleEvent(of: .value) { (snapshot) in
                if let snapshot = snapshot.value as? [String: Any] {
                    noOfFollowing = snapshot.count
                }
                
                DB_REF_USER_POSTS.child(uid).observeSingleEvent(of: .value) { (snapshot) in
                    if let snapshot = snapshot.value as? [String: Any] {
                        noOfPosts = snapshot.count
                    }
                    userStats["noOfFollowers"] = noOfFollowers
                    userStats["noOfFollowing"] = noOfFollowing
                    userStats["noOfPosts"] = noOfPosts
                    
                    completion(userStats)
                }
            }
        }
    }
    
    func uploadPost(_ post: UIImage, caption: String, completion: @escaping(Bool) -> Void ){
        //  get current user uid
        guard let userUID = Auth.auth().currentUser?.uid else { return }
        
        //upload data
        guard let uploadData = post.jpegData(compressionQuality: 0.5) else { return }
        
        //creation date
        let creationDate = Int(NSDate().timeIntervalSince1970)
        
        //update storage
        let filename = NSUUID().uuidString
        Storage.storage().reference().child("post_images").child(filename).putData(uploadData, metadata: nil) { (data, error) in
            //handle error
            if let error = error {
                print("DEBUG: Error uploading Post: \(error.localizedDescription)")
                return
            }
            //get image URL
            Storage.storage().reference().child("post_images").child(filename).downloadURL(completion: { (url, error) in
                if let error = error {
                    print("DEBUG: Error downloading Posts URL: \(error.localizedDescription)")
                    return
                }
                guard let postImageURL = url?.absoluteString else { return }
                
                //post data
                let dictionaryValues = ["caption": caption, "creationDate": creationDate, "likes": 0, "postImageURL":postImageURL, "ownerUID": userUID] as [String: Any]
                
                //post id
                let postId = DB_REF_POSTS.childByAutoId()
                postId.updateChildValues(dictionaryValues) { (error, reference) in
                    if let err = error {
                        print("DEBUG: Error while upating child values of post: \(err.localizedDescription)")
                        completion(false)
                        return
                    }
                    guard let key = postId.key else { return }
                    DB_REF_USER_POSTS.child(userUID).updateChildValues([key: 1]) { (error, reference) in
                        if let error = error {
                            print("DEBUG: Error while adding post to user-posts: \(error.localizedDescription)")
                            return
                        }
                        completion(true)
                    }
                }
            })
        }
    }
    
    func fetchPost(for postID: String, completion: @escaping(Post) -> Void) {
        
        DB_REF_POSTS.child(postID).observeSingleEvent(of: .value) { (snap) in
            guard let dictionary = snap.value as? [String: Any] else { return}
            
            guard let ownerUID = dictionary["ownerUID"] as? String else { return }
            self.fetchUserData(forUID: ownerUID) { (user) in
                let post = Post(postID: postID, user: user, dictionary: dictionary)
                completion(post)
            }
        }
    }
    
    func fetchAllPosts(for user: User, completion: @escaping(Post)-> Void) {
        
        DB_REF_USER_POSTS.child(user.uid).observe(.childAdded) { (snapshot) in
            let postId = snapshot.key
             
            self.fetchPost(for: postId) { (post) in
                completion(post)
            }
        }
    }
    
    func fetchFeedPosts(completion: @escaping(Post) -> Void) {
        DB_REF_POSTS.observe(.childAdded) { (snapshot) in
            let postId = snapshot.key
            
            self.fetchPost(for: postId) { (post) in
                completion(post)
            }
        }
    }
}



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
//profile
let DB_REF_USERS = DB_REF.child("users")
let DB_REF_USER_FOLLOWING = DB_REF.child("user-following")
let DB_REF_USER_FOLLOWER = DB_REF.child("user-follower")
//posts
let DB_REF_POSTS = DB_REF.child("posts")
let DB_REF_USER_POSTS = DB_REF.child("user-posts")
let DB_REF_USER_FEED = DB_REF.child("user-feed")
//likes
let DB_REF_USER_LIKES = DB_REF.child("user-likes")
//comment
let DB_REF_COMMENTS = DB_REF.child("comments")


struct Service {
    static let shared = Service()
    
    func getCurrentUser() -> FirebaseAuth.User? {
        guard let user = Auth.auth().currentUser else { return nil}
        return user
    }
    
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
        
        DB_REF_USER_POSTS.child(userUID).observe(.childAdded) { (snapshot) in
            let postID = snapshot.key
            self.addToUserFeed(postID: postID)
        }
    }
    
    func unFollowUser(currentUserUID: String, userUID: String) {
        DB_REF_USER_FOLLOWING.child(currentUserUID).child(userUID).removeValue()
        DB_REF_USER_FOLLOWER.child(userUID).child(currentUserUID).removeValue()
        
        DB_REF_USER_POSTS.child(userUID).observe(.childAdded) { (snapshot) in
            let postID = snapshot.key
            self.removeFromUserFeed(postID: postID)
        }
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
                    DB_REF_USER_POSTS.child(userUID).updateChildValues([key: 1])
                    self.updateUserFeed(withPostID: key)
                    completion(true)
                }
            })
        }
    }
    
    
    func updateUserFeed(withPostID postID: String) {                                     // ADD UPLOADED POST TO USERS FEED
        guard let currentUser = Auth.auth().currentUser else { return }
        
        // database values
        let values = [postID: 1]
        
        // update followers feed
        DB_REF_USER_FOLLOWER.child(currentUser.uid).observe(.childAdded) { (snapshot) in
            let followerUID = snapshot.key
            DB_REF_USER_FEED.child(followerUID).updateChildValues(values)
        }
        
        //update current user feed
        DB_REF_USER_FEED.child(currentUser.uid).updateChildValues(values)
    }
    
    func addToUserFeed(postID: String) {                                                // ADDS POST ID TO USER FEED
        guard let currentUser = Auth.auth().currentUser else { return }
        DB_REF_USER_FEED.child(currentUser.uid).updateChildValues([postID: 1])
    }
    
    func removeFromUserFeed(postID: String) {                                           // REMOVES POST ID FROM USER FEED
        guard let currentUser = Auth.auth().currentUser else { return }
        DB_REF_USER_FEED.child(currentUser.uid).child(postID).removeValue()
    }
    
    func updateUserFeedForFollowingUser() {                                             // AUTOMATICALLY FETCHES ALL POSTS FOR LOGGED USER
        guard let currentUser = Auth.auth().currentUser else { return }
        
        // ADD FOLLOWING USERS POST TO FEED
        DB_REF_USER_FOLLOWING.child(currentUser.uid).observe(.childAdded) { (snapshot) in
            let followingUserUID = snapshot.key
            
            DB_REF_USER_POSTS.child(followingUserUID).observe(.childAdded) { (snapshot) in
                let postID = snapshot.key
                self.addToUserFeed(postID: postID)
            }
        }
        
        // ADD LOGGED USER POSTS TO FEED
        DB_REF_USER_POSTS.child(currentUser.uid).observe(.childAdded) { (snapshot) in
            let postID = snapshot.key
            self.addToUserFeed(postID: postID)
        }
    }
    
    func fetchFeedPosts(completion: @escaping(Post) -> Void) {                             // FETCHES ALL POSTS IN FEED
        guard let currentUser = Auth.auth().currentUser else { return }
        
        DB_REF_USER_FEED.child(currentUser.uid).observe(.childAdded) { (snapshot) in
            let postId = snapshot.key
            
            self.fetchPost(for: postId) { (post) in
                completion(post)
            }
        }
    }
    
    func fetchAllPosts(for user: User, completion: @escaping(Post)-> Void) {               // FETCHES ALL POSTS FOR A PARTICULAR USER
        
        DB_REF_USER_POSTS.child(user.uid).observe(.childAdded) { (snapshot) in
            let postId = snapshot.key
             
            self.fetchPost(for: postId) { (post) in
                completion(post)
            }
        }
    }
    
    func fetchPost(for postID: String, completion: @escaping(Post) -> Void) {             // FETCHES SINGLE POST INFO
        
        DB_REF_POSTS.child(postID).observeSingleEvent(of: .value) { (snap) in
            guard let dictionary = snap.value as? [String: Any] else { return}
            
            guard let ownerUID = dictionary["ownerUID"] as? String else { return }
            self.fetchUserData(forUID: ownerUID) { (user) in
                let post = Post(postID: postID, user: user, dictionary: dictionary)
                completion(post)
            }
        }
    }
    
    
    func updateLikeStatus(for post: Post) {                                                 // UPDATE LIKE STATUS (LIKE OR DISLIKE)
        guard let currentUser = Auth.auth().currentUser else { return }
        
        checkLikeStatus(for: post) { (status) in
            if status {
                DB_REF_POSTS.child(post.postID).child("likes").child(currentUser.uid).removeValue()
                DB_REF_USER_LIKES.child(currentUser.uid).child(post.postID).removeValue()
                
            } else {
                DB_REF_POSTS.child(post.postID).child("likes").updateChildValues([currentUser.uid : 1])
                DB_REF_USER_LIKES.child(currentUser.uid).updateChildValues([post.postID: 1])
            }
        }
    }
    
    func checkLikeStatus(for post: Post, completion: @escaping(Bool) -> Void){              // CHECK LIKE STATUS (LIKE OR DISLIKE)
        guard let currentUser = Auth.auth().currentUser else { return }
        DB_REF_USER_LIKES.child(currentUser.uid).child(post.postID).observeSingleEvent(of: .value) { (snapshot) in
            completion(snapshot.exists())
        }
    }
    
    func fetchLikedUsers(for post: Post, completion: @escaping([String: Any]) -> Void){     // FETCH UIDS OF ALL USERS WHO HAVE LIKED THE POST
        DB_REF_POSTS.child(post.postID).child("likes").observeSingleEvent(of: .value) { (snapshot) in
            guard let snapshot = snapshot.value as? [String: Any] else { return }
            completion(snapshot)
        }
    }
    
    func uploadComment(_ comment: String, in post: Post, completion: @escaping(Bool) -> Void) {
        let trimmedComment = comment.trimmingCharacters(in: .whitespaces)
        guard let currentUser = Auth.auth().currentUser else { return }
        let creationDate = Int(NSDate().timeIntervalSince1970)
        
        let dictionary = ["comment": trimmedComment, "uid": currentUser.uid, "creationDate": creationDate] as [String: Any]
        
        DB_REF_COMMENTS.child(post.postID).childByAutoId().updateChildValues(dictionary) { (error, reference) in
            if let _ = error {
                completion(false)
            }
            else{
                completion(true)
            }
        }
    }
    
    func fetchComments(for post: Post, completion: @escaping(Comment) -> Void) {
        DB_REF_COMMENTS.child(post.postID).observe(.childAdded) { (snapshot) in
            guard let dict = snapshot.value as? [String: Any] else { return }
            guard let uid = dict["uid"] as? String else { return }
            
            self.fetchUserData(forUID: uid) { (user) in
                let comment = Comment(postID: post.postID, user: user, dictionary: dict)
                completion(comment)
            }
        }
    }
}



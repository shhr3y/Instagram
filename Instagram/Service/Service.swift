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

        DB_REF_USER_FOLLOWER.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            if let snapshot = snapshot.value as? [String: Any] {
                noOfFollowers = snapshot.count
            }
            
            DB_REF_USER_FOLLOWING.child(uid).observeSingleEvent(of: .value) { (snapshot) in
                if let snapshot = snapshot.value as? [String: Any] {
                    noOfFollowing = snapshot.count
                }
                userStats["noOfFollowers"] = noOfFollowers
                userStats["noOfFollowing"] = noOfFollowing
                completion(userStats)
            }
        }
    }
}



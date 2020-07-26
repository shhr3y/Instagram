//
//  File.swift
//  Instagram
//
//  Created by Shrey Gupta on 23/07/20.
//  Copyright © 2020 Shrey Gupta. All rights reserved.
import Firebase

class User {
    let uid: String
    let name: String
    let profileImageURL: String
    let username: String
    var isFollowed = false
    
    init(uid: String, dictionary: [String: Any]) {
        self.uid = uid
        self.name = dictionary["name"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageURL = dictionary["profileImageURL"] as? String ?? ""
    }
    
    func follow() {
        guard let currentUser = Auth.auth().currentUser else { return }
        Service.shared.followUser(currentUserUID: currentUser.uid, userUID: self.uid)
        self.isFollowed = true
    }
    
    func unfollow() {
        guard let currentUser = Auth.auth().currentUser else { return }
        Service.shared.unFollowUser(currentUserUID: currentUser.uid, userUID: self.uid)
        self.isFollowed = false
    }
    
    func checkIfUserIsFollowed(completion: @escaping(Bool)->Void) {
        guard let currentUID = Auth.auth().currentUser?.uid else { return }
        Service.shared.checkIfUserIsFollowing(currentUserUID: currentUID, userUID: self.uid) { (bool) in
            self.isFollowed = bool
            completion(self.isFollowed)
        }
    }
}

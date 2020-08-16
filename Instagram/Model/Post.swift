//
//  Post.swift
//  Instagram
//
//  Created by Shrey Gupta on 13/08/20.
//  Copyright © 2020 Shrey Gupta. All rights reserved.
//

import Foundation

class Post {
    var postID: String
    var caption: String
    var likes: Int
    var imageURL: String
    var ownerUID: String
    var creationDate: Date
    
    init(postID: String, dictionary: [String: Any]) {
        self.postID = postID
        self.ownerUID = dictionary["ownerUID"] as? String ?? ""

        self.caption = dictionary["caption"] as? String ?? ""
        self.likes = dictionary["likes"] as? Int ?? 0
        self.imageURL = dictionary["postImageURL"] as? String ?? ""
        
        let creationDateRaw = dictionary["creationDate"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: creationDateRaw)
    }
}

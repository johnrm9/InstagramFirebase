//
//  Post.swift
//  InstagramFirebase
//
//  Created by John Martin on 1/10/18.
//  Copyright © 2018 John Martin. All rights reserved.
//

import Foundation

struct Post {
    var id: String?
    var hasLiked: Bool = false

    let user: User
    let imageUrl: String
    let caption: String
    let creationDate: Date

    init(id: String? = nil, hasLiked: Bool = false, user: User, dictionary: [String: Any]) {
        self.id = id
        self.hasLiked = hasLiked
        self.user = user
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.caption = dictionary["caption"] as? String ?? ""

        let secondsFrom1970 = dictionary["creationDate"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondsFrom1970)
    }
}

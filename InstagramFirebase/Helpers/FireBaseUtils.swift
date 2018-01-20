//
//  FireBaseUtils.swift
//  InstagramFirebase
//
//  Created by John Martin on 1/8/18.
//  Copyright © 2018 John Martin. All rights reserved.
//

import Firebase

extension Auth {
    static var currentUid: String? {
        return Auth.auth().currentUser?.uid
    }

    static var isCurrentUserLoggedOut: Bool {
        return Auth.auth().currentUser == nil
    }
}

extension Storage {

    static var refProfileImages: StorageReference {
        return Storage.storage().reference().child("profile_images")
    }

    static var refPosts: StorageReference {
        return Storage.storage().reference().child("posts")
    }

}

extension Database {

    static var refUsers: DatabaseReference {
        return Database.database().reference().child("users")
    }

    static var refPosts: DatabaseReference {
        return Database.database().reference().child("posts")
    }

    static var refFollowing: DatabaseReference {
        return Database.database().reference().child("following")
    }

    static var refComments: DatabaseReference {
        return Database.database().reference().child("comments")
    }

    static var refLikes: DatabaseReference {
        return Database.database().reference().child("likes")
    }

    static var refFollowingCurrentUid: DatabaseReference? {
        guard let uid = Auth.currentUid else { return nil }
        return refFollowing.child(uid)
    }

    static func fetchUserWithUID(_ uid: String, completion: @escaping (User) -> Void) {
        refUsers.child(uid).observeSingleEvent(of: .value, with: { (snapshot) in

            guard let dictionary = snapshot.value as? [String: Any] else { return }
            let user = User(uid: uid, dictionary: dictionary)
            completion(user)

        }) { (err) in
            print("Failed to fetch user:", err)
        }
    }
}

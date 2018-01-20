//
//  Service.swift
//  InstagramFirebase
//
//  Created by John Martin on 1/8/18.
//  Copyright © 2018 John Martin. All rights reserved.
//

import Firebase

extension Array where Element: DataSnapshot {
    var hasObjects: Bool {
        return self.count > 0
    }
    static func < (left: [Element], right: UInt) -> Bool {
        return left.count < right
    }

    static func && (left: Bool, right: [Element]) -> Bool {
        return left && right.hasObjects
    }

    func removedFirst() -> [Element] {
        var objects = self
        objects.removeFirst()
        return objects
    }

    static func << (left: Bool, right: [Element]) -> [Element] {
        return left ? right.removedFirst() : right
    }
}

extension DatabaseQuery {

    func paginatePostsByUser(_ user: User, toLast: UInt = 4, hasPosts: Bool, completion: @escaping (_ isFinishedPaging: Bool, _ posts: [Post]) -> Void) {

        self.queryLimited(toLast: toLast).observeSingleEvent(of: .value, with: { (snapshot) in
            guard var allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }

            allObjects.reverse()

            let isFinishedPaging = allObjects < toLast

            var posts = [Post]()
            ((hasPosts && allObjects) << allObjects).forEach({ (snapshot) in
                guard let dictionary = snapshot.value as? [String: Any] else { return }
                let post = Post(id: snapshot.key, user: user, dictionary: dictionary)
                posts.append(post)
            })

            completion(isFinishedPaging, posts)
        }) { (error) in
            print("Failed to paginate for posts:", error)
        }
    }
}

struct Service {

    static let shared: Service = Service()

    static func getCurrentUid() -> String? {
        return Auth.currentUid
    }

    static func isLoggedOut() -> Bool {
        return Auth.isCurrentUserLoggedOut
    }

    func signOut(completion: (Error?) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(nil)
        } catch let signOutErr {
            print("Failed to sign out:", signOutErr)
            completion(signOutErr)
        }
    }

    func signIn(with email: String, password: String, completion: @escaping (_ user: FirebaseAuth.User?, _ error: Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                print("Failed to login:", error)
                completion(nil, error)
            } else {
                completion(user, nil)
            }
        }
    }

    func createUser(withEmail: String, password: String, completion: @escaping (_ uid: String?, Error?) -> Void) {
        Auth.auth().createUser(withEmail: withEmail, password: password) { (user: FirebaseAuth.User?, error: Error?) in
            if let error = error {
                print("Failed to create user", error)
                completion(nil, error)
                return
            }
            completion(user?.uid, nil)
        }
    }

    func paginatePostByUser(_ user: User, endingValue: TimeInterval?, hasPosts: Bool, completion: @escaping (_ isFinishedPaging: Bool, _ posts: [Post]) -> Void) {

        func queryOrderedPostsByUid(_ uid: String, endingValue: TimeInterval?) -> DatabaseQuery {
            let baseQuery = Database.refPosts.child(uid).queryOrdered(byChild: "creationDate")
            guard let endingValue = endingValue else { return baseQuery }
            return baseQuery.queryEnding(atValue: endingValue)
        }

        let query = queryOrderedPostsByUid(user.uid, endingValue: endingValue)
        query.paginatePostsByUser(user, hasPosts: hasPosts) { (isFinishedPaging, posts) in
            completion(isFinishedPaging, posts)
        }
    }

    func updateUsers(values: [AnyHashable: Any], completion: @escaping (Error?) -> Void) {
        Database.refUsers.updateChildValues(values) { (error, _) in
            if let error = error {
                print("Failed to save user info into db:", error)
                completion(error)
                return
            }
            completion(nil)
        }
    }

    func uploadProfileImage(uploadData: Data, completion: @escaping (_ profileImageUrl: String?, Error?) -> Void) {
        let filename = NSUUID().uuidString
        Storage.refProfileImages.child(filename).putData(uploadData, metadata: nil) { (metadata, error) in
            if let error = error {
                print("Failed to upload profile image:", error)
                completion(nil, error)
                return
            }
            guard let profileImageUrl = metadata?.downloadURL()?.absoluteString else { return }
            completion(profileImageUrl, nil)
        }
    }

    func isFollowingWithUid(_ uid: String, completion: @escaping (_ isFollowing: Int?) -> Void) {
        guard let ref = Database.refFollowingCurrentUid?.child(uid) else { return }
        ref.observe(.value, with: { (snapshot) in
            guard snapshot.exists() else { completion(nil); return }
            guard let isFollowing = snapshot.value as? Int else { return }
            completion(isFollowing)
        }) { (error) in
            print("Failed to check if following:", error)
        }
    }

    func followWithUid(_ uid: String, completion: @escaping (Error?) -> Void) {
        guard let ref = Database.refFollowingCurrentUid else { return }
        let values = [uid: 1]
        ref.updateChildValues(values) { (error, _) in
            if let error = error {
                print("Failed to follow user:", error)
            }
            completion(error)
        }
    }

    func unfollowWithUid(_ uid: String, completion: @escaping (Error?) -> Void) {
        guard let ref = Database.refFollowingCurrentUid?.child(uid) else { return }
        ref.removeValue { (error, _) in
            if let error = error {
                print("Failed to unfollow user:", error)
            }
            completion(error)
        }
    }

    func fetchOrderedPostsByUid(_ uid: String? = Auth.currentUid, completion: @escaping (_ dictionary: [String: Any]) -> Void) {
        guard let uid = uid else { return }
        let query = Database.refPosts.child(uid).queryOrdered(byChild: "creationDate")
        query.observe(.childAdded, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            completion(dictionary)
        }) { (error) in
            print("Failed to fetch ordered posts:", error)
        }
    }

    func fetchPostsByUid(_ uid: String, completion: @escaping (_ dictionaries: [String: Any]) -> Void) {
        Database.refPosts.child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            completion(dictionaries)
        }) { (error ) in
            print("Failed to fetch posts:", error)
        }
    }

    func fetchLikesByPostUid(_ postUid: String, completion: @escaping (_ hasLiked: Bool?, Error?) -> Void) {
        var hasLiked: Bool = false
        guard let uid = Service.getCurrentUid() else { return }
        Database.refLikes.child(postUid).child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if let value = snapshot.value as? Int, value == 1 {
                hasLiked = true
            } else {
                hasLiked = false
            }
            completion(hasLiked, nil)
        }) { (error) in
            print("Failed to fetch like info for post:", error)
            completion(nil, error)
        }
    }

    func fetchFollowingsByUid(_ uid: String? = Service.getCurrentUid(), completion: @escaping (_ dictionary: [String: Any]) -> Void) {
        guard let uid = uid else { return }
        Database.refFollowing.child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            completion(dictionary)
        }) { (error) in
            print("Failed to fetch following user ids:", error)
        }
    }

    func fetchCommentsByPostUid(_ uid: String, completion: @escaping (_ dictionary: [String: Any]) -> Void) {
        let ref = Database.refComments.child(uid)
        ref.observe(.childAdded, with: { (snapshot) in
            guard snapshot.exists() else { return }
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            completion(dictionary)
        }) { (error) in
            print("Failed to fetch comments user ids:", error)
        }
    }

    func uploadLikeByPostUid(_ postId: String, values: [AnyHashable: Any], completion: @escaping (Error?) -> Void) {
        let ref = Database.refLikes.child(postId)
        ref.updateChildValues(values) { (error, _) in
            if let error = error {
                print("Failed to like post:", error)
                completion(error)
            } else {
                completion(nil)
            }
        }
    }

    func postImageData(uploadData: Data, completion: @escaping (String?, Error?) -> Void) {
        let filename = NSUUID().uuidString
        Storage.refPosts.child(filename).putData(uploadData, metadata: nil) { (metadata, error) in
            guard error == nil else { completion(nil, error); return}
            guard let imageUrl = metadata?.downloadURL()?.absoluteString else { return }
            completion(imageUrl, nil)
        }
    }

    func uploadCommentByPostUid(_ uid: String, values: [String: Any], completion: @escaping (Error?) -> Void) {
        let ref = Database.refComments.child(uid).childByAutoId()
        ref.updateChildValues(values) { (error, _) in completion(error) }
    }

    func uploadPost(uid: String, values: [String: Any], completion: @escaping (Error?) -> Void) {
        let ref = Database.refPosts.child(uid).childByAutoId()
        ref.updateChildValues(values) { (error, _) in completion(error) }
    }

    func fetchUserByUid(_ uid: String? = Auth.currentUid, completion: @escaping (_ user: User) -> Void ) {
        guard let uid = uid else { return }
        Database.fetchUserWithUID(uid) { (user) in completion(user) }
    }

    func fetchUsers(completion: @escaping (_ dictionaries: [String: Any]) -> Void) {
        Database.refUsers.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            completion(dictionaries)
        }) { (error) in
            print("Failed to fetch users:", error)
        }
    }
}

//
//  UserProfileController.swift
//  InstagramFirebase
//
//  Created by John Martin on 1/8/18.
//  Copyright © 2018 John Martin. All rights reserved.
//

import UIKit

class UserProfileController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UserProfileHeaderDelegate {

    func didChangeToListView() {
        isGridView = false
        collectionView?.reloadData()
    }

    func didChangeToGridView() {
        isGridView = true
        collectionView?.reloadData()
    }

    var isGridView: Bool = true

    let cellId: String = "cellId"
    let homePostCellId: String = "homePostCellId"
    let headerId: String = "headerId"

    var userId: String?

    var user: User?
    var posts: [Post] = []

    var isFinishedPaging: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView?.backgroundColor = .white
        collectionView?.alwaysBounceVertical = true

        collectionView?.register(UserProfileHeaderCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView?.register(UserProfilePhotoCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.register(HomePostCell.self, forCellWithReuseIdentifier: homePostCellId)

        setupLogOutButton()

        fetchUser()

    }

    fileprivate func paginatePosts() {

        let hasPosts: Bool = posts.count > 0
        let endingValue: TimeInterval? = hasPosts ? posts.last?.creationDate.timeIntervalSince1970 : nil

        guard let user = self.user else { return }

        Service.shared.paginatePostByUser(user, endingValue: endingValue, hasPosts: hasPosts) { (isFinishedPaging, posts) in
            self.isFinishedPaging = isFinishedPaging
            self.posts += posts
            self.collectionView?.reloadData()
        }
    }

    fileprivate func fetchOrderedPosts() {
        guard let user = self.user else { return }
        Service.shared.fetchOrderedPostsByUid(user.uid) { (dictionary) in

            let post = Post(user: user, dictionary: dictionary)
            self.posts.insert(post, at: 0)

            self.collectionView?.reloadData()
        }
    }

    func fetchUser() {
        Service.shared.fetchUserByUid { (user) in
            self.user = user
            self.navigationItem.title = self.user?.username
            self.collectionView?.reloadData()
            self.paginatePosts()
            //self.fetchOrderedPosts()
        }
    }

    fileprivate func setupLogOutButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "gear").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleLogOut))
    }

    @objc func handleLogOut() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (_) in
            Service.shared.signOut { (error) in
                guard error == nil else { return }
                let loginController = LoginController()
                let navController = UINavigationController(rootViewController: loginController)
                self.present(navController, animated: true)
            }
        }))

        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        present(alertController, animated: true)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if indexPath.item == (posts.count - 1) && !isFinishedPaging {
            //print("Paginating for posts")
            paginatePosts()
        }

        if isGridView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? UserProfilePhotoCell else { return UICollectionViewCell() }
            cell.post = posts[indexPath.item]
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: homePostCellId, for: indexPath) as? HomePostCell else { return UICollectionViewCell() }
            cell.post = posts[indexPath.item]
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat
        let height: CGFloat

        if isGridView {
            width = (view.frame.width - 2) / 3
            height = width
        } else {
            width = view.frame.width
            height = width + 40 + 8 + 50 + 60
        }
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as? UserProfileHeaderCell
            else { return UICollectionReusableView() }
        header.delegate = self
        header.user = self.user
        return header
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
}

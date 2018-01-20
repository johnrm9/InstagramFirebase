//
//  HomeController.swift
//  InstagramFirebase
//
//  Created by John Martin on 1/11/18.
//  Copyright © 2018 John Martin. All rights reserved.
//

import UIKit

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout, HomePostCellDelegate {

    func didLike(for cell: HomePostCell) {
        guard let indexPath = collectionView?.indexPath(for: cell) else { return }

        var post = self.posts[indexPath.item]

        guard let postId = post.id else { return }
        guard let uid = Service.getCurrentUid() else { return }

        let values = [uid: post.hasLiked.toggle() ? 1 : 0]

        Service.shared.uploadLikeByPostUid(postId, values: values) { (error) in
            guard error == nil else { return }
            self.posts[indexPath.item] = post

            self.collectionView?.reloadItems(at: [indexPath])
        }
    }

    func didComment(post: Post) {
        let commentsController = CommentsController(collectionViewLayout: UICollectionViewFlowLayout())
        commentsController.post = post
        navigationController?.pushViewController(commentsController, animated: true)
    }

    let cellId: String = "cellId"

    var posts: [Post] = []

    let navigationTitleButton: UIImageView = {
        let button = UIImageView(image: #imageLiteral(resourceName: "logo2"))
        button.isUserInteractionEnabled = true
        return button
    }()

    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        return refreshControl
    }()

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.noBackBarButtonItemTitle = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateFeed), name: SharePhotoController.updateFeedNotificationName, object: nil)

        collectionView?.backgroundColor = .white
        collectionView?.alwaysBounceVertical = true

        collectionView?.refreshControl = refreshControl

        collectionView?.register(HomePostCell.self, forCellWithReuseIdentifier: cellId)

        setupNavigationItems()

        fetchAllPosts()
    }

    func fetchAllPosts() {
        fetchPosts()
        fetchFollowingUserIds()
    }

    fileprivate func fetchFollowingUserIds() {
        Service.shared.fetchFollowingsByUid { (dictionary) in
            dictionary.forEach { (key, _) in
                Service.shared.fetchUserByUid(key) { (user) in
                    self.fetchPostsWithUser(user)
                }
            }
        }
    }

    fileprivate func fetchPosts() {
        Service.shared.fetchUserByUid { (user) in self.fetchPostsWithUser(user) }
    }

    fileprivate func fetchPostsWithUser(_ user: User) {

        Service.shared.fetchPostsByUid(user.uid) { (dictionaries) in
            self.collectionView?.refreshControl?.endRefreshing()

            dictionaries.forEach({ (key, value) in
                guard let dictionary = value as? [String: Any] else { return }

                Service.shared.fetchLikesByPostUid(key, completion: { (hasLiked, error) in
                    guard error == nil else { return }
                    guard let hasLiked = hasLiked else { return }

                    let post = Post(id: key, hasLiked: hasLiked, user: user, dictionary: dictionary)
                    self.posts.append(post)

                    self.posts.sort { $0.creationDate.compare($1.creationDate) == .orderedDescending }

                    self.collectionView?.reloadData()
                })
            })
        }
    }

    @objc func handleUpdateFeed() {
        handleRefresh()
    }

    @objc func handleRefresh() {
        posts.removeAll()
        fetchAllPosts()
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? HomePostCell else { return UICollectionViewCell() }

        cell.post = posts[indexPath.item]

        cell.delegate = self
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        let height = width + 40 + 8 + 8 + 50 + 60
        return CGSize(width: width, height: height)
    }
}

import GestureRecognizerClosures

extension HomeController {

    func setupNavigationItems() {

        if UIDevice.isSimulator {
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "camera3_disabled").withRenderingMode(.alwaysOriginal), style: .plain)
            navigationItem.leftBarButtonItem?.isEnabled = false
        } else {
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "camera3").withRenderingMode(.alwaysOriginal), style: .plain) { [unowned self] (_) in
                let cameraController = CameraController()
                self.present(cameraController, animated: true)
            }
        }

        navigationItem.titleView = navigationTitleButton

        navigationTitleButton.onTap { [unowned self] _ in
            self.collectionView?.scrollToItem(at: IndexPath(item: 0, section: 0), at: .bottom, animated: true)
        }

        navigationTitleButton.onDoubleTap { [unowned self] _ in
            guard let collectionView = self.collectionView else { return }
            let lastItem = self.collectionView(collectionView, numberOfItemsInSection: 0) - 1
            let indexPath = IndexPath(item: lastItem, section: 0)
            self.collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: true)
        }
    }
}

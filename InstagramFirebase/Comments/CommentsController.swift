//
//  CommentsController.swift
//  InstagramFirebase
//
//  Created by John Martin on 1/15/18.
//  Copyright © 2018 John Martin. All rights reserved.
//

import UIKit

class CommentsController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {

    private let cellId: String = "cellId"

    var comments: [Comment] = []

    var post: Post?

    lazy var inputContainerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .white
        let height: CGFloat = 50
        containerView.frame = CGRect(origin: .zero, size: CGSize(width: .infinity, height: height))

        let lineSeparatorView = UIView.separatorView(UIColor.grayLineSeparator)
        containerView.addSubviews(self.submitButton, self.commentTextField, lineSeparatorView)

        self.submitButton.anchor(topAnchor: containerView.topAnchor, bottomAnchor: containerView.bottomAnchor, rightAnchor: containerView.rightAnchor, paddingRight: 12, width: 50)
        self.commentTextField.anchor(topAnchor: containerView.topAnchor, leftAnchor: containerView.leftAnchor, bottomAnchor: containerView.bottomAnchor, rightAnchor: self.submitButton.leftAnchor, paddingLeft: 12)
        lineSeparatorView.anchor(topAnchor: containerView.topAnchor, leftAnchor: containerView.leftAnchor, rightAnchor: containerView.rightAnchor, height: 0.5)
        return containerView
    }()

    let submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send", for: .normal)
        button.setTitleColor(.darkBlue, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: UIFont.buttonFontSize)
        button.addTarget(self, action: #selector(handleSubmit(_:)), for: .touchUpInside)
        return button
    }()

    let commentTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter comment"
        return textField
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView?.backgroundColor = .white
        collectionView?.alwaysBounceVertical = true
        collectionView?.keyboardDismissMode = .interactive

        collectionView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -50, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: -50, right: 0)

        navigationItem.title = "Comments"

        collectionView?.register(CommentCell.self, forCellWithReuseIdentifier: cellId)

        fetchComments()
    }

    override var inputAccessoryView: UIView? {
        return inputContainerView
    }

    override var canBecomeFirstResponder: Bool {
        return true
    }

    func fetchComments() {
        guard let postId = self.post?.id else { return }

        Service.shared.fetchCommentsByPostUid(postId) { (dictionary) in
            guard let uid = dictionary["uid"] as? String else { return }

            Service.shared.fetchUserByUid(uid) { (user) in
                let comment = Comment(user: user, dictionary: dictionary)
                self.comments.append(comment)
                DispatchQueue.main.async { self.collectionView?.reloadData() }
            }
        }
    }

    @objc func handleSubmit(_ sender: UIButton) {
        guard let uid = Service.getCurrentUid() else { return }
        guard let text = commentTextField.text else { return }
        guard let postId = post?.id else { return }

        let values = ["text": text, "creationDate": Date().timeIntervalSince1970, "uid": uid] as [String: Any]

        Service.shared.uploadCommentByPostUid(postId, values: values) { (error) in
            guard error == nil else { print("Failed to insert comment:", error ?? ""); return }
            print("Successfully inserted comment.")
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? CommentCell else { return UICollectionViewCell() }

        cell.comment = comments[indexPath.item]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: CGFloat = 50

        return CGSize(width: view.frame.width, height: height)
    }
}

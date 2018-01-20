//
//  HomePostCell.swift
//  InstagramFirebase
//
//  Created by John Martin on 1/11/18.
//  Copyright © 2018 John Martin. All rights reserved.
//

import GestureRecognizerClosures
import UIKit

protocol HomePostCellDelegate: class {
    func didComment(post: Post)
    func didLike(for cell: HomePostCell)
}

class HomePostCell: BaseCell {

    weak var delegate: HomePostCellDelegate?

    var post: Post? {
        didSet {
            guard let postImageUrl = post?.imageUrl else { return }
            photoImageView.loadImage(urlString: postImageUrl)

            guard let hasLiked = post?.hasLiked else { return }

            likeButton.setImage(hasLiked ? #imageLiteral(resourceName: "like_selected").withRenderingMode(.alwaysOriginal) : #imageLiteral(resourceName: "like_unselected").withRenderingMode(.alwaysOriginal), for: .normal)

            usernameLabel.text = post?.user.username

            guard let profileImageUrl = post?.user.profileImageUrl else { return }

            userProfileImageView.loadImage(urlString: profileImageUrl)

            setupAttributedCaption()
        }
    }

    fileprivate func setupAttributedCaption() {
        guard let post = self.post else { return }

        let attributedText = NSMutableAttributedString(string: post.user.username, attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])

        attributedText.append(NSAttributedString(string: " \(post.caption)", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)]))

        attributedText.append(NSAttributedString(string: "\n\n", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 4)]))
        let timeAgoDisplay = post.creationDate.timeAgoDisplay()
        attributedText.append(NSAttributedString(string: timeAgoDisplay, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.gray]))

        captionLabel.attributedText = attributedText
    }

    let userProfileImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 40 / 2
        return imageView
    }()

    let photoImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "Username"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()

    let optionsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("•••", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()

    lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "like_unselected").withRenderingMode(.alwaysOriginal), for: .normal)
        button.onTap { [unowned self] _ in self.delegate?.didLike(for: self) }
        return button
    }()

    lazy var commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "comment").withRenderingMode(.alwaysOriginal), for: .normal)
        button.onTap { [unowned self] _ in
            if let post = self.post { self.delegate?.didComment(post: post) }
        }
        return button
    }()

    let sendMessageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "send2").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()

    let bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "ribbon").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()

    let captionLabel: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "Username", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: " Some caption text that will perhaps wrap onto the next line", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)]))

        attributedText.append(NSAttributedString(string: "\n\n", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 4)]))
        attributedText.append(NSAttributedString(string: "1 week ago", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.gray]))
        label.attributedText = attributedText

        label.numberOfLines = 0
        return label
    }()

    override func setupViews() {
        super.setupViews()

        addSubviews(userProfileImageView, usernameLabel, optionsButton, photoImageView, captionLabel)

        userProfileImageView.anchor(topAnchor: topAnchor, leftAnchor: leftAnchor, paddingTop: 8, paddingLeft: 8, width: 40, height: 40)
        usernameLabel.anchor(topAnchor: topAnchor, leftAnchor: userProfileImageView.rightAnchor, bottomAnchor: photoImageView.topAnchor, rightAnchor: optionsButton.leftAnchor, paddingLeft: 8)
        optionsButton.anchor(topAnchor: topAnchor, bottomAnchor: photoImageView.topAnchor, rightAnchor: rightAnchor, width: 44)
        photoImageView.anchor(topAnchor: userProfileImageView.bottomAnchor, leftAnchor: leftAnchor, rightAnchor: rightAnchor, paddingTop: 8, heightAnchorEqualToWidthAnchor: true)

        setupActionButtons()

        captionLabel.anchor(topAnchor: likeButton.bottomAnchor, leftAnchor: leftAnchor, bottomAnchor: bottomAnchor, rightAnchor: rightAnchor, paddingLeft: 8, paddingRight: 8)
    }

    fileprivate func setupActionButtons() {
        let stackView = UIStackView(arrangedSubviews: [likeButton, commentButton, sendMessageButton])
        stackView.distribution = .fillEqually
        addSubviews(stackView, bookmarkButton)
        stackView.anchor(topAnchor: photoImageView.bottomAnchor, leftAnchor: leftAnchor, paddingLeft: 4, width: 120, height: 50)
        bookmarkButton.anchor(topAnchor: photoImageView.bottomAnchor, rightAnchor: rightAnchor, width: 40, height: 50)
    }
}

//
//  UserProfileHeaderCell.swift
//  InstagramFirebase
//
//  Created by John Martin on 1/8/18.
//  Copyright © 2018 John Martin. All rights reserved.
//

import GestureRecognizerClosures
import UIKit

protocol UserProfileHeaderDelegate: class {
    func didChangeToListView()
    func didChangeToGridView()
}

class UserProfileHeaderCell: BaseCell {

    weak var delegate: UserProfileHeaderDelegate?

    var user: User? {
        didSet {
            guard let profileImageUrl = user?.profileImageUrl else { return }
            profileImageView.loadImage(urlString: profileImageUrl)
            usernameLabel.text = user?.username

            setupEditFollowButton()
        }
    }

    private var followingEditingStyle: FollowingEditingStyle = .editing {
        didSet {
            followingEditingStyle.setupFollowStyleButton(editProfileFollowButton)
        }
    }

    fileprivate func setupEditFollowButton() {
        guard let currentUserId = Service.getCurrentUid() else { return }
        guard let userId = user?.uid else { return }

        if currentUserId == userId {
            // edit profile
        } else {
            Service.shared.isFollowingWithUid(userId) { (isFollowing) in
                if let isFollowing = isFollowing, isFollowing == 1 {
                    self.followingEditingStyle = .unfollowing
                } else {
                    self.followingEditingStyle = .following
                }
            }
        }
    }

    @objc func handleEditProfileOrFollow(_ sender: UIButton) {
        guard let userId = user?.uid else { return }

        if followingEditingStyle == .unfollowing {
            Service.shared.unfollowWithUid(userId) { (error) in
                guard error == nil else { return }
                print("Successfully unfollowed user:", self.user?.username ?? "")
                self.followingEditingStyle = .following
            }
        } else  if followingEditingStyle == .following {
            Service.shared.followWithUid(userId) { (error) in
                guard error == nil else { return }
                print("Successfully followed user: ", self.user?.username ?? "")
                self.followingEditingStyle = .unfollowing
            }
        }
    }

    let profileImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.layer.cornerRadius = 80 / 2
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    lazy var gridButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "grid"), for: .normal)
        button.tintColor = .mainBlue
        button.onTap({ [unowned self] _ in
            self.gridButton.tintColor = .mainBlue
            self.listButton.tintColor = .grayButtonTint
            self.delegate?.didChangeToGridView()
        })
        return button
    }()

    lazy var listButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "list"), for: .normal)
        button.tintColor = .grayButtonTint
        button.onTap({ [unowned self] _ in
            self.listButton.tintColor = .mainBlue
            self.gridButton.tintColor = .grayButtonTint
            self.delegate?.didChangeToListView()
        })
        return button
    }()

    let bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "ribbon"), for: .normal)
        button.tintColor = .grayButtonTint
        return button
    }()

    lazy var editProfileFollowButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit Profile", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 3
        button.addTarget(self, action: #selector(handleEditProfileOrFollow(_:)), for: .touchUpInside)
        return button
    }()

    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "username"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()

    let postsLabel: UILabel = UserProfileHeaderCell.statsLabel(name: "posts", count: 11)
    let followersLabel: UILabel = UserProfileHeaderCell.statsLabel(name: "followers")
    let followingLabel: UILabel = UserProfileHeaderCell.statsLabel(name: "following")

    private static func statsLabel(name: String, count: Int = 0) -> UILabel {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "\(count)\n", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: name, attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)]))
        label.attributedText = attributedText
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }

    override func setupViews() {
        super.setupViews()

        backgroundColor = .white

        addSubviews(profileImageView, usernameLabel, editProfileFollowButton)

        setupBottomToolbar()
        setupUserStatsView()

        profileImageView.anchor(topAnchor: topAnchor, leftAnchor: leftAnchor, paddingTop: 12, paddingLeft: 12, width: 80, height: 80)
        usernameLabel.anchor(topAnchor: profileImageView.bottomAnchor, leftAnchor: leftAnchor, bottomAnchor: gridButton.topAnchor, rightAnchor: rightAnchor, paddingTop: 4, paddingLeft: 12, paddingRight: 12)

        editProfileFollowButton.anchor(topAnchor: postsLabel.bottomAnchor, leftAnchor: postsLabel.leftAnchor, rightAnchor: followingLabel.rightAnchor, paddingTop: 2, height: 34)
    }

    fileprivate func setupUserStatsView() {
        let stackView = UIStackView(arrangedSubviews: [postsLabel, followersLabel, followingLabel])

        stackView.distribution = .fillEqually // default axis is .horizontal

        addSubview(stackView)
        stackView.anchor(topAnchor: topAnchor, leftAnchor: profileImageView.rightAnchor, rightAnchor: rightAnchor, paddingTop: 12, paddingLeft: 12, paddingRight: 12, height: 50)
    }

    fileprivate func setupBottomToolbar() {
        let stackView = UIStackView(arrangedSubviews: [gridButton, listButton, bookmarkButton])

        stackView.distribution = .fillEqually // default axis is .horizontal
        addSubview(stackView)

        stackView.anchor(leftAnchor: leftAnchor, bottomAnchor: bottomAnchor, rightAnchor: rightAnchor, height: 50)

        // Add a thin light gray line to the top and bottom of the stack view
        stackView.dividingLines()
    }
}

//
//  UserSearchCell.swift
//  InstagramFirebase
//
//  Created by John Martin on 1/12/18.
//  Copyright © 2018 John Martin. All rights reserved.
//

import UIKit

class UserSearchCell: BaseCell {

    var user: User? {
        didSet {
            usernameLabel.text = user?.username

            guard let profileImageUrl = user?.profileImageUrl else { return }

            profileImageView.loadImage(urlString: profileImageUrl)
        }
    }

    let profileImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 50 / 2
        imageView.clipsToBounds = true
        return imageView
    }()

    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "Username"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()

    override func setupViews() {
        super.setupViews()

        let separatorView = UIView.separatorView()

        addSubviews(profileImageView, usernameLabel, separatorView)

        profileImageView.anchor(leftAnchor: leftAnchor, paddingLeft: 8, width: 50, height: 50, centerYAnchor: centerYAnchor)

        usernameLabel.anchor(topAnchor: topAnchor, leftAnchor: profileImageView.rightAnchor, bottomAnchor: bottomAnchor, rightAnchor: rightAnchor, paddingLeft: 8)

        separatorView.anchor(leftAnchor: usernameLabel.leftAnchor, bottomAnchor: bottomAnchor, rightAnchor: rightAnchor, height: 0.5)

    }
}

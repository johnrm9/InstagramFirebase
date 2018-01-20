//
//  CommentCell.swift
//  InstagramFirebase
//
//  Created by John Martin on 1/15/18.
//  Copyright © 2018 John Martin. All rights reserved.
//

import UIKit

class CommentCell: BaseCell {

    var comment: Comment? {
        didSet {
            guard let comment = comment else { return }
            let username = comment.user.username

            let attributedText = NSMutableAttributedString(string: username, attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)])
            attributedText.append(NSAttributedString(string: " " + comment.text, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: UIFont.systemFontSize)]))

            textView.attributedText = attributedText

            let urlString = comment.user.profileImageUrl
            profileImageView.loadImage(urlString: urlString)
        }
    }

    let textView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
        textView.text = "Sample Text"
        textView.backgroundColor = .clear
        return textView
    }()

    let profileImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.layer.cornerRadius = 40 / 2
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .green
        return imageView
    }()

    override func setupViews() {
        super.setupViews()

        let separatorView = UIView.separatorView()
        addSubviews(profileImageView, textView, separatorView)

        profileImageView.anchor(topAnchor: topAnchor, leftAnchor: leftAnchor, paddingTop: 8, paddingLeft: 8, width: 40, height: 40)

        textView.anchor(topAnchor: topAnchor, leftAnchor: profileImageView.rightAnchor, bottomAnchor: bottomAnchor, rightAnchor: rightAnchor, paddingTop: 4, paddingLeft: 4, paddingBottom: 4, paddingRight: 4)
        separatorView.anchor(leftAnchor: textView.leftAnchor, bottomAnchor: bottomAnchor, rightAnchor: rightAnchor, height: 0.5)
    }
}

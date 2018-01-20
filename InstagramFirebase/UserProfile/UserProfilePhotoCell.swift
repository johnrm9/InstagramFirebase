//
//  UserProfilePhotoCell.swift
//  InstagramFirebase
//
//  Created by John Martin on 1/10/18.
//  Copyright © 2018 John Martin. All rights reserved.
//

import UIKit

class UserProfilePhotoCell: BaseCell {

    var post: Post? {
        didSet {
            guard let imageUrl = post?.imageUrl else { return }
            photoImageView.loadImage(urlString: imageUrl)
        }
    }

    let photoImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    override func setupViews() {
        super.setupViews()

        addSubview(photoImageView)
        photoImageView.fillSuperview()

    }
}

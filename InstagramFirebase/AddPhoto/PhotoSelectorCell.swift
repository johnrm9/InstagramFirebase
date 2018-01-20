//
//  PhotoSelectorCell.swift
//  InstagramFirebase
//
//  Created by John Martin on 1/9/18.
//  Copyright © 2018 John Martin. All rights reserved.
//

import UIKit

class PhotoSelectorCell: BaseCell {

    let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        imageView.isUserInteractionEnabled = true
        return imageView
    }()

    override func setupViews() {
        super.setupViews()

        addSubview(photoImageView)
        photoImageView.fillSuperview()

    }
}

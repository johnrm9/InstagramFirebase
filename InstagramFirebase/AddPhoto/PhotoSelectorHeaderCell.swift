//
//  PhotoSelectorHeaderCell.swift
//  InstagramFirebase
//
//  Created by John Martin on 1/9/18.
//  Copyright © 2018 John Martin. All rights reserved.
//

import UIKit

class PhotoSelectorHeaderCell: BaseCell {

    let photoImageView: UIImageView = {
        let imageView = UIImageView()
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

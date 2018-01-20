//
//  BaseCell.swift
//  InstagramFirebase
//
//  Created by John Martin on 1/12/18.
//  Copyright © 2018 John Martin. All rights reserved.
//

import UIKit

class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
    }

    func setupViews() {

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

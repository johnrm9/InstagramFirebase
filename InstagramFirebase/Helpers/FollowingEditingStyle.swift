//
//  FollowingEditingStyle.swift
//  InstagramFirebase
//
//  Created by John Martin on 1/13/18.
//  Copyright © 2018 John Martin. All rights reserved.
//

import UIKit

enum FollowingEditingStyle {
    case following
    case unfollowing
    case editing

    func setupFollowStyleButton(_ button: UIButton) {
        switch self {
        case .following:
            button.setTitle("Follow", for: .normal)
            button.backgroundColor = UIColor.darkBlue
            button.setTitleColor(.white, for: .normal)
            button.layer.borderColor = UIColor.grayButtonTint.cgColor
        case .unfollowing:
            button.setTitle("Unfollow", for: .normal)
            button.backgroundColor = .white
            button.setTitleColor(.black, for: .normal)
            button.layer.borderColor = UIColor.grayButtonTint.cgColor
        case .editing:
            break
        }
    }
}

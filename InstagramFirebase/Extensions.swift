//
//  Extensions.swift
//  InstagramFirebase
//
//  Created by John Martin on 12/17/17.
//  Copyright © 2017 John Martin. All rights reserved.
//

import UIKit

extension UIColor {

    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red / 255, green: green / 255, blue: blue / 255, alpha: 1)
    }
}
extension UIColor {

    convenience public init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(r: r, g: g, b: b, a: 1)
    }

    convenience public init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        self.init(red: r / 255, green: g / 255, blue: b / 255, alpha: a)
    }
}

extension UIColor {
    class var lightBlue: UIColor {
        return UIColor(r: 149, g: 204, b: 244)
    }
    class var darkBlue: UIColor {
        return UIColor(r: 17, g: 154, b: 237)
    }
    class var logoBlue: UIColor {
        return UIColor(r: 0, g: 120, b: 175)
    }
    class var veryLightGray: UIColor {
        return UIColor(white: 0, alpha: 0.03)
    }
    class var backgroundGray: UIColor {
        return UIColor(r: 240, g: 240, b: 240)
    }
    class var lineSeparatorGray: UIColor {
        return UIColor(r: 230, g: 230, b: 230)
    }
    class var buttonBorderTintGray: UIColor {
        return UIColor(white: 0, alpha: 0.2)
    }
}

extension UIView {
    func anchor(topAnchor: NSLayoutYAxisAnchor? = nil, leftAnchor: NSLayoutXAxisAnchor? = nil, bottomAnchor: NSLayoutYAxisAnchor? = nil, rightAnchor: NSLayoutXAxisAnchor? = nil,
                paddingTop: CGFloat = 0, paddingLeft: CGFloat = 0, paddingBottom: CGFloat = 0, paddingRight: CGFloat = 0, width: CGFloat = 0, height: CGFloat = 0,
                centerXanchor: NSLayoutXAxisAnchor? = nil, centerYanchor: NSLayoutYAxisAnchor? = nil,
                heightAnchorEqualToWidthAnchor: Bool = false,
                centerAnchored: Bool = false) {

        translatesAutoresizingMaskIntoConstraints = false

        if let superview = superview, centerAnchored {
            centerXAnchor.constraint(equalTo: superview.centerXAnchor).isActive = true
            centerYAnchor.constraint(equalTo: superview.centerYAnchor).isActive = true
        }

        if heightAnchorEqualToWidthAnchor {
            self.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        }

        if let topAnchor = topAnchor {
            self.topAnchor.constraint(equalTo: topAnchor, constant: paddingTop).isActive = true
        }

        if let leftAnchor = leftAnchor {
            self.leftAnchor.constraint(equalTo: leftAnchor, constant: paddingLeft).isActive = true
        }

        if let bottomAnchor = bottomAnchor {
            self.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -paddingBottom).isActive = true
        }

        if let rightAnchor = rightAnchor {
            self.rightAnchor.constraint(equalTo: rightAnchor, constant: -paddingRight).isActive = true
        }

        if let centerXanchor = centerXanchor {
            self.centerXAnchor.constraint(equalTo: centerXanchor).isActive = true
        }

        if let centerYanchor = centerYanchor {
            self.centerYAnchor.constraint(equalTo: centerYanchor).isActive = true
        }

        if width > 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }

        if height > 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }

}
extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
}

//
//  Extensions.swift
//  InstagramFirebase
//
//  Created by John Martin on 12/17/17.
//  Copyright © 2017 John Martin. All rights reserved.
//

import UIKit

extension UIDevice {
    static var isSimulator: Bool {
        return ProcessInfo.processInfo.environment["SIMULATOR_DEVICE_NAME"] != nil
    }
}

extension Bool {
    @discardableResult
    mutating func toggle() -> Bool {
        self = !self
        return self
    }
    mutating func setOn(_ onOff: Bool = true) -> Bool {
        self = onOff
        return self
    }
}

extension UINavigationItem {
    var noBackBarButtonItemTitle: Bool {
        get { return false }
        set {
            if newValue { self.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil); self.backBarButtonItem?.tintColor = .black }
        }
    }
}

extension String {
    public var isEmail: Bool {
        let dataDetector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let firstMatch = dataDetector?.firstMatch(in: self, options: .reportCompletion, range: NSRange(location: 0, length: length))
        return (firstMatch?.range.location != NSNotFound && firstMatch?.url?.scheme == "mailto")
    }

    public var length: IndexDistance {
        return self.count
    }
}

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
    class var mainBlue: UIColor {
        return UIColor.rgb(red: 17, green: 154, blue: 237)
    }
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
    class var grayBackfield: UIColor {
        return UIColor(r: 230, g: 230, b: 230)
    }
    class var grayTextField: UIColor {
        return UIColor(white: 0, alpha: 0.03)
    }
    class var grayLineSeparator: UIColor {
        return UIColor(r: 230, g: 230, b: 230)
    }
    class var grayButtonTint: UIColor {
        return UIColor(white: 0, alpha: 0.2)
    }

    class var grayLabelBackground: UIColor {
        return UIColor(white: 0, alpha: 0.3)
    }
}

extension Date {
    func timeAgoDisplay() -> String {
        let secondsAgo = Int(Date().timeIntervalSince(self))

        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        let month = 4 * week

        let quotient: Int
        let unit: String
        if secondsAgo < minute {
            quotient = secondsAgo
            unit = "second"
        } else if secondsAgo < hour {
            quotient = secondsAgo / minute
            unit = "min"
        } else if secondsAgo < day {
            quotient = secondsAgo / hour
            unit = "hour"
        } else if secondsAgo < week {
            quotient = secondsAgo / day
            unit = "day"
        } else if secondsAgo < month {
            quotient = secondsAgo / week
            unit = "week"
        } else {
            quotient = secondsAgo / month
            unit = "month"
        }

        return "\(quotient) \(unit)\(quotient == 1 ? "" : "s") ago"

    }
}

extension UIView {
    public func dividingLines(backgroundColor: UIColor = .lightGray, height: CGFloat = 0.5) {
        [self.topAnchor, self.bottomAnchor].forEach { (topAnchor) in
            let v = UIView()
            v.backgroundColor = backgroundColor
            self.addSubview(v)
            v.anchor(topAnchor: topAnchor, leftAnchor: leftAnchor, rightAnchor: rightAnchor, height: height)
        }
    }
}

extension UIView {
    static func separatorView(_ backgroundColor: UIColor = UIColor(white: 0, alpha: 0.5)) -> UIView {
        let view = UIView()
        view.backgroundColor = backgroundColor
        return view
    }
}

extension UIView {
    func fillSuperview() {
        translatesAutoresizingMaskIntoConstraints = false
        if let superview = superview {
            leftAnchor.constraint(equalTo: superview.leftAnchor).isActive = true
            rightAnchor.constraint(equalTo: superview.rightAnchor).isActive = true
            topAnchor.constraint(equalTo: superview.topAnchor).isActive = true
            bottomAnchor.constraint(equalTo: superview.bottomAnchor).isActive = true
        }
    }
}

extension UIView {
    func anchor(topAnchor: NSLayoutYAxisAnchor? = nil, leftAnchor: NSLayoutXAxisAnchor? = nil, bottomAnchor: NSLayoutYAxisAnchor? = nil, rightAnchor: NSLayoutXAxisAnchor? = nil,
                paddingTop: CGFloat = 0, paddingLeft: CGFloat = 0, paddingBottom: CGFloat = 0, paddingRight: CGFloat = 0, width: CGFloat = 0, height: CGFloat = 0,
                centerXAnchor: NSLayoutXAxisAnchor? = nil, centerYAnchor: NSLayoutYAxisAnchor? = nil,
                heightAnchorEqualToWidthAnchor: Bool = false,
                centerAnchored: Bool = false) {

        translatesAutoresizingMaskIntoConstraints = false

        if let superview = superview, centerAnchored {
            self.centerXAnchor.constraint(equalTo: superview.centerXAnchor).isActive = true
            self.centerYAnchor.constraint(equalTo: superview.centerYAnchor).isActive = true
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

        if let centerXAnchor = centerXAnchor {
            self.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        }

        if let centerYAnchor = centerYAnchor {
            self.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
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

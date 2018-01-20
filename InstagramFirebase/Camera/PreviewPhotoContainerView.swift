//
//  PreviewPhotoContainerView.swift
//  InstagramFirebase
//
//  Created by John Martin on 1/14/18.
//  Copyright © 2018 John Martin. All rights reserved.
//

import GestureRecognizerClosures
import Photos
import UIKit

class PreviewPhotoContainerView: UIView {

    let previewImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "cancel_shadow").withRenderingMode(.alwaysOriginal), for: .normal)
        button.onTap { [unowned self] _ in self.removeFromSuperview() }
        return button
    }()

    let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "save_shadow").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleSave(_:)), for: .touchUpInside)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubviews(previewImageView, cancelButton, saveButton)

        previewImageView.fillSuperview()

        cancelButton.anchor(topAnchor: topAnchor, leftAnchor: leftAnchor, paddingTop: 12, paddingLeft: 12, width: 50, height: 50)

        saveButton.anchor(leftAnchor: leftAnchor, bottomAnchor: bottomAnchor, paddingLeft: 24, paddingBottom: 24, width: 50, height: 50)

    }

    @objc func handleSave(_ sender: UIButton) {
        guard let previewImage = previewImageView.image else { return }

        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: previewImage)
        }) { (_, error) in
            guard error == nil else { print("Failed to save image to photo library:", error ?? ""); return }
        }

        DispatchQueue.main.async {
            let saveLabel: UILabel = {
                let label = UILabel()
                label.text = "Saved Successfully"
                label.font = UIFont.boldSystemFont(ofSize: 18)
                label.textColor = .white
                label.numberOfLines = 0
                label.backgroundColor = .grayLabelBackground
                label.textAlignment = .center
                label.layer.cornerRadius = 10
                label.layer.masksToBounds = true
                return label
            }()

            self.addSubview(saveLabel)
            saveLabel.anchor(width: 150, height: 80, centerAnchored: true)

            saveLabel.layer.transform = CATransform3DMakeScale(0, 0, 0)

            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {

                saveLabel.layer.transform = CATransform3DMakeScale(1, 1, 1)

            }, completion: { (_) in
                UIView.animate(withDuration: 0.5, delay: 0.75, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {

                    saveLabel.layer.transform = CATransform3DMakeScale(0.1, 0.1, 0.1)
                    saveLabel.alpha = 0

                }, completion: { (_) in
                    saveLabel.removeFromSuperview()
                })
            })
        }

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//
//  SharePhotoController.swift
//  InstagramFirebase
//
//  Created by John Martin on 1/9/18.
//  Copyright © 2018 John Martin. All rights reserved.
//

import UIKit

class SharePhotoController: UIViewController, UITextViewDelegate {

    static let updateFeedNotificationName: Notification.Name = NSNotification.Name(rawValue: "UpdateFeed")

    var selectedImage: UIImage? {
        didSet {
            self.imageView.image = selectedImage
        }
    }

    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .green
        return imageView
    }()

    let textView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.backgroundColor = .clear
        return textView
    }()

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .backgroundGray

        textView.delegate = self

        setupNavigationButtons()
        setupViews()
    }

    func setupViews() {
        let containerView = UIView()
        containerView.backgroundColor = .white

        view.addSubview(containerView)
        if #available(iOS 11.0, *) {
            containerView.anchor(topAnchor: view.safeAreaLayoutGuide.topAnchor, leftAnchor: view.leftAnchor, rightAnchor: view.rightAnchor, height: 100)
        } else {
            containerView.anchor(topAnchor: topLayoutGuide.bottomAnchor, leftAnchor: view.leftAnchor, rightAnchor: view.rightAnchor, height: 100)
        }

        containerView.addSubviews(imageView, textView)
        imageView.anchor(topAnchor: containerView.topAnchor, leftAnchor: containerView.leftAnchor, bottomAnchor: containerView.bottomAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 0, width: 84)

        textView.anchor(topAnchor: containerView.topAnchor, leftAnchor: imageView.rightAnchor, bottomAnchor: containerView.bottomAnchor, rightAnchor: containerView.rightAnchor, paddingLeft: 4)
    }

    fileprivate func setupNavigationButtons() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(handleShare))
    }

    private var isUploadingImage: Bool? {
        didSet {
            navigationItem.rightBarButtonItem?.isEnabled = !(isUploadingImage ?? false)
        }
    }

    fileprivate func postImageWithUrl(imageUrl: String) {
        guard let postImage = selectedImage else { return }
        guard let caption = textView.text else { return }

        guard let uid = Service.getCurrentUid() else { return }

        let imageWidth = postImage.size.width
        let imageHeight = postImage.size.height

        let values = ["imageUrl": imageUrl, "caption": caption, "imageWidth": imageWidth, "imageHeight": imageHeight, "creationDate": Date().timeIntervalSince1970] as [String: Any]

        Service.shared.uploadPost(uid: uid, values: values) { (error) in
            guard error == nil else { self.isUploadingImage = false; print("Failed to save post to DB", error ?? ""); return }
            print("Successfully saved post to DB")
            self.dismiss(animated: true)

            NotificationCenter.default.post(name: SharePhotoController.updateFeedNotificationName, object: nil)
        }
    }

     @objc func handleShare() {
        guard let caption = textView.text, caption.count > 0 else { return }
        guard let image = selectedImage else { return }

        guard let uploadData = UIImageJPEGRepresentation(image, 0.5) else { return }

        self.isUploadingImage = true

        Service.shared.postImageData(uploadData: uploadData) { (imageUrl, error) in
            guard error == nil else { print("Failed to upload post image:", error ?? ""); self.isUploadingImage = false; return }

            guard let imageUrl = imageUrl else { return }

            print("Successfully uploaded post image:", imageUrl)

            self.postImageWithUrl(imageUrl: imageUrl)
        }
    }
}

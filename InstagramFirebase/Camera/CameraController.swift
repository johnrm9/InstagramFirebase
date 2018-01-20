//
//  CameraController.swift
//  InstagramFirebase
//
//  Created by John Martin on 1/14/18.
//  Copyright © 2018 John Martin. All rights reserved.
//

import AVFoundation
import GestureRecognizerClosures
import UIKit

class CameraController: UIViewController, UIViewControllerTransitioningDelegate, AVCapturePhotoCaptureDelegate {

    let output: AVCapturePhotoOutput = AVCapturePhotoOutput()

    let capturePhotoSettings: AVCapturePhotoSettings = {
        let settings = AVCapturePhotoSettings()
        guard let previewFormatType = settings.availablePreviewPhotoPixelFormatTypes.first else { return settings }
        settings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewFormatType]
        return settings
    }()

    lazy var dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "right_arrow_shadow").withRenderingMode(.alwaysOriginal), for: .normal)
        button.onTap { [unowned self] _ in self.dismiss(animated: true) }
        return button
    }()

    let capturePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "capture_photo").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleCapturePhoto(_:)), for: .touchUpInside)
        return button
    }()

    override var prefersStatusBarHidden: Bool {
        return true
    }

    let customAnimationPresentor: UIViewControllerAnimatedTransitioning = CustomAnimationPresentor()
    let customAnimationDismisser: UIViewControllerAnimatedTransitioning = CustomAnimationDismisser()

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return customAnimationPresentor
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return customAnimationDismisser
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        transitioningDelegate = self

        setupCaptureSession()
        setupHUD()
    }

    private func setupHUD() {
        view.addSubviews(capturePhotoButton, dismissButton)

        capturePhotoButton.anchor(bottomAnchor: view.bottomAnchor, paddingBottom: 24, width: 80, height: 80, centerXAnchor: view.centerXAnchor)
        dismissButton.anchor(topAnchor: view.topAnchor, rightAnchor: view.rightAnchor, paddingTop: 12, paddingRight: 12, width: 50, height: 50)
    }
}

extension CameraController {

    @objc func handleCapturePhoto(_ sender: UIButton) {
        output.capturePhoto(with: capturePhotoSettings, delegate: self)
    }

    @available(iOS 11.0, *)
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard error == nil else { print("Fail to capture photo: \(String(describing: error))"); return }
        guard let imageData = photo.fileDataRepresentation() else { return }

        guard let previewImage = UIImage(data: imageData) else { return }

        loadPreviewImage(previewImage)
        print("Finish processing photo sample buffer ...")
    }

    @available(iOS, deprecated: 10.0)
    func photoOutput(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings,
                     bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        guard error == nil else { print("Fail to capture photo: \(String(describing: error))"); return }
        guard let photoSampleBuffer = photoSampleBuffer, let previewPhotoSampleBuffer = previewPhotoSampleBuffer else { return }
        guard let imageData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer, previewPhotoSampleBuffer: previewPhotoSampleBuffer) else { return }
        guard let previewImage = UIImage(data: imageData) else { return }

        loadPreviewImage(previewImage)
        //print("Finish processing photo sample buffer...")
    }

    func loadPreviewImage(_ previewImage: UIImage) {
        let containerView = PreviewPhotoContainerView()
        containerView.previewImageView.image = previewImage
        view.addSubview(containerView)
        containerView.fillSuperview()
    }

    func setupCaptureSession() {
        let captureSession = AVCaptureSession()

        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }

        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
            }
        } catch let error {
            print("Could not setup camera input:", error)
        }

        if captureSession.canAddOutput(output) {
            captureSession.addOutput(output)
        }
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.frame
        view.layer.addSublayer(previewLayer)

        captureSession.startRunning()
    }
}

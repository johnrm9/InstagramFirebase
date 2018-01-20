//
//  PhotoSelectorController.swift
//  InstagramFirebase
//
//  Created by John Martin on 1/9/18.
//  Copyright © 2018 John Martin. All rights reserved.
//

import GestureRecognizerClosures
import Photos
import UIKit

class PhotoSelectorController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    let cellId: String = "cellId"
    let headerId: String = "headerId"

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView?.backgroundColor = .white
        collectionView?.alwaysBounceVertical = true

        setupNavigationButtons()

        collectionView?.register(PhotoSelectorCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.register(PhotoSelectorHeaderCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)

        fetchPhotos()
    }

    var selectedImage: UIImage?
    var images: [UIImage] = [UIImage]()

    let cachingImageManager: PHCachingImageManager = PHCachingImageManager()
    var assets: [PHAsset] = [] {
        willSet {
            cachingImageManager.stopCachingImagesForAllAssets()
        }

        didSet {
            cachingImageManager.startCachingImages(for: self.assets,
                                                   targetSize: PHImageManagerMaximumSize,
                                                   contentMode: .aspectFit,
                                                   options: nil
            )
        }
    }

    let assetsFetchOptions: PHFetchOptions = {
        let fetchOptions = PHFetchOptions()
        fetchOptions.fetchLimit = 30
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchOptions.sortDescriptors = [sortDescriptor]
        return fetchOptions
    }()

    fileprivate func fetchPhotos() {
        let allPhotos = PHAsset.fetchAssets(with: .image, options: assetsFetchOptions)

        DispatchQueue.global(qos: .background).async {
            allPhotos.enumerateObjects({ (asset, count, _) in
                let imageManager = PHImageManager.default()
                let targetSize = CGSize(width: 200, height: 200)

                let options = PHImageRequestOptions()
                options.isSynchronous = true
                options.resizeMode = .fast
                imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: options, resultHandler: { (image, _) in
                    if let image = image {
                        self.images.append(image)
                        self.assets.append(asset)
                        if self.selectedImage == nil {
                            self.selectedImage = image
                        }
                    }
                    if count == allPhotos.count - 1 {
                        DispatchQueue.main.async {
                            self.collectionView?.reloadData()
                        }
                    }
                })
            })
        }

    }

    fileprivate func setupNavigationButtons() {
        navigationController?.navigationBar.tintColor = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain) { [unowned self] _ in self.dismiss(animated: true) }
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain) { [unowned self] _ in
            let sharePhotoController = SharePhotoController()
            sharePhotoController.selectedImage = self.headerCell?.photoImageView.image
            self.navigationController?.pushViewController(sharePhotoController, animated: true)
        }
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedImage = images[indexPath.item]
        self.collectionView?.reloadData()
        let indexPath = IndexPath(item: 0, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
    }

    var headerCell: PhotoSelectorHeaderCell?

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerCell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as? PhotoSelectorHeaderCell else { return  UICollectionReusableView() }

        self.headerCell = headerCell

        headerCell.photoImageView.image = self.selectedImage

        if let selectedImage = selectedImage, let index = self.images.index(of: selectedImage) {
            let selectedAsset = self.assets[index]
            let imageManager = PHImageManager.default()
            // let targetSize = CGSize(width: 600, height: 600)
            let targetSize = PHImageManagerMaximumSize

            imageManager.requestImage(for: selectedAsset, targetSize: targetSize, contentMode: .aspectFit, options: nil, resultHandler: { (image, _) in
                headerCell.photoImageView.image = image
            })
        }

        return headerCell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = view.frame.width
        return CGSize(width: width, height: width)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? PhotoSelectorCell else { return UICollectionViewCell() }

        cell.photoImageView.image = images[indexPath.item]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 3) / 4
        return CGSize(width: width, height: width)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}

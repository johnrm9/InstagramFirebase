//
//  MainTabBarController.swift
//  InstagramFirebase
//
//  Created by John Martin on 1/8/18.
//  Copyright © 2018 John Martin. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = viewControllers?.index(of: viewController)

        if index == 2 {
            let layout = UICollectionViewFlowLayout()
            let photoCollectionController = PhotoSelectorController(collectionViewLayout: layout)
            let navigationController = UINavigationController(rootViewController: photoCollectionController)

            present(navigationController, animated: true)
        }
        return index != 2
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self

        if Service.isLoggedOut() {
            print("Service was logged out")
            DispatchQueue.main.async {
                let loginController = LoginController()
                let navController = UINavigationController(rootViewController: loginController)
                self.present(navController, animated: true)
            }
            return
        }

        setupViewControllers()
    }

    func setupViewControllers() {
        tabBar.tintColor = .black

        let homeNavController = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "home_unselected"), selectedImage: #imageLiteral(resourceName: "home_selected"), rootViewController: HomeController(collectionViewLayout: UICollectionViewFlowLayout()))
        //let homeNavController = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "home_unselected"), selectedImage: #imageLiteral(resourceName: "home_selected"), rootViewController: UserProfileController(collectionViewLayout: UICollectionViewFlowLayout()))

        let searchNavController = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "search_unselected"), selectedImage: #imageLiteral(resourceName: "search_selected"), rootViewController: UserSearchController(collectionViewLayout: UICollectionViewFlowLayout()))
        let plusNavController = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "plus_unselected"), selectedImage: #imageLiteral(resourceName: "plus_unselected"))
        let likeNavController = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "like_unselected"), selectedImage: #imageLiteral(resourceName: "like_selected"))
        let userProfileNavController = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "profile_unselected"), selectedImage: #imageLiteral(resourceName: "profile_selected"), rootViewController: UserProfileController(collectionViewLayout: UICollectionViewFlowLayout()))
        //let userProfileNavController = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "profile_unselected"), selectedImage: #imageLiteral(resourceName: "profile_selected"))

        viewControllers = [homeNavController,
                           searchNavController,
                           plusNavController,
                           likeNavController,
                           userProfileNavController]
        //        guard let items = tabBar.items else { return }
        //        for item in items {
        //            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        //        }

    }

    fileprivate func templateNavigationController(unselectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController = UIViewController()) -> UINavigationController {
        let viewController = rootViewController
        let navigationController = UINavigationController(rootViewController: viewController)

        navigationController.tabBarItem.image = unselectedImage
        navigationController.tabBarItem.selectedImage = selectedImage
        navigationController.tabBarItem.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)

        viewController.view.backgroundColor = .white

        return navigationController
    }

}

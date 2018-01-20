//
//  AppDelegate.swift
//  InstagramFirebase
//
//  Created by John Martin on 12/17/17.
//  Copyright © 2017 John Martin. All rights reserved.
//

import Firebase
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        FirebaseConfiguration.shared.setLoggerLevel(.min)
        FirebaseApp.configure()

        window = UIWindow()
        window?.makeKeyAndVisible()
        window?.rootViewController = MainTabBarController()
        return true
    }
}

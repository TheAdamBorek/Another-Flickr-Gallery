//
//  AppDelegate.swift
//  Another-Flickr-Gallery
//
//  Created by Adam Borek on 15.05.2017.
//  Copyright © 2017 adamborek.com. All rights reserved.
//

import UIKit
import RxSwift

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {
    private let window: UIWindow = {
        let window = UIWindow()
        window.frame = UIScreen.main.bounds
        return window
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let navigationController = UINavigationController(rootViewController: GalleryViewController())
        navigationController.navigationBar.isTranslucent = false
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        return true
    }
}

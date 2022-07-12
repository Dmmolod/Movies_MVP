//
//  AppDelegate.swift
//  Movies
//
//  Created by Дмитрий Молодецкий on 04.07.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = AppNavigation()
        window?.makeKeyAndVisible()
        return true
    }

}


//
//  AppDelegate.swift
//  FeelingMeterIOS
//
//  Created by Andrew Bricker on 2/5/19.
//  Copyright © 2019 code FU Creative. All rights reserved.
//

import UIKit
import ReSwift

var mainStore = Store<MainState>(
    reducer: mainReducer,
    state: nil
)

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        window = UIWindow(frame: UIScreen.main.bounds)
//        let feelingViewController = UIViewController()
//        feelingViewController.view.backgroundColor = UIColor.white
//        window!.rootViewController = feelingViewController
//        window!.makeKeyAndVisible()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = UINavigationController(rootViewController: FeelingViewController())
        return true
    }
}


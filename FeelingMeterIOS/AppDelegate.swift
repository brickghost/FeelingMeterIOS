//
//  AppDelegate.swift
//  FeelingMeterIOS
//
//  Created by Andrew Bricker on 2/5/19.
//  Copyright © 2019 code FU Creative. All rights reserved.
//

import UIKit
import ReSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var socket: SocketService?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = UINavigationController(rootViewController: FeelingViewController())
        
        socket = SocketService()
        socket?.connect()
        return true
    }
}


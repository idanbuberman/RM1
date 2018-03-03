//
//  AppDelegate.swift
//  RM1
//
//  Created by Idan Buberman on 01/03/2018.
//  Copyright © 2018 Idan Buberman. All rights reserved.
//

import UIKit
import AWSMobileClient
import AWSCore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        AWSDDLog.add(AWSDDTTYLogger.sharedInstance)
        AWSDDLog.sharedInstance.logLevel = .info
        
        // Create AWSMobileClient to connect with AWS
        return AWSMobileClient.sharedInstance().interceptApplication(
            application, didFinishLaunchingWithOptions: launchOptions)
    }



}


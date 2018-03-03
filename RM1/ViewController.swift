//
//  ViewController.swift
//  RM1
//
//  Created by Idan Buberman on 01/03/2018.
//  Copyright © 2018 Idan Buberman. All rights reserved.
//

import UIKit
import AWSAuthCore
import AWSAuthUI

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presentSignInUIViewController()
    }
    
    func presentSignInUIViewController() {
        let config = AWSAuthUIConfiguration()
        config.enableUserPoolsUI = true
        //        config.backgroundColor = UIColor.blue
        //        config.font = UIFont (name: "Helvetica Neue", size: 20)
        //        config.isBackgroundColorFullScreen = true
        config.canCancel = true
        
        if !AWSSignInManager.sharedInstance().isLoggedIn {
            AWSAuthUIViewController.presentViewController(with: self.navigationController!, configuration: config, completionHandler: { (provider: AWSSignInProvider, error: Error?) in
                if error != nil {
                    print("Error occurred: \(String(describing: error))")
                } else {
                    // Sign in successful.
                }
            })
        }
    }
}


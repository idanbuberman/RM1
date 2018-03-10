//
//  RecordVideoViewController.swift
//  RM1
//
//  Created by Idan Buberman on 10/03/2018.
//  Copyright © 2018 Idan Buberman. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices

class RecordVideoViewController: UIViewController {
    func startCameraFromViewController(_ viewController: UIViewController, withDelegate delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate) -> Bool {
        if UIImagePickerController.isSourceTypeAvailable(.camera) == false {
            return false
        }
        
        let cameraController = UIImagePickerController()
        cameraController.sourceType = .camera
        cameraController.mediaTypes = [kUTTypeMovie as NSString as String]
        cameraController.allowsEditing = false
        cameraController.delegate = delegate
        
        self.present(cameraController, animated: true, completion: nil)
        return true
    }
    
    @IBAction func record(sender: AnyObject) {
        startCameraFromViewController(self, withDelegate: self)
    }
}

extension RecordVideoViewController: UIImagePickerControllerDelegate {
}

extension RecordVideoViewController: UINavigationControllerDelegate {
}

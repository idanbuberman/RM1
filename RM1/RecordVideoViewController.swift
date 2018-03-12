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

class RecordVideoViewController: UIViewController, UINavigationControllerDelegate {
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
        _ = startCameraFromViewController(self, withDelegate: self)
    }
}

extension RecordVideoViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true, completion: nil)
        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        // Handle a movie capture
        if mediaType == kUTTypeMovie {
            guard let path = (info[UIImagePickerControllerMediaURL] as! NSURL).path else { return }
            if UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(path) {
                UISaveVideoAtPathToSavedPhotosAlbum(path, self, #selector(RecordVideoViewController.video(videoPath:didFinishSavingWithError:contextInfo:)), nil)
            }
        }
    }
    
    @objc func video(videoPath: NSString, didFinishSavingWithError error: NSError?, contextInfo info: AnyObject) {
        DataManager.shared.uploadData(url: URL(string: videoPath as String)!, key: "pahg.mov", completion: {_,_  in})
        var title = "Success"
        var message = "Video was saved"
        if let _ = error {
            title = "Error"
            message = "Video failed to save"
        }
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}


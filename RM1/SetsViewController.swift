//
//  SetsViewController.swift
//  RM1
//
//  Created by Idan Buberman on 03/03/2018.
//  Copyright © 2018 Idan Buberman. All rights reserved.
//

import Foundation
import UIKit
import AWSS3

class SetsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        DataManager.shared.uploadData()
        upload()
//        download()
    }
    let image = UIImage(named: "pic.JPG")!
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        var imageView = UIImageView(image: image)
//        view.addSubview(imageView)
//        imageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//        imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    
    
    
    
    func upload() {
        
        var data = Data() // The data to upload
//        data = UIImagePNGRepresentation(image)!
        data = "idan buberman test".data(using: String.Encoding.utf8)!

        let expression = AWSS3TransferUtilityUploadExpression()
        expression.progressBlock = { (task, progress) in
            DispatchQueue.main.async {
                // Update a progress bar.
                //                self.progressView.progress = Float(progress.fractionCompleted)
            }
        }
        
        let completionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock = { (task, error) -> Void in
            DispatchQueue.main.async {
                if let error = error {
                    NSLog("Failed with error: \(error)")
                }
                //                else if(self.progressView.progress != 1.0) {
                //                    NSLog("Error: Failed.")
                //                } else {
                //                    NSLog("Success.")
                //                }
            }
        }
        
        var refUploadTask: AWSS3TransferUtilityTask?
        let transferUtility = AWSS3TransferUtility.default()
        let bucketName: String = "rm-deployments-mobilehub-1354391713"
        let keyName: String = "test.txt"
        let contentType: String = "texe/plain"//"image/JPG"
        transferUtility.uploadData(data, bucket: bucketName,
                                   key: keyName,
                                   contentType: contentType,
                                   expression: expression,
                                   completionHandler: completionHandler).continueWith { (task) -> AnyObject! in
                                    if let error = task.error {
                                        print("Error: \(error.localizedDescription)")
                                    }
                                    
                                    if let uploadTask = task.result {
                                        // Do something with uploadTask.
                                        // The uploadTask can be used to pause/resume/cancel the operation, retrieve task specific information
                                        refUploadTask = uploadTask
                                    }
                                    
                                    return nil;
        }
    }
    
    
    
    
    
    func download() {
        let expression = AWSS3TransferUtilityDownloadExpression()
        expression.progressBlock = {(task, progress) in
            DispatchQueue.main.async {
                // Do something e.g. Update a progress bar.
            }
        }
        
        var completionHandler: AWSS3TransferUtilityDownloadCompletionHandlerBlock?
        completionHandler = { (task, URL, data, error) -> Void in
            DispatchQueue.main.async {
                print(error)
                var imageUIImage: String = String(data: data!, encoding: .utf8)!
                print(imageUIImage)
//                var imageVi: UIImageView = UIImageView(image: imageUIImage)
                // Do something e.g. Alert a user for transfer completion.
                // On failed downloads, `error` contains the error object.
            }
        }
        
        let transferUtility = AWSS3TransferUtility.default()
        transferUtility.downloadData(fromBucket: "rm-deployments-mobilehub-1354391713", key: "test.txt", expression: expression, completionHandler: completionHandler).continueWith {
            (task) -> AnyObject! in
            if let error = task.error {
                print("Error: \(error.localizedDescription)")
            }
            
            if let _ = task.result {
                // Do something with downloadTask.
                
            }
            return nil;
        }
    }
}



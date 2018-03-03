//
//  DataManager.swift
//  RM1
//
//  Created by Idan Buberman on 03/03/2018.
//  Copyright © 2018 Idan Buberman. All rights reserved.
//

import Foundation
import AWSS3

class DataManager {
    let progressView: UIProgressView! = UIProgressView()
    
    static let shared: DataManager = DataManager()
    
    private init() {
        // For example, create a progress bar
        progressView.progress = 0.0;
    }
    
    func uploadData() {
        let image = UIImage(named: "pic.JPG")!
        var data = Data() // The data to upload
        data = UIImagePNGRepresentation(image)!
        
        let expression = AWSS3TransferUtilityUploadExpression()
        expression.progressBlock = { (task, progress) in
            DispatchQueue.main.async {
                // Update a progress bar.
                self.progressView.progress = Float(progress.fractionCompleted)
            }
        }
        
        let completionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock = { (task, error) -> Void in
            DispatchQueue.main.async {
                if let error = error {
                    NSLog("Failed with error: \(error)")
                }
                else if(self.progressView.progress != 1.0) {
                    NSLog("Error: Failed.")
                } else {
                    NSLog("Success.")
                }
            }
        }
        
        var refUploadTask: AWSS3TransferUtilityTask?
        let transferUtility = AWSS3TransferUtility.default()
        transferUtility.uploadData(data, bucket: "rm-deployments-mobilehub-1354391713", key: "test.jpg", contentType: "image/JPG", expression: expression, completionHandler: completionHandler).continueWith { (task) -> AnyObject! in
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
    
    func downloadData() {
        let expression = AWSS3TransferUtilityDownloadExpression()
        expression.progressBlock = {(task, progress) in
            DispatchQueue.main.async {
                // Do something e.g. Update a progress bar.
            }
        }
        
        var completionHandler: AWSS3TransferUtilityDownloadCompletionHandlerBlock?
        completionHandler = { (task, URL, data, error) -> Void in
            DispatchQueue.main.async {
                // Do something e.g. Alert a user for transfer completion.
                // On failed downloads, `error` contains the error object.
            }
        }
        
        let transferUtility = AWSS3TransferUtility.default()
        transferUtility.downloadData(fromBucket: "rm-deployments-mobilehub-1354391713", key: "YourFileName", expression: expression, completionHandler: completionHandler).continueWith {
            (task) -> AnyObject! in if let error = task.error {
                print("Error: \(error.localizedDescription)")
            }
            
            if let _ = task.result {
                // Do something with downloadTask.
                
            }
            return nil;
        }
    }
    
}

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
    
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var downloadedImage: UIImageView!
    
    let key: String = "picFat.jpg"

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        uploadImage()
    }
    func uploadImage() {
        var data: Data = Data() // The data to upload

        let image = UIImage(named: "Image")
        data = UIImageJPEGRepresentation(image!, 0.9)!
        
        let expression = AWSS3TransferUtilityUploadExpression()
        expression.progressBlock = { (task, progress) in
            DispatchQueue.main.async {
                self.progressBar.observedProgress = progress
            }
        }

        DataManager.shared.uploadData(data: data, key: key, expression: expression) { (task, error) -> Void in
            DispatchQueue.main.async {
                if let error = error {
                    NSLog("Failed with error: \(error)")
                }
                else if(self.progressBar.progress != 1.0) {
                    NSLog("Error: Failed.")
                } else {
                    NSLog("Success.")
                }
            }
        }
    }

    func downloadImage() {
        self.downloadedImage.isHidden = true

        let expression = AWSS3TransferUtilityDownloadExpression()
        expression.progressBlock = { (task, progress) in
            DispatchQueue.main.async {
                self.progressBar.observedProgress = progress
            }
        }
        
        DataManager.shared.download(key: key, expression: expression) { (task, URL, data, error) -> Void in
            DispatchQueue.main.async {
                if let error = error {
                    print(error)
                } else {
                    if let pic = UIImage(data: data!) {
                        UIView.animate(withDuration: 1.0) {
                            self.downloadedImage.image = pic
                            self.downloadedImage.isHidden = false
                            self.progressBar.isHidden = true
                        }
                    }
                }
            }
        }
    }
 }



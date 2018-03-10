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
    static let shared: DataManager = DataManager()
    
    private let bucket: String = "rm-deployments-mobilehub-1354391713"
    private let transferUtility: AWSS3TransferUtility = AWSS3TransferUtility.default()
    private let serviceManager: AWSServiceManager? = AWSServiceManager.default()
    
    private init() {
        let accessKey = "AKIAJSWZCGOJTGYFX3PA"
        let secretKey = "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"
        let credentialsProvider = AWSStaticCredentialsProvider(accessKey: accessKey, secretKey: secretKey)
        let configuration = AWSServiceConfiguration(region: .USEast2, credentialsProvider: credentialsProvider)
        serviceManager?.defaultServiceConfiguration = configuration
    }
    
    func uploadData(data: Data, key: String, expression: AWSS3TransferUtilityUploadExpression, completion: @escaping AWSS3TransferUtilityUploadCompletionHandlerBlock) {
        
        transferUtility.uploadData(data,
                                   key: "test.jpg",
                                   contentType: "image/JPG",
                                   expression: expression,
                                   completionHandler: completion).continueWith { (task) -> AnyObject! in
                                    if let error = task.error {
                                        print("Error: \(error.localizedDescription)")
                                    }
                                    return nil;
        }
    }
    
    func download(key: String, expression: AWSS3TransferUtilityDownloadExpression, completion: AWSS3TransferUtilityDownloadCompletionHandlerBlock?) {
        
        transferUtility.downloadData(fromBucket: bucket,
                                     key: key,
                                     expression: expression,
                                     completionHandler: completion).continueWith {
                                        (task) -> AnyObject! in
                                        if let error = task.error {
                                            print("Error: \(error.localizedDescription)")
                                        }
                                        return nil;
        }
    }
}

//
//  OperationProfileDataManager.swift
//  TinkoffFintechIOSProject
//
//  Created by Юрий Забегаев on 21/10/2018.
//  Copyright © 2018 Юрий Забегаев. All rights reserved.
//

import Foundation


class OperationProfileDataManager: ProfileDataManager {
    
    func save(profileData: ProfileData, completion: ((Bool) -> ())?) {
        let saveOperation = SaveProfileDataOperation(profileData: profileData, completion: { isSucceeded in
            OperationQueue.main.addOperation { completion?(isSucceeded) }
        })
        
        let operationQueue = OperationQueue()
        operationQueue.qualityOfService = .userInitiated
        operationQueue.addOperation(saveOperation)
    }
    
    func loadProfileData(completion: ((ProfileData) -> ())?) {
        let loadOperation = LoadProfileDataOperation(completion: { data in
            OperationQueue.main.addOperation { completion?(data) }
        })
        
        let operationQueue = OperationQueue()
        operationQueue.qualityOfService = .userInitiated
        operationQueue.addOperation(loadOperation)
    }

}

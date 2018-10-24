//
//  GCDDataManager.swift
//  TinkoffFintechIOSProject
//
//  Created by Юрий Забегаев on 21/10/2018.
//  Copyright © 2018 Юрий Забегаев. All rights reserved.
//

import Foundation


class GCDProfileDataManager: ProfileDataManager {
    
    private let dataHandler = ProfileDataHandler()
    let queueLabel: String
    let queue: DispatchQueue
    
    init() {
        queueLabel = "ru.fintech-chat.save-profile-queue"
        queue = DispatchQueue(label: queueLabel, qos: .userInitiated)
    }
    
    func save(profileData: ProfileData, completion: ((Bool) -> ())? ) {
        queue.async { [weak self] in
            guard let dataHandler = self?.dataHandler else { return }
            let isSucceeded = dataHandler.save(profileData: profileData)
            DispatchQueue.main.async {
                completion?(isSucceeded)
            }
        }
    }
    
    func loadProfileData(completion: ((ProfileData) -> ())? ) {
        let queue = DispatchQueue.global(qos: .userInitiated)
        queue.async {
            let newData = self.dataHandler.loadProfileData()
            DispatchQueue.main.async {
                completion?(newData)
            }
        }
        
    }
}

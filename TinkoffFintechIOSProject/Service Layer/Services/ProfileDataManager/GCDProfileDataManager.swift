//
//  GCDDataManager.swift
//  TinkoffFintechIOSProject
//
//  Created by Юрий Забегаев on 21/10/2018.
//  Copyright © 2018 Юрий Забегаев. All rights reserved.
//

import Foundation

class GCDProfileDataManager: ProfileDataManagerProtocol {

	private let dataHandler: ProfileDataHandlerProtocol
    let queueLabel: String
    let queue: DispatchQueue

	private(set) var myUserID: String

	init(myUserID: String, dataHandler: ProfileDataHandlerProtocol) {
		self.dataHandler = dataHandler
		self.myUserID = myUserID
        queueLabel = "ru.fintech-chat.save-profile-queue"
        queue = DispatchQueue(label: queueLabel, qos: .userInitiated)
    }

    func save(profileData: ProfileData, completion: ((Bool) -> Void)? ) {
        queue.async { [weak self] in
            guard let dataHandler = self?.dataHandler else { return }
            let isSucceeded = dataHandler.save(profileData: profileData)
            DispatchQueue.main.async {
                completion?(isSucceeded)
            }
        }
    }

    func loadProfileData(completion: ((ProfileData) -> Void)? ) {
        let queue = DispatchQueue.global(qos: .userInitiated)
        queue.async {
            let newData = self.dataHandler.loadProfileData()
            DispatchQueue.main.async {
                completion?(newData)
            }
        }

    }
}

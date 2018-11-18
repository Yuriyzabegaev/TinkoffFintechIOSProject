//
//  ProfileCoreDataManager.swift
//  TinkoffFintechIOSProject
//
//  Created by Юрий Забегаев on 11/11/2018.
//  Copyright © 2018 Юрий Забегаев. All rights reserved.
//

import Foundation

class ProfileCoreDataManager: ProfileDataManagerProtocol {

	var myUserID: String
	private let coreDataManager: CoreDataManagerProtocol

	init(coreDataManager: CoreDataManagerProtocol, myUserID: String) {
		self.coreDataManager = coreDataManager
		self.myUserID = myUserID
	}

	func save(profileData: ProfileData, completion: ((Bool) -> Void)?) {
		guard let saveContext = coreDataManager.saveContext else { return }
		saveContext.perform {
			User.update(in: saveContext,
						userID: self.myUserID,
						name: profileData.name,
						bio: profileData.bio,
						image: profileData.image?.jpegData(compressionQuality: 1),
						coreDataManager: self.coreDataManager)
			completion?(true)
		}
	}

	func loadProfileData(completion: ((ProfileData) -> Void)?) {
		guard let mainContext = coreDataManager.uiContext else { return }
		mainContext.perform {
			guard let profileData = User.withID(userID: self.myUserID,
												coreDataManager: self.coreDataManager) else {
				completion?(ProfileData(name: nil, bio: nil, image: nil))
				return
			}
			let image = (profileData.image != nil) ?  UIImage(data: profileData.image!) : nil
			completion?(ProfileData(name: profileData.name,
									bio: profileData.bio,
									image: image))
		}
	}
}

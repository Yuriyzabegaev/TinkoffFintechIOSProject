//
//  ProfileCoreDataManager.swift
//  TinkoffFintechIOSProject
//
//  Created by Юрий Забегаев on 11/11/2018.
//  Copyright © 2018 Юрий Забегаев. All rights reserved.
//

import Foundation

class ProfileCoreDataManager: ProfileDataManager {

	let myUserID: String

	init(myUserID: String) {
		self.myUserID = myUserID
	}

	func save(profileData: ProfileData, completion: ((Bool) -> Void)?) {
		guard let saveContext = CoreDataManager.shared.coreDataStack.saveContext else { return }
		saveContext.perform {
			User.update(in: saveContext,
						userID: self.myUserID,
						name: profileData.name,
						bio: profileData.bio,
						image: profileData.image?.jpegData(compressionQuality: 1))
			completion?(true)
		}
	}

	func loadProfileData(completion: ((ProfileData) -> Void)?) {
		guard let mainContext = CoreDataManager.shared.coreDataStack.mainContext else { return }
		mainContext.perform {
			guard let profileData = User.withID(userID: self.myUserID) else {
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

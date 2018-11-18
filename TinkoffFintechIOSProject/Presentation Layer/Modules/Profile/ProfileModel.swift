//
//  ProfileModel.swift
//  TinkoffFintechIOSProject
//
//  Created by Юрий Забегаев on 18/11/2018.
//  Copyright © 2018 Юрий Забегаев. All rights reserved.
//

import Foundation

protocol ProfileModelDelegate: class {
	func didChangeData(_ model: ProfileModelProtocol)
}

protocol ProfileModelProtocol: class {
	var delegate: ProfileModelDelegate? {get set}
	var profileData: ProfileData {get set}
	func save(completion: ((Bool) -> Void)? )
	func loadProfileData(completion: (() -> Void)? )
}

class ProfileModel: ProfileModelProtocol {

	weak var delegate: ProfileModelDelegate?

	private let myUserID: String

	var profileData: ProfileData = ProfileData(name: nil, bio: nil, image: nil) {
		didSet {
			delegate?.didChangeData(self)
		}
	}

	private var profileDataManager: ProfileDataManagerProtocol

	init(profileDataManager: ProfileDataManagerProtocol) {
		self.profileDataManager = profileDataManager
		myUserID = profileDataManager.myUserID
	}

	func save(completion: ((Bool) -> Void)?) {
		profileDataManager.save(profileData: profileData,
								completion: { success in
									completion?(success)
		})
	}

	func loadProfileData(completion: (() -> Void)?) {

		profileDataManager.loadProfileData(completion: { [weak self] (data) in
			self?.profileData = data
			completion?()
			})
	}

}

//
//  ProfileDataHandlerProtocol.swift
//  TinkoffFintechIOSProject
//
//  Created by Юрий Забегаев on 18/11/2018.
//  Copyright © 2018 Юрий Забегаев. All rights reserved.
//

import Foundation

protocol ProfileDataHandlerProtocol {
	func getMyDisplayName() -> String
	func save(profileData: ProfileData) -> Bool
	func loadProfileData() -> ProfileData
}

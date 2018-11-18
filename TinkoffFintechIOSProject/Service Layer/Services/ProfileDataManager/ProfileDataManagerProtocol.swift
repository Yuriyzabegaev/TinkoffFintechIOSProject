//
//  ProfileDataManagerProtocol.swift
//  TinkoffFintechIOSProject
//
//  Created by Юрий Забегаев on 21/10/2018.
//  Copyright © 2018 Юрий Забегаев. All rights reserved.
//

import Foundation

protocol ProfileDataManagerProtocol {
	var myUserID: String { get }
    func save(profileData: ProfileData, completion: ((Bool) -> Void)? )
    func loadProfileData(completion: ((ProfileData) -> Void)? )
}

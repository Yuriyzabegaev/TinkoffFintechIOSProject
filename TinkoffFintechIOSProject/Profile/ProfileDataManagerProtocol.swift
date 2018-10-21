//
//  ProfileDataManagerProtocol.swift
//  TinkoffFintechIOSProject
//
//  Created by Юрий Забегаев on 21/10/2018.
//  Copyright © 2018 Юрий Забегаев. All rights reserved.
//

import Foundation


protocol ProfileDataManager {
    func save(profileData: ProfileData, completion: ((Bool) -> ())? )
    func loadProfileData(completion: ((ProfileData) -> ())? )
}

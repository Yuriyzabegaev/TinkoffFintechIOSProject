//
//  SaveProfileDataOperation.swift
//  TinkoffFintechIOSProject
//
//  Created by Юрий Забегаев on 21/10/2018.
//  Copyright © 2018 Юрий Забегаев. All rights reserved.
//

import Foundation


class SaveProfileDataOperation: Operation {
    
    var isSucceeded: Bool?
    
    let profileData: ProfileData
    let completion: ((Bool) -> ())?
    
    let dataHandler = ProfileDataHandler()
    
    
    init(profileData: ProfileData, completion: ((Bool) -> ())? ) {
        self.profileData = profileData
        self.completion = completion
    }
    
    override func main() {
        let isSucceeded = dataHandler.save(profileData: profileData)
        self.isSucceeded = isSucceeded
        completion?(isSucceeded)
    }
}

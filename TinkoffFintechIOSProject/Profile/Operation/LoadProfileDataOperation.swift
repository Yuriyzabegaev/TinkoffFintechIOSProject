//
//  LoadProfileDataOperation.swift
//  TinkoffFintechIOSProject
//
//  Created by Юрий Забегаев on 21/10/2018.
//  Copyright © 2018 Юрий Забегаев. All rights reserved.
//

import Foundation


class LoadProfileDataOperation: Operation {
    
    var profileData: ProfileData!

    let completion: ((ProfileData) -> ())?
        
    let dataHandler = ProfileDataHandler()
        
    init(completion: ((ProfileData) -> ())?) {
        self.completion = completion
    }
    
    override func main() {
        profileData = dataHandler.loadProfileData()
        completion?(profileData)
    }
}
//
//  CoreDataManager.swift
//  TinkoffFintechIOSProject
//
//  Created by Юрий Забегаев on 31/10/2018.
//  Copyright © 2018 Юрий Забегаев. All rights reserved.
//

import Foundation

class CoreDataManager {
    let coreDataStack = CoreDataStack()
}

extension CoreDataManager: ProfileDataManager {

    func save(profileData: ProfileData, completion: ((Bool) -> Void)?) {
        guard let saveContext = coreDataStack.saveContext else { return }

        saveContext.perform { [weak self] in
            Profile.insertOrUpdateProfile(in: saveContext,
                                          name: profileData.name,
                                          bio: profileData.bio,
                                          image: profileData.image?.jpegData(compressionQuality: 1))

            self?.coreDataStack.performSave(context: saveContext, completionHandler: { isSucceeded in
                DispatchQueue.main.async {
                    completion?(isSucceeded)
                }
            })
        }
    }

    func loadProfileData(completion: ((ProfileData) -> Void)?) {
        var profileData: ProfileData?
        if let mainContext = coreDataStack.mainContext {
            if let profile = Profile.getProfilesList(in: mainContext).first {
                let image = (profile.image == nil) ? nil : UIImage(data: profile.image!)
                profileData = ProfileData(name: profile.name,
                                          bio: profile.bio,
                                          image: image)
            }
        }
        completion?(profileData ?? ProfileData(name: nil, bio: nil, image: nil))
    }
}

//
//  Profile.swift
//  TinkoffFintechIOSProject
//
//  Created by Юрий Забегаев on 05/11/2018.
//  Copyright © 2018 Юрий Забегаев. All rights reserved.
//

import Foundation
import CoreData

extension Profile {

    @discardableResult
    static func insertOrUpdateProfile(in context: NSManagedObjectContext,
                                      name: String?,
                                      bio: String?,
                                      image: Data?) -> Profile? {
        let profiles = getProfilesList(in: context)
        assert(profiles.count <= 1, "Now not more than profile can be in database")
        let profile = profiles.first ?? NSEntityDescription.insertNewObject(forEntityName: "Profile", into: context) as! Profile

        profile.name = name
        profile.bio = bio
        profile.image = image

        return profile
    }

    static func getProfilesList(in context: NSManagedObjectContext) -> [Profile] {
        let templateName = "GetAllProfiles"

        guard let model = context.persistentStoreCoordinator?.managedObjectModel else {
            print(#function + " no managed Object Model!")
            return []
        }
        let fetchRequest = model.fetchRequestTemplate(forName: templateName) as! NSFetchRequest<Profile>
        do {
            let fetchResult = try context.fetch(fetchRequest)
            return fetchResult
        } catch {
            print(#function + " " + error.localizedDescription)
            return []
        }
    }
}

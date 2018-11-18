//
//  User+fetches.swift
//  TinkoffFintechIOSProject
//
//  Created by Юрий Забегаев on 10/11/2018.
//  Copyright © 2018 Юрий Забегаев. All rights reserved.
//

import Foundation
import CoreData

extension User {

	static func withID(userID: String, coreDataManager: CoreDataManagerProtocol) -> User? {
		let fetchRequest: NSFetchRequest<User> = coreDataManager.fetchRequest(type: .usersWithID(userID))
		return coreDataManager.performFetch(fetchRequest)?.first
	}

	@discardableResult
	static func update(in context: NSManagedObjectContext,
					   userID: String,
					   name: String?,
					   bio: String?,
					   image: Data?,
					   coreDataManager: CoreDataManagerProtocol) -> User? {
		var result: User?
		context.performAndWait {
			let profile = User.withID(userID: userID, coreDataManager: coreDataManager) ?? NSEntityDescription.insertNewObject(forEntityName: "User", into: context) as! User

			profile.userID = userID
			profile.name = name
			profile.bio = bio
			profile.image = image

			result = profile

			coreDataManager.save()
		}

		return result
	}

}

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

	static func withID(userID: String) -> User? {
		let fetchRequest: NSFetchRequest<User> = CoreDataManager.shared.fetchRequest(type: .usersWithID(userID))
		return CoreDataManager.shared.performFetch(fetchRequest)?.first
	}

	@discardableResult
	static func update(in context: NSManagedObjectContext,
					   userID: String,
					   name: String?,
					   bio: String?,
					   image: Data?) -> User? {
		var result: User?
		context.performAndWait {
			let profile = User.withID(userID: userID) ?? NSEntityDescription.insertNewObject(forEntityName: "User", into: context) as! User

			profile.userID = userID
			profile.name = name
			profile.bio = bio
			profile.image = image

			result = profile

			CoreDataManager.shared.save()
		}

		return result
	}

}

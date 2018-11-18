//
//  CoreDataManager.swift
//  TinkoffFintechIOSProject
//
//  Created by Юрий Забегаев on 31/10/2018.
//  Copyright © 2018 Юрий Забегаев. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager: CoreDataManagerProtocol {

	static let shared: CoreDataManager = CoreDataManager()

	var uiContext: NSManagedObjectContext? {
		return coreDataStack.mainContext
	}

	var saveContext: NSManagedObjectContext? {
		return coreDataStack.saveContext
	}

	private var coreDataStack: CoreDataStackProtocol!

	private init() {}

	func setUpDependencies(coreDataStack: CoreDataStackProtocol) {
		self.coreDataStack = coreDataStack
	}

	func fetchRequest<T>(type: FetchRequestType) -> NSFetchRequest<T> where T: NSManagedObject {
		var fetchRequest: NSFetchRequest<T>?
		switch type {
		case .conversationsWithID(let opponentID),
			 .messagesFromConversationWithID(let opponentID):
			let arguments = ["OPPONENT_ID": opponentID]
			fetchRequest = coreDataStack.managedObjectModel?.fetchRequestFromTemplate(withName: type.rawValue,
				substitutionVariables: arguments)
				as? NSFetchRequest<T>
		case .usersWithID(let userID):
			let arguments = ["userID": userID]
			fetchRequest = coreDataStack.managedObjectModel?.fetchRequestFromTemplate(withName: type.rawValue,
																					  substitutionVariables: arguments)
				as? NSFetchRequest<T>
		default:
			fetchRequest = coreDataStack.managedObjectModel?.fetchRequestFromTemplate(withName: type.rawValue,
																					  substitutionVariables: [:])
				as? NSFetchRequest<T>
		}

		guard fetchRequest != nil else {
			fatalError("No Fetch Request Template was found with name: \(type.rawValue)")
		}

		fetchRequest?.returnsObjectsAsFaults = false
		return fetchRequest!
	}

	func performFetch<T>(_ fetchRequest: NSFetchRequest<T>) -> [T]? where T: NSManagedObject {

		guard let saveContext = coreDataStack.saveContext else {
			return nil
		}

		return try? saveContext.fetch(fetchRequest)
	}

	func add<T>(entity: EntityType) -> T? where T: NSManagedObject {
		guard let saveContext = coreDataStack.saveContext else { return nil }
		return NSEntityDescription.insertNewObject(forEntityName: entity.rawValue, into: saveContext) as? T
	}

	func save(completion: ((Bool) -> Void)? = nil) {
		guard let saveContext = coreDataStack.saveContext else { return }
		coreDataStack.performSave(context: saveContext, completionHandler: { isSucceeded in
			completion?(isSucceeded)
		})
	}

	func delete<T>(_ element: T) where T: NSManagedObject {
		guard let mainContext = coreDataStack.mainContext else {
			return
		}

		mainContext.performAndWait {

			if let conversation = element as? Conversation {
				if let opponent = conversation.opponent {
					mainContext.delete(opponent)
				}
				if let lastMessage = conversation.lastMessage {
					mainContext.delete(lastMessage)
				}
				if let messages = conversation.messages {
					for object in messages {
						if let message = object as? Message {
							mainContext.delete(message)
						}
					}
				}
				mainContext.delete(conversation)
			} else {
				mainContext.delete(element)
			}
			coreDataStack.performSave(context: mainContext)
		}

	}

	// MARK: - NSFetchedResultsController
	func setupFRC<T>(_ fetchRequest: NSFetchRequest<T>,
					 frcManager: FRCManagerProtocol,
					 sectionNameKeyPath: String? = nil) -> NSFetchedResultsController<T> where T: NSManagedObject {
		guard let mainContext = coreDataStack.mainContext else {
			fatalError("No main context")
		}
		let fetchedResultsController = NSFetchedResultsController<T>(fetchRequest: fetchRequest,
																	 managedObjectContext: mainContext,
																	 sectionNameKeyPath: sectionNameKeyPath,
																	 cacheName: nil)
		fetchedResultsController.delegate = frcManager

		return fetchedResultsController
	}

}

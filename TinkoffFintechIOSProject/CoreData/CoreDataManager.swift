//
//  CoreDataManager.swift
//  TinkoffFintechIOSProject
//
//  Created by Юрий Забегаев on 31/10/2018.
//  Copyright © 2018 Юрий Забегаев. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {

	enum FetchRequestType: RawRepresentable {
		typealias RawValue = String

		case conversationsOnline
		case usersWithID(String)
		case usersOnline
		case conversationsWithID(String)
		case messagesFromConversationWithID(String)

		public init?(rawValue: RawValue) {
			return nil
		}

		public var rawValue: RawValue {
			switch self {
			case .conversationsOnline:
				return "FetchConversationsOnline"
			case .usersWithID:
				return "FetchUsersWithID"
			case .conversationsWithID:
				return "FetchConversationsWithID"
			case .messagesFromConversationWithID:
				return "FetchMessagesFromConversationWithID"
			case .usersOnline:
				return "FetchUsersOnline"
			}
		}
	}

	enum EntityType: String {
		case conversation = "Conversation"
		case message = "Message"
		case user = "User"
	}

	static let shared: CoreDataManager = CoreDataManager()

	let coreDataStack = CoreDataStack()

	private init() {}

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
//		var result: [T]?
//		saveContext.performAndWait {
//			do {
//				result = try fetchRequest.execute()
//			} catch {
//				print(error.localizedDescription)
//			}
//
//		}
//		return result
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
					 frcManager: FRCManager,
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

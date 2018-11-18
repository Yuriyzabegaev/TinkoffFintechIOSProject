//
//  CoreDataManagerProtocol.swift
//  TinkoffFintechIOSProject
//
//  Created by Юрий Забегаев on 18/11/2018.
//  Copyright © 2018 Юрий Забегаев. All rights reserved.
//

import Foundation
import CoreData

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

protocol CoreDataManagerProtocol {
	func setUpDependencies(coreDataStack: CoreDataStackProtocol)

	var saveContext: NSManagedObjectContext? { get }
	var uiContext: NSManagedObjectContext? { get }
	func fetchRequest<T>(type: FetchRequestType) -> NSFetchRequest<T> where T: NSManagedObject
	func performFetch<T>(_ fetchRequest: NSFetchRequest<T>) -> [T]? where T: NSManagedObject
	func add<T>(entity: EntityType) -> T? where T: NSManagedObject
	func save(completion: ((Bool) -> Void)?)
	func delete<T>(_ element: T) where T: NSManagedObject

	func setupFRC<T>(_ fetchRequest: NSFetchRequest<T>,
					 frcManager: FRCManagerProtocol,
					 sectionNameKeyPath: String?) -> NSFetchedResultsController<T> where T: NSManagedObject
}

extension CoreDataManagerProtocol {
	func setupFRC<T>(_ fetchRequest: NSFetchRequest<T>,
					 frcManager: FRCManagerProtocol) -> NSFetchedResultsController<T> where T: NSManagedObject {
		return self.setupFRC(fetchRequest, frcManager: frcManager, sectionNameKeyPath: nil)
	}

	func save() {
		self.save(completion: nil)
	}
}

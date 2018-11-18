//
//  ConversationsListModel.swift
//  TinkoffFintechIOSProject
//
//  Created by Юрий Забегаев on 18/11/2018.
//  Copyright © 2018 Юрий Забегаев. All rights reserved.
//

import Foundation
import CoreData

protocol ConversationsListModelDelegate: class {
	func didUpdateData(_ model: ConversationsListModelProtocol)
	func didCatchError(_ model: ConversationsListModelProtocol, error: Error)
}

protocol ConversationsListModelProtocol {
	var displayName: String {get set}
	var delegate: ConversationsListModelDelegate? {get set}
	var frcManagerDelegate: FRCManagerDelegate? {get set}
	var numberOfSections: Int {get}
	func numberOfRowsInSection(_ section: Int) -> Int
	func conversation(at index: IndexPath) -> Conversation?
	func deleteConversation(at index: IndexPath)
}

class ConversationsListModel: ConversationsListModelProtocol {

	weak var delegate: ConversationsListModelDelegate?

	private var fetchedResultsController: NSFetchedResultsController<Conversation>
	private var coreDataManager: CoreDataManagerProtocol
	private var frcManager: FRCManagerProtocol

	private var communicatorManager: CommunicatorManagerProtocol

	init(coreDataManager: CoreDataManagerProtocol,
		 frcManager: FRCManagerProtocol,
		 communicatorManager: CommunicatorManagerProtocol) {

		self.coreDataManager = coreDataManager

		self.frcManager = frcManager

		let onlineFetchRequest: NSFetchRequest<Conversation> = Conversation.fetchRequest()
		onlineFetchRequest.sortDescriptors = [
			NSSortDescriptor(key: "opponent.isOnline", ascending: false),
			NSSortDescriptor(key: "lastMessage.timeStamp", ascending: false)
		]
		self.fetchedResultsController =  coreDataManager.setupFRC(onlineFetchRequest,
										frcManager: frcManager)

		self.communicatorManager = communicatorManager
		self.communicatorManager.delegate = self

		do {
			try fetchedResultsController.performFetch()
		} catch {
			delegate?.didCatchError(self, error: error)
		}
	}

	var frcManagerDelegate: FRCManagerDelegate? {
		get {
			return frcManager.delegate
		}
		set {
			frcManager.delegate = frcManagerDelegate
		}
	}

	var displayName: String {
		get {
			return communicatorManager.visibleName
		}
		set {
			communicatorManager.visibleName = displayName
		}
	}

	var numberOfSections: Int {
		return fetchedResultsController.sections?.count ?? 1
	}

	func numberOfRowsInSection(_ section: Int) -> Int {
		guard let sections = fetchedResultsController.sections else {
			return 0
		}

		return sections[section].numberOfObjects
	}

	func conversation(at index: IndexPath) -> Conversation? {
		return fetchedResultsController.object(at: index)
	}

	func deleteConversation(at index: IndexPath) {
		guard let conversation = conversation(at: index) else { return }
		coreDataManager.delete(conversation)
		coreDataManager.save()

		delegate?.didUpdateData(self)
	}

}

extension ConversationsListModel: CommunicatorManagerDelegate {
	func didUpdateData() {
		delegate?.didUpdateData(self)
	}

	func didCatchError(error: Error) {
		delegate?.didCatchError(self, error: error)
	}

}

//
//  ConversationModel.swift
//  TinkoffFintechIOSProject
//
//  Created by Юрий Забегаев on 18/11/2018.
//  Copyright © 2018 Юрий Забегаев. All rights reserved.
//

import Foundation
import CoreData

protocol ConversationModelDelegate: class {
	func didUpdateData(_ conversationModel: ConversationModelProtocol)
	func didCatchError(_ conversationModel: ConversationModelProtocol, error: Error)
}

protocol ConversationModelProtocol {
	func setUpProperties(opponentID: String, frcManagerDelegate: FRCManagerDelegate)

	var delegate: ConversationModelDelegate? {get set}
	var frcManagerDelegate: FRCManagerDelegate? {get set}
	var opponentID: String {get}

	func sendMessage(text: String)

	var numberOfSections: Int {get}
	func numberOfRowsInSection(_ section: Int) -> Int
	func message(at index: IndexPath) -> Message?

	func deleteMessage(at index: IndexPath)
}

class ConversationModel: ConversationModelProtocol {

	weak var delegate: ConversationModelDelegate?
	weak var frcManagerDelegate: FRCManagerDelegate? {
		get {
			return frcManager.delegate
		}
		set {
			frcManager.delegate = newValue
		}
	}

	private var fetchedResultsController: NSFetchedResultsController<Message>!
	private(set) var opponentID: String = ""

	// MARK: - Dependencies
	private var coreDataManager: CoreDataManagerProtocol
	private var frcManager: FRCManagerProtocol

	private var communicatorManager: CommunicatorManagerProtocol

	init(coreDataManager: CoreDataManagerProtocol,
		 frcManager: FRCManagerProtocol,
		 communicatorManager: CommunicatorManagerProtocol) {
		self.communicatorManager = communicatorManager
		self.coreDataManager = coreDataManager
		self.frcManager = frcManager
	}

	func setUpProperties(opponentID: String, frcManagerDelegate: FRCManagerDelegate) {
		let fetchRequest: NSFetchRequest<Message> = coreDataManager.fetchRequest(type: .messagesFromConversationWithID(opponentID))
		fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timeStamp", ascending: false)]

		self.fetchedResultsController = coreDataManager.setupFRC(fetchRequest, frcManager: frcManager)
		frcManager.delegate = frcManagerDelegate
		communicatorManager.delegate = self

		self.opponentID = opponentID

		do {
			try fetchedResultsController.performFetch()
		} catch {
			delegate?.didCatchError(self, error: error)
		}
	}

	func sendMessage(text: String) {
		communicatorManager.sendMessage(text: text, to: opponentID)
	}

	var numberOfSections: Int {
		return fetchedResultsController.sections?.count ?? 1
	}

	func numberOfRowsInSection(_ section: Int) -> Int {
		guard let sections = fetchedResultsController?.sections else {
			return 0
		}

		return sections[section].numberOfObjects
	}

	func message(at index: IndexPath) -> Message? {
		return fetchedResultsController.object(at: index)
	}

	func deleteMessage(at index: IndexPath) {
		guard let message: Message = message(at: index) else { return }
		coreDataManager.delete(message)
		coreDataManager.save()

		delegate?.didUpdateData(self)
	}

}

extension ConversationModel: CommunicatorManagerDelegate {
	func didUpdateData() {
		delegate?.didUpdateData(self)
	}

	func didCatchError(error: Error) {
		delegate?.didCatchError(self, error: error)
	}
}

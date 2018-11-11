//
//  Conversation.swift
//  TinkoffFintechIOSProject
//
//  Created by Юрий Забегаев on 10/11/2018.
//  Copyright © 2018 Юрий Забегаев. All rights reserved.
//

import Foundation
import CoreData

extension Conversation {

	static func with(opponentID: String) -> Conversation? {
		let fetchRequest: NSFetchRequest<Conversation> = CoreDataManager.shared.fetchRequest(type: .conversationsWithID(opponentID))
		return CoreDataManager.shared.performFetch(fetchRequest)?.first
	}

	func addMessageAndSetLastMessage(_ message: Message) {
		self.addToMessages(message)
		self.lastMessage = message
	}

}

//
//  CommunicatorManager.swift
//  TinkoffFintechIOSProject
//
//  Created by Юрий Забегаев on 27/10/2018.
//  Copyright © 2018 Юрий Забегаев. All rights reserved.
//

import Foundation

class CommunicatorManager {

    enum MultipeerCommunicatorError: Error {
        case sessionNotFoundError(String)
        case unableToSendMessage(Error)
    }

    // MARK: - Static Properties

    static var visibleName: String = UIDevice.current.name {
        didSet {
            shared.communicator.visibleUserName = CommunicatorManager.visibleName
        }
    }

    static private(set) var shared = CommunicatorManager()

    // MARK: - Properties

	var myUserID: String {
		return communicator.myUserID
	}

    private let communicator: Communicator

    weak var delegate: CommunicatorManagerDelegate?

    // MARK: - Initialization

    private init() {
        communicator = MultipeerCommunicator(username: CommunicatorManager.visibleName)
        communicator.delegate = self
    }

    // MARK: - Public methods

    func sendMessage(text: String, to userId: String) {

        func completionHandler(success: Bool, error: Error?) {
            if !success,
                let error = error {
                self.delegate?.didCatchError(error: error)
                return
            }

			guard let conversation = Conversation.with(opponentID: userId),
				let message: Message = CoreDataManager.shared.add(entity: .message) else { return }
			message.configure(text: text,
							  isIncoming: false)

			conversation.addMessageAndSetLastMessage(message)

			CoreDataManager.shared.save { [weak self] isSucceeded in
				if isSucceeded {
					self?.delegate?.didUpdateData()
				}
			}
        }

        communicator.sendMessage(string: text, to: userId, completionHandler: completionHandler)
    }
}

extension CommunicatorManager: CommunicatorDelegate {

    func didFoundUser(userId: String, userName: String?) {
		var user = User.withID(userID: userId)
		guard user == nil else {
			user?.isOnline = true
			user?.name = userName
			CoreDataManager.shared.save { [weak self] isSucceeded in
				if isSucceeded {
					self?.delegate?.didUpdateData()
				}
			}
			return
		}

		// new user
		user = CoreDataManager.shared.add(entity: .user)
		guard user != nil else { return }

		guard let conversation: Conversation = CoreDataManager.shared.add(entity: .conversation) else { return }
		conversation.opponent = user
		user?.isOnline = true
		user?.userID = userId
		user?.name = userName

		saveData()
    }

    func didLostUser(userId: String) {
		guard let user = User.withID(userID: userId) else { return }
		user.isOnline = false

		saveData()
    }

    func failedToStartBrowsingForUsers(error: Error) {
        delegate?.didCatchError(error: error)
    }

    func failedToStartAdvertising(error: Error) {
        delegate?.didCatchError(error: error)
    }

    func didReceiveMessage(text: String, fromUser sender: String, toUser receiver: String) {
		guard let newMessage: Message = CoreDataManager.shared.add(entity: .message),
			let conversation = Conversation.with(opponentID: sender) else { return }
		newMessage.configure(text: text,
							 isIncoming: true)
		conversation.addMessageAndSetLastMessage(newMessage)

		saveData()
    }

	private func saveData() {
		CoreDataManager.shared.save { [weak self] isSucceeded in
			if isSucceeded {
				self?.delegate?.didUpdateData()
			}
		}
	}

}

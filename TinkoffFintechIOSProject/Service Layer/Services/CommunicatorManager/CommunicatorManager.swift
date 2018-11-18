//
//  CommunicatorManager.swift
//  TinkoffFintechIOSProject
//
//  Created by Юрий Забегаев on 27/10/2018.
//  Copyright © 2018 Юрий Забегаев. All rights reserved.
//

import Foundation

class CommunicatorManager: CommunicatorManagerProtocol {

    enum MultipeerCommunicatorError: Error {
        case sessionNotFoundError(String)
        case unableToSendMessage(Error)
    }

	var visibleName: String = UIDevice.current.name {
        didSet {
            communicator.visibleUserName = visibleName
        }
    }

    static private(set) var shared = CommunicatorManager()

    // MARK: - Properties

	var myUserID: String {
		return communicator.myUserID
	}

    weak var delegate: CommunicatorManagerDelegate?

    // MARK: - Dependencies
	private var communicator: CommunicatorProtocol!
	private var coreDataManager: CoreDataManagerProtocol!

	func setUpDependencies(coreDataManager: CoreDataManagerProtocol,
						   communicator: CommunicatorProtocol,
						   userName: String) {
		self.coreDataManager = coreDataManager
		self.communicator = communicator
		self.communicator.delegate = self
		self.communicator.setUpPropertiesAndRun(username: userName)
	}

    // MARK: - Public methods

    func sendMessage(text: String, to userId: String) {

        func completionHandler(success: Bool, error: Error?) {
            if !success,
                let error = error {
                self.delegate?.didCatchError(error: error)
                return
            }

			guard let conversation = Conversation.with(opponentID: userId,
													   coreDataManager: coreDataManager),
				let message: Message = coreDataManager.add(entity: .message) else { return }
			message.configure(text: text,
							  isIncoming: false)

			conversation.addMessageAndSetLastMessage(message)

			coreDataManager.save { [weak self] isSucceeded in
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
		var user = User.withID(userID: userId,
							   coreDataManager: coreDataManager)
		guard user == nil else {
			user?.isOnline = true
			user?.name = userName
			coreDataManager.save { [weak self] isSucceeded in
				if isSucceeded {
					self?.delegate?.didUpdateData()
				}
			}
			return
		}

		// new user
		user = coreDataManager.add(entity: .user)
		guard user != nil else { return }

		guard let conversation: Conversation = coreDataManager.add(entity: .conversation) else { return }
		conversation.opponent = user
		user?.isOnline = true
		user?.userID = userId
		user?.name = userName

		saveData()
    }

    func didLostUser(userId: String) {
		guard let user = User.withID(userID: userId,
									 coreDataManager: coreDataManager) else { return }
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
		guard let newMessage: Message = coreDataManager.add(entity: .message),
			let conversation = Conversation.with(opponentID: sender,
												 coreDataManager: coreDataManager) else { return }
		newMessage.configure(text: text,
							 isIncoming: true)
		conversation.addMessageAndSetLastMessage(newMessage)

		saveData()
    }

	private func saveData() {
		coreDataManager.save { [weak self] isSucceeded in
			if isSucceeded {
				self?.delegate?.didUpdateData()
			}
		}
	}

}

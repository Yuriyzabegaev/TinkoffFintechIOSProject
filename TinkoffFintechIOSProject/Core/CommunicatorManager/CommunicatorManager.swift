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
    
    //MARK: - Static Properties
    
    static var deviceVisibleName: String = UIDevice.current.name {
        didSet {
            shared.communicator.visibleUserName = CommunicatorManager.deviceVisibleName
        }
    }
    
    // singleton
    static private(set) var shared = CommunicatorManager()
    
    //MARK: - Properties
    
    private let communicator: Communicator
    private(set) var conversations: [ConversationModel] = []
    
    var conversationsListDelegate: CommunicatorManagerConversationsListDelegate?
    var conversationDelegate: CommunicatorManagerConversationDelegate?
    
    //MARK: - Initialization
    
    private init() {
        communicator = MultipeerCommunicator(username: CommunicatorManager.deviceVisibleName)
        communicator.delegate = self
    }
    
    //MARK: - Public methods

    func sendMessage(text: String, to userId: String) {
        
        func completionHandler(success: Bool, error: Error?) {
            if !success,
                let error = error {
                self.conversationDelegate?.didCatchError(error: error)
                self.conversationsListDelegate?.didCatchError(error: error)
                return
            }
            
            guard let conversation = self.conversations.first(where: { conversation in
                conversation.userId == userId
            }) else { return }
            
            conversation.add(message: MessageModel(isIncoming: false,
                                                   text: text,
                                                   senderId: communicator.myUserID,
                                                   receiverId: userId))
            self.conversationDelegate?.didReloadMessages(user: userId)
        }
        
        communicator.sendMessage(string: text, to: userId, completionHandler: completionHandler)
    }
    
    func sortMessages() {
        conversations.sort(by: {left, right in
            if left.chatMessages.isEmpty || right.chatMessages.isEmpty {
                if left.chatMessages.isEmpty && right.chatMessages.isEmpty,
                    let leftUsername = left.username,
                    let rightUsername = right.username {
                    return leftUsername < rightUsername
                }
                return false
            }
            return left.chatMessages.last!.timestamp > right.chatMessages.last!.timestamp
        })
    }
}


extension CommunicatorManager: CommunicatorDelegate {
    
    func didFoundUser(userId: String, userName: String?) {
        if conversations.contains(where: { $0.userId == userId }) {
            return
        }
        conversations += [ConversationModel(userId: userId, username: userName)]
        conversationsListDelegate?.didReloadConversationsList()
    }
    
    func didLostUser(userId: String) {
        let indexToRemove = conversations.firstIndex { conversation in
            conversation.userId == userId
        }
        if let indexToRemove = indexToRemove {
            conversations.remove(at: indexToRemove)
            conversationDelegate?.didAbandonConversation(user: userId)
            conversationsListDelegate?.didReloadConversationsList()
        }
    }
    
    func failedToStartBrowsingForUsers(error: Error) {
        conversationsListDelegate?.didCatchError(error: error)
        conversationDelegate?.didCatchError(error: error)
    }
    
    func failedToStartAdvertising(error: Error) {
        conversationsListDelegate?.didCatchError(error: error)
        conversationDelegate?.didCatchError(error: error)
    }
    
    func didReceiveMessage(text: String, fromUser sender: String, toUser receiver: String) {        
        let newMessage = MessageModel(isIncoming: true,
                                      text: text,
                                      senderId: sender,
                                      receiverId: receiver)
        guard let conversation = conversations.filter({ conversation in
            conversation.userId == sender
        }).first else { return }
        conversation.add(message: newMessage)
        
        // TODO: make async
        
        conversationDelegate?.didReloadMessages(user: sender)
        conversationsListDelegate?.didReloadConversationsList()
    }

}

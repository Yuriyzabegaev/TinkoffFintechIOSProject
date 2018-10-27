//
//  CommunicatorManager.swift
//  TinkoffFintechIOSProject
//
//  Created by Юрий Забегаев on 27/10/2018.
//  Copyright © 2018 Юрий Забегаев. All rights reserved.
//

import Foundation

struct MessageModel: Hashable {
    let isIncoming: Bool
    let text: String
    let senderId: String
    let receiverId: String
    
    let timestamp = Date()
    
    private(set) var isUnread: Bool
    
    init(isIncoming: Bool, text: String, senderId: String, receiverId: String) {
        self.isIncoming = isIncoming
        self.text = text
        self.senderId = senderId
        self.receiverId = receiverId
        
        isUnread = true
    }
    
    mutating func readMessage() {
        isUnread = true
    }
}


class ConversationModel {
    
    let userId: String
    var username: String?
    
    private(set) var chatMessages: [MessageModel] = []
    
    init(userId: String, username: String?) {
        self.userId = userId
        self.username = username
    }
    
    func add(message: MessageModel) {
        chatMessages += [message]
    }
}


class CommunicatorManager {
    static var deviceVisibleName: String = UIDevice.current.name {
        didSet {
            if let standard = _standard {
                standard.communicator.visibleUserName = CommunicatorManager.deviceVisibleName
            }
        }
    }
    static var standard: CommunicatorManager {
        if _standard == nil {
            _standard = CommunicatorManager()
        }
        return CommunicatorManager._standard!
    }
    
    private static var _standard: CommunicatorManager?
    
    private let communicator: Communicator
    private(set) var conversations: [ConversationModel] = []
    
    var conversationsListDelegate: CommunicatorManagerConversationsListDelegate?
    var conversationDelegate: CommunicatorManagerConversationDelegate?
    
    private init() {
        communicator = MultipeerCommunicator(username: CommunicatorManager.deviceVisibleName)
        communicator.delegate = self
    }
    
    func sendMessage(text: String, to userId: String) {
        
        func completionHandler(success: Bool, error: Error?) {
            if !success,
                let error = error {
                print(error.localizedDescription)
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
        print(#function + error.localizedDescription)
    }
    
    func failedToStartAdvertising(error: Error) {
        print(#function + error.localizedDescription)
    }
    
    func didReceiveMessage(text: String, fromUser sender: String, toUser receiver: String) {        
        let newMessage = MessageModel(isIncoming: true,
                                      text: text,
                                      senderId: sender,
                                      receiverId: receiver)
        guard let conversation = conversations.filter({ conversation in
            conversation.userId == sender
        }).first else { fatalError("something strange occurred..") }
        conversation.add(message: newMessage)
        
        //        TODO: make async
        
        conversations.sort(by: {left, right in
            if left.chatMessages.isEmpty || right.chatMessages.isEmpty {
                if left.chatMessages.isEmpty && right.chatMessages.isEmpty,
                    let leftUsername = left.username,
                    let rightUsername = right.username {
                    return leftUsername < rightUsername
                }
                return false
            }
            return left.chatMessages.last!.timestamp < right.chatMessages.last!.timestamp
        })

        conversationDelegate?.didReloadMessages(user: sender)
        conversationsListDelegate?.didReloadConversationsList()
    }

}


protocol CommunicatorManagerConversationsListDelegate {
    func didReloadConversationsList()
}

protocol CommunicatorManagerConversationDelegate {
    func didReloadMessages(user: String)
    func didAbandonConversation(user: String) // called if opponent left conversation
}

struct NotificationTypes {
    static let conversationsListDidReloadData = Notification.Name("ConversationsListDidReloadData")
    static let conversationListDidSortData = Notification.Name("ConversationsListDidSortData")
    
    static let conversationDidTurnSendOff = Notification.Name("ConversationDidTurnSendOff")
    static let conversationDidReloadData = Notification.Name("ConversationDidReloadData")
}

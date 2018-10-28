//
//  MessageModel.swift
//  TinkoffFintechIOSProject
//
//  Created by Юрий Забегаев on 28/10/2018.
//  Copyright © 2018 Юрий Забегаев. All rights reserved.
//

import Foundation


class MessageModel {
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
    
    func readMessage() {
        isUnread = false
    }
}

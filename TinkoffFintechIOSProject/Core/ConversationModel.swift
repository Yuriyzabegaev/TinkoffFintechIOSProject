//
//  ConversationModel.swift
//  TinkoffFintechIOSProject
//
//  Created by Юрий Забегаев on 28/10/2018.
//  Copyright © 2018 Юрий Забегаев. All rights reserved.
//

import Foundation

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

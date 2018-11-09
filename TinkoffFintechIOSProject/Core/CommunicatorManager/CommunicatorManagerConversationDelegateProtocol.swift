//
//  CommunicatorManagerConversationDelegate.swift
//  TinkoffFintechIOSProject
//
//  Created by Юрий Забегаев on 30/10/2018.
//  Copyright © 2018 Юрий Забегаев. All rights reserved.
//

import Foundation

protocol CommunicatorManagerConversationDelegate: class {
    func didReloadMessages(user: String)
    func didAbandonConversation(user: String) // called if opponent left conversation
    func didCatchError(error: Error)
}

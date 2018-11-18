//
//  CommunicatorManagerConversationsListDelegateProtocol.swift
//  TinkoffFintechIOSProject
//
//  Created by Юрий Забегаев on 30/10/2018.
//  Copyright © 2018 Юрий Забегаев. All rights reserved.
//

import Foundation

protocol CommunicatorManagerDelegate: class {
    func didUpdateData()
    func didCatchError(error: Error)
}

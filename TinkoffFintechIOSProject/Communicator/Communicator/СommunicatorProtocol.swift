//
//  СommunicatorProtocol.swift
//  TinkoffFintechIOSProject
//
//  Created by Юрий Забегаев on 30/10/2018.
//  Copyright © 2018 Юрий Забегаев. All rights reserved.
//

import Foundation

protocol Communicator: class {
    func sendMessage(string: String, to userId: String, completionHandler: ((_ success: Bool, _ error: Error?) ->
		Void)?)
    var delegate: CommunicatorDelegate? {get set}
    var online: Bool {get set}

    var myUserID: String {get}
    var visibleUserName: String {get set}
}

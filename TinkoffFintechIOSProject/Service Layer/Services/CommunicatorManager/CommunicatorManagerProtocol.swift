//
//  CommunicatorManagerDelegate.swift
//  TinkoffFintechIOSProject
//
//  Created by Юрий Забегаев on 17/11/2018.
//  Copyright © 2018 Юрий Забегаев. All rights reserved.
//

import Foundation

protocol CommunicatorManagerProtocol {
	func setUpDependencies(coreDataManager: CoreDataManagerProtocol,
						   communicator: CommunicatorProtocol,
						   userName: String)

	var delegate: CommunicatorManagerDelegate? {get set}
	var visibleName: String {get set}
	func sendMessage(text: String, to userId: String)
}

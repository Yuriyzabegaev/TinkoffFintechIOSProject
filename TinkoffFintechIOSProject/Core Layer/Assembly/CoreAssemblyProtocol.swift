//
//  CoreAssemblyProtocol.swift
//  TinkoffFintechIOSProject
//
//  Created by Юрий Забегаев on 17/11/2018.
//  Copyright © 2018 Юрий Забегаев. All rights reserved.
//

import Foundation

protocol CoreAssemblyProtocol {
	var myUserID: String { get }
	var coreDataStack: CoreDataStackProtocol { get }
	var communicator: CommunicatorProtocol { get }
	var profileDataHandler: ProfileDataHandlerProtocol { get }
	var networkRequestManager: RequestManagerProtocol { get }
}

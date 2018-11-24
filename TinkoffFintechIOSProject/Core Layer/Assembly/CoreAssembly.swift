//
//  CoreAssembly.swift
//  TinkoffFintechIOSProject
//
//  Created by Юрий Забегаев on 17/11/2018.
//  Copyright © 2018 Юрий Забегаев. All rights reserved.
//

import Foundation

class CoreAssembly: CoreAssemblyProtocol {
	var communicator: CommunicatorProtocol {
		return MultipeerCommunicator()
	}

	var coreDataStack: CoreDataStackProtocol {
		return CoreDataStack()
	}

	var myUserID: String {
		return UIDevice.current.identifierForVendor!.uuidString
	}

	var profileDataHandler: ProfileDataHandlerProtocol {
		return ProfileDataHandler()
	}

	var networkRequestManager: RequestManagerProtocol {
		return RequestManager()
	}

}

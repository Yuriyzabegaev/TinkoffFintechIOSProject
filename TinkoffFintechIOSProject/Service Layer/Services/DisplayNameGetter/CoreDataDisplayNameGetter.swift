//
//  CoreDataDisplayNameGetter.swift
//  TinkoffFintechIOSProject
//
//  Created by Юрий Забегаев on 18/11/2018.
//  Copyright © 2018 Юрий Забегаев. All rights reserved.
//

import Foundation

class CoreDataDisplayNameGetter: DisplayNameGetterProtocol {

	let myUserID: String
	let coreDataManager: CoreDataManagerProtocol

	init(coreDataManager: CoreDataManagerProtocol, myUserID: String) {
		self.coreDataManager = coreDataManager
		self.myUserID = myUserID
	}
	func getMyDisplayName() -> String {
		let appUser = User.withID(userID: myUserID, coreDataManager: coreDataManager)
		return appUser?.name ?? UIDevice.current.name
	}

}

//
//  ServiceAssembly.swift
//  TinkoffFintechIOSProject
//
//  Created by Юрий Забегаев on 17/11/2018.
//  Copyright © 2018 Юрий Забегаев. All rights reserved.
//

import Foundation

class ServicesAssembly: ServicesAssemblyProtocol {

	private let coreAssembly: CoreAssemblyProtocol

	let communicationManager: CommunicatorManagerProtocol
	let coreDataManager: CoreDataManagerProtocol

	init(coreAssembly: CoreAssemblyProtocol) {
		self.coreAssembly = coreAssembly

		coreDataManager = CoreDataManager.shared
		coreDataManager.setUpDependencies(coreDataStack: coreAssembly.coreDataStack)

		communicationManager = CommunicatorManager.shared
		communicationManager.setUpDependencies(coreDataManager: coreDataManager,
												communicator: coreAssembly.communicator,
												userName: displayNameGetter.getMyDisplayName())
	}

	var profileDataManager: ProfileDataManagerProtocol {
		return ProfileCoreDataManager(coreDataManager: coreDataManager, myUserID: coreAssembly.myUserID)
	}

	var frcManager: FRCManagerProtocol {
		return FRCManager()
	}

	var displayNameGetter: DisplayNameGetterProtocol {
		return CoreDataDisplayNameGetter(coreDataManager: coreDataManager,
										 myUserID: coreAssembly.myUserID)
	}

	var pictureDataSource: PicturesDataSourceProtocol {
		return PicturesPixabayNetworkService(requestManager: coreAssembly.networkRequestManager,
											 numberOfPictures: 150)
	}

}

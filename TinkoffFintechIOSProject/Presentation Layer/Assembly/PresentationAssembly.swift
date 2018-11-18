//
//  PresentationAssembly.swift
//  TinkoffFintechIOSProject
//
//  Created by Юрий Забегаев on 17/11/2018.
//  Copyright © 2018 Юрий Забегаев. All rights reserved.
//

import Foundation
import CoreData

class PresentationAssembly: PresentationAssemblyProtocol {

	private let serviceAssembly: ServicesAssemblyProtocol

	init(serviceAssembly: ServicesAssemblyProtocol) {
		self.serviceAssembly = serviceAssembly
	}

	func rootViewController() -> UIViewController? {
		let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
		guard let rootViewController = mainStoryboard.instantiateInitialViewController() as? UINavigationController,
			let conversationsListViewController = rootViewController.viewControllers.first as? ConversationsListViewController else {
				return nil
		}
		let communicationManager = serviceAssembly.communicationManager
		let frcManager = serviceAssembly.frcManager
		let displayName = serviceAssembly.displayNameGetter.getMyDisplayName()
		let coreDataManager = serviceAssembly.coreDataManager

		conversationsListViewController
			.setUpDependencies(presentationAssembly: self,
							   conversationsListModel: ConversationsListModel(coreDataManager: coreDataManager,
																	   frcManager: frcManager,
																	   communicatorManager: communicationManager),
							   myDisplayName: displayName)

		return rootViewController
	}

	func setUp(profileViewController: ProfileViewController) {
		let profileDataManager = serviceAssembly.profileDataManager

		profileViewController.setUpDependencies(model: ProfileModel(profileDataManager: profileDataManager))
	}

	func setUp(conversationViewController: ConversationViewController) {
		let frcManager = serviceAssembly.frcManager
		let communicationManager = serviceAssembly.communicationManager
		let coreDataManager = serviceAssembly.coreDataManager

		conversationViewController
			.setUpDependencies(conversationModel: ConversationModel(coreDataManager: coreDataManager,
																	frcManager: frcManager,
																	communicatorManager: communicationManager))
	}

}

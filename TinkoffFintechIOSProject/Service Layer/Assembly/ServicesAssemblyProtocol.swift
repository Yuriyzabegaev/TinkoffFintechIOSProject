//
//  ServiceAssemblyProtocol.swift
//  TinkoffFintechIOSProject
//
//  Created by Юрий Забегаев on 17/11/2018.
//  Copyright © 2018 Юрий Забегаев. All rights reserved.
//

import Foundation

protocol ServicesAssemblyProtocol {
	var profileDataManager: ProfileDataManagerProtocol { get }
	var frcManager: FRCManagerProtocol { get }
	var communicationManager: CommunicatorManagerProtocol { get }
	var displayNameGetter: DisplayNameGetterProtocol { get }
	var coreDataManager: CoreDataManagerProtocol { get }
	var pictureDataSource: PicturesDataSourceProtocol { get }
}

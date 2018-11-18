//
//  RootAssembly.swift
//  TinkoffFintechIOSProject
//
//  Created by Юрий Забегаев on 17/11/2018.
//  Copyright © 2018 Юрий Забегаев. All rights reserved.
//

import Foundation

class RootAssembly {
	private(set) lazy var presentationAssembly: PresentationAssemblyProtocol = PresentationAssembly(serviceAssembly: self.serviceAssembly)
	private(set) lazy var serviceAssembly: ServicesAssemblyProtocol = ServicesAssembly(coreAssembly: self.coreAssembly)
	private lazy var coreAssembly: CoreAssemblyProtocol = CoreAssembly()
}

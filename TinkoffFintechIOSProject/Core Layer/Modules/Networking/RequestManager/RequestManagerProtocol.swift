//
//  RequestManagerProtocol.swift
//  TinkoffFintechIOSProject
//
//  Created by Юрий Забегаев on 23/11/2018.
//  Copyright © 2018 Юрий Забегаев. All rights reserved.
//

import Foundation

enum Result<Model> {
	case success(Model)
	case error(String)
}

protocol RequestManagerProtocol {
	func send<Parser>(requestConfig: RequestConfig<Parser>,
					  completionHandler: @escaping(Result<Parser.Model>) -> Void)
}

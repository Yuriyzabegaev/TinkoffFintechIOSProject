//
//  RequestManager.swift
//  TinkoffFintechIOSProject
//
//  Created by Юрий Забегаев on 23/11/2018.
//  Copyright © 2018 Юрий Забегаев. All rights reserved.
//

import Foundation

class RequestManager: RequestManagerProtocol {

	private var session: URLSession

	init() {
		session = URLSession.init(configuration: URLSessionConfiguration.default)
	}

	deinit {
		session.finishTasksAndInvalidate()
	}

	func send<Parser>(requestConfig: RequestConfig<Parser>,
					  completionHandler: @escaping (Result<Parser.Model>) -> Void) where Parser: ParserProtocol {
		guard let urlRequest = requestConfig.request.urlRequest else {
			completionHandler(Result.error("url string can't be parsed to URL"))
			return
		}

		let task = session.dataTask(with: urlRequest) { (data: Data?, _, error: Error?) in
			if let error = error {
				completionHandler(Result.error(error.localizedDescription))
				return
			}
			guard let data = data,
				let parsedModel: Parser.Model = requestConfig.parser.parse(data: data) else {
					completionHandler(Result.error("received data can't be parsed"))
					return
			}

			completionHandler(Result.success(parsedModel))
		}

		task.resume()
	}
}

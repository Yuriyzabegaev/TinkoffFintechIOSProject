//
//  PixabayAPIRequest.swift
//  TinkoffFintechIOSProject
//
//  Created by Юрий Забегаев on 23/11/2018.
//  Copyright © 2018 Юрий Забегаев. All rights reserved.
//

import Foundation

// https://pixabay.com/api/?key=10782881-cf13614773bfa7bcceb5822ee&q=yellow+flowers&image_type=photo&pretty=true&per_page=10

class PixabayPicturesListRequest: RequestProtocol {
	private let baseUrl: String =  "https://pixabay.com/api/"
	private let numberOfPictures: Int
	private let identificationKey: String

	private var getParameters: [String: String] {
		return ["key": identificationKey,
				"q": "yellow+flowers",
				"image_type": "photo",
				"pretty": "true",
				"per_page": String(numberOfPictures)]
	}

	private var urlString: String {
		let getParams = getParameters.compactMap({ "\($0.key)=\($0.value)"}).joined(separator: "&")
		return baseUrl + "?" + getParams
	}

	// MARK: - RequestProtocol

	var urlRequest: URLRequest? {
		if let url = URL(string: urlString) {
			return URLRequest(url: url)
		}
		return nil
	}

	// MARK: - Initialization
	init(identificationKey: String, numberOfPictures: Int) {
		self.numberOfPictures = numberOfPictures
		self.identificationKey = identificationKey
	}
}

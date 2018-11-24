//
//  PixabayPictureRequest.swift
//  TinkoffFintechIOSProject
//
//  Created by Юрий Забегаев on 23/11/2018.
//  Copyright © 2018 Юрий Забегаев. All rights reserved.
//

import Foundation

class PixabayPictureRequest: RequestProtocol {
	private let baseURL: String = "https://pixabay.com/get/"
	private let pictureID: String

	private var urlString: String {
		return "\(baseURL)\(pictureID)"
	}

	var urlRequest: URLRequest? {
		if let url = URL(string: urlString) {
			return URLRequest(url: url)
		}
		return nil
	}

	init(pictureID: String) {
		self.pictureID = pictureID
	}

}

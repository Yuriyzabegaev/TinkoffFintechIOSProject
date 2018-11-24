//
//  PixabayApiParser.swift
//  TinkoffFintechIOSProject
//
//  Created by Юрий Забегаев on 23/11/2018.
//  Copyright © 2018 Юрий Забегаев. All rights reserved.
//

import Foundation

class PixabayPicturesListParser: ParserProtocol {
	typealias Model = PixabayPicturesList

	func parse(data: Data) -> PixabayPicturesList? {
		return try? JSONDecoder().decode(PixabayPicturesList.self, from: data)
	}

}

class PixabayPicturesList: Codable {
	var totalHits: Int
	var hits: [Hit]
}

class Hit: Codable {
	var webformatURL: String
}

//
//  RequestsFactory.swift
//  TinkoffFintechIOSProject
//
//  Created by Юрий Забегаев on 23/11/2018.
//  Copyright © 2018 Юрий Забегаев. All rights reserved.
//

import Foundation

struct RequestConfig<Parser> where Parser: ParserProtocol {
	let request: RequestProtocol
	let parser: Parser
}

struct RequestsFactory {
	struct PixabayRequests {
		static private let identificationKey: String = "10782881-cf13614773bfa7bcceb5822ee"

		static func picturesListRequest(numberOfPictures: Int) -> RequestConfig<PixabayPicturesListParser> {
			let request = PixabayPicturesListRequest(identificationKey: self.identificationKey, numberOfPictures: numberOfPictures)
			return RequestConfig(request: request, parser: PixabayPicturesListParser())
		}

		static func pictureRequest(pictureID: String) -> RequestConfig<PixabayPictureParser> {
			let request = PixabayPictureRequest(pictureID: pictureID)
			return RequestConfig(request: request, parser: PixabayPictureParser())
		}
	}
}

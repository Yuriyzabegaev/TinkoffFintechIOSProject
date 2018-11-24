//
//  PixabayPictureParses.swift
//  TinkoffFintechIOSProject
//
//  Created by Юрий Забегаев on 23/11/2018.
//  Copyright © 2018 Юрий Забегаев. All rights reserved.
//

import Foundation

class PixabayPictureParser: ParserProtocol {
	typealias Model = UIImage

	func parse(data: Data) -> UIImage? {
		return UIImage(data: data)
	}
}

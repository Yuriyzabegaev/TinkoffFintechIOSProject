//
//  ParserProtocol.swift
//  TinkoffFintechIOSProject
//
//  Created by Юрий Забегаев on 23/11/2018.
//  Copyright © 2018 Юрий Забегаев. All rights reserved.
//

import Foundation

protocol ParserProtocol {
	associatedtype Model
	func parse(data: Data) -> Model?
}

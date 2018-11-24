//
//  PictureDataSourceProtocol.swift
//  TinkoffFintechIOSProject
//
//  Created by Юрий Забегаев on 23/11/2018.
//  Copyright © 2018 Юрий Забегаев. All rights reserved.
//

import Foundation

protocol PicturesDataSourceProtocol: class {
	var numberOfPictures: Int { get }
	var delegate: PicturesDataSourceDelegate? { get set }
	func getPicture(at index: Int, completion: ((UIImage) -> Void)?)
}

protocol PicturesDataSourceDelegate: class {
	func isReady(_ picturesDataSource: PicturesDataSourceProtocol)
	func didCatchError(_ picturesDataSource: PicturesDataSourceProtocol, description: String)
}

//
//  PictureChooserModelProtocol.swift
//  TinkoffFintechIOSProject
//
//  Created by Юрий Забегаев on 23/11/2018.
//  Copyright © 2018 Юрий Забегаев. All rights reserved.
//

import Foundation

protocol PictureChooserModelDelegate: class {
	func didPrepareStorage(_ pictureChooserModel: PictureChooserModelProtocol)
	func didUpdateImage(_ pictureChooserModel: PictureChooserModelProtocol, at index: Int)
	func didCatchError(_ pictureChooserModel: PictureChooserModelProtocol, description: String)
}

protocol PictureChooserModelProtocol {
	var numberOfPictures: Int { get }
	var delegate: PictureChooserModelDelegate? { get set }
	var storageIsReady: Bool { get }
	subscript(index: Int) -> UIImage? { get }
}

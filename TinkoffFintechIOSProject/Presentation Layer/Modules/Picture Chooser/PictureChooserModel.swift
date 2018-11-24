//
//  PictureChooserModel.swift
//  TinkoffFintechIOSProject
//
//  Created by Юрий Забегаев on 23/11/2018.
//  Copyright © 2018 Юрий Забегаев. All rights reserved.
//

import Foundation

class PictureChooserModel: PictureChooserModelProtocol {

	weak var delegate: PictureChooserModelDelegate?
	private let dataSource: PicturesDataSourceProtocol

	var numberOfPictures: Int {
		return dataSource.numberOfPictures
	}

	private var imagesCache: [Int: UIImage] = [:]
	private(set) var storageIsReady: Bool = false {
		didSet {
			if storageIsReady {
				delegate?.didPrepareStorage(self)
			}
		}
	}

	init(dataSource: PicturesDataSourceProtocol) {
		self.dataSource = dataSource
		self.dataSource.delegate = self
	}

	subscript(index: Int) -> UIImage? {
		guard storageIsReady else { return nil }

		if let imageFromCache = imagesCache[index] {
			return imageFromCache
		}
		dataSource.getPicture(at: index) { [weak self] image in
			guard let self = self else { return }
			self.imagesCache.updateValue(image, forKey: index)
			self.delegate?.didUpdateImage(self, at: index)
		}

		return nil
	}

}

extension PictureChooserModel: PicturesDataSourceDelegate {
	func isReady(_ picturesDataSource: PicturesDataSourceProtocol) {
		storageIsReady = true
	}

	func didCatchError(_ picturesDataSource: PicturesDataSourceProtocol, description: String) {
		delegate?.didCatchError(self, description: description)
	}
}

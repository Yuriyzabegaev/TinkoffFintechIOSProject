//
//  NetworkServiceStaff.swift
//  TinkoffFintechIOSProject
//
//  Created by Юрий Забегаев on 23/11/2018.
//  Copyright © 2018 Юрий Забегаев. All rights reserved.
//

import Foundation

class PicturesPixabayNetworkService: PicturesDataSourceProtocol {

	weak var delegate: PicturesDataSourceDelegate?

	private let pixabayBaseURL = "https://pixabay.com/get/"

	private var requestManager: RequestManagerProtocol!
	private var picturesIDs: [String] = []

	private(set) var numberOfPictures: Int

	init(requestManager: RequestManagerProtocol, numberOfPictures: Int) {
		self.numberOfPictures = numberOfPictures
		self.requestManager = requestManager

		initialisePicturesList()
	}

	private func initialisePicturesList() {
		requestManager.send(requestConfig: RequestsFactory.PixabayRequests
			.picturesListRequest(numberOfPictures: numberOfPictures)) { [weak self] result in

				switch result {
				case .error(let description):
					guard let self = self else { return }
					self.delegate?.didCatchError(self, description: description)

				case .success(let picturesList):
					self?.configurePicturesList(with: picturesList)
				}
		}
	}

	private func configurePicturesList(with picturesList: PixabayPicturesList) {
		var picturesIDs: [String] = []
		for entity in picturesList.hits {
			picturesIDs += [entity.webformatURL.removingPrefix(prefix: pixabayBaseURL)]
		}
		self.picturesIDs = picturesIDs
		delegate?.isReady(self)
	}

	func getPicture(at index: Int, completion: ((UIImage) -> Void)?) {
		guard index < picturesIDs.count else {
			delegate?.didCatchError(self, description: "Data source has no image at given index: \(index)")
			return
		}

		requestManager.send(requestConfig: RequestsFactory.PixabayRequests
			.pictureRequest(pictureID: picturesIDs[index])) { [weak self] result in
				switch result {
				case .error(let description):
					guard let self = self else { return }
					self.delegate?.didCatchError(self, description: description)
				case .success(let image):
					completion?(image)
				}
		}
	}

}

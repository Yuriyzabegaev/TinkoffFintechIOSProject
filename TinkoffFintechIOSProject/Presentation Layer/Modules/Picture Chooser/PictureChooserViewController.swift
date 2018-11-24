//
//  PhotoChooserViewController.swift
//  TinkoffFintechIOSProject
//
//  Created by Юрий Забегаев on 23/11/2018.
//  Copyright © 2018 Юрий Забегаев. All rights reserved.
//

import UIKit

private let reuseIdentifier = "picture identifier"

class PictureChooserViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

	@IBOutlet var activityIndicator: UIActivityIndicatorView!
	@IBOutlet var collectionView: UICollectionView!

	weak var delegate: PictureChooserDelegate?

	// MARK: - Dependencies

	private var assembly: PresentationAssemblyProtocol!
	private var model: PictureChooserModelProtocol!

	func setUpDependencies(assembly: PresentationAssemblyProtocol, model: PictureChooserModelProtocol) {
		self.assembly = assembly
		self.model = model
		self.model.delegate = self
	}

	// MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

		collectionView.dataSource = self
		collectionView.delegate = self

		activityIndicator.hidesWhenStopped = true

		if model.storageIsReady {
			showModelIsReady()
		} else {
			showModelIsPreparing()
		}
	}

	// MARK: Actions

	@IBAction func backButtonIsTapped(_ sender: Any) {
		dismiss(animated: true, completion: nil)
	}

	// MARK: Utils

	private func showModelIsPreparing() {
		activityIndicator.startAnimating()
	}

	private func showModelIsReady() {
		DispatchQueue.main.async {
			self.activityIndicator.stopAnimating()
			self.collectionView.reloadData()
		}
	}

	private func showError(description: String) {
		let alert = UIAlertController(
			title: "An error occured.. :(",
			message: description,
			preferredStyle: .alert)

		alert.addAction(
			UIAlertAction(
				title: NSLocalizedString("Okey", comment: ""),
				style: .cancel) { [weak self] _ in
					self?.dismiss(animated: true)
		})

		self.present(alert, animated: true)
	}

	// MARK: UICollectionViewDataSource

	func numberOfSections(in collectionView: UICollectionView) -> Int {
		if model.storageIsReady {
			return 1
		} else {
			return 0
		}
    }

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.numberOfPictures
    }

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)

		guard let photoCell = cell as? PictureChooserCell else { return cell }

		guard let image = model[indexPath.item] else {
			cell.isUserInteractionEnabled = false
			let placeHolderImage = UIImage(named: "placeholder-user")
			photoCell.picture.image = placeHolderImage
			return photoCell
		}
		cell.isUserInteractionEnabled = true
		photoCell.picture.image = image
		return photoCell
	}

    // MARK: UICollectionViewDelegateFlowLayout

	private var spacing: CGFloat = 2.0
	private var cellSize: CGSize {
		let size = self.collectionView.bounds.width / 3 - spacing * 2/3
		return CGSize(width: size, height: size)
	}

	func collectionView(_ collectionView: UICollectionView,
						layout collectionViewLayout: UICollectionViewLayout,
						sizeForItemAt indexPath: IndexPath) -> CGSize {
		return cellSize
	}

	func collectionView(_ collectionView: UICollectionView,
						layout collectionViewLayout: UICollectionViewLayout,
						minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return 0.0
	}

	func collectionView(_ collectionView: UICollectionView,
						layout collectionViewLayout: UICollectionViewLayout,
						minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return spacing
	}

	// MARK: UICollectionViewDelegate

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		guard let cell = collectionView.cellForItem(at: indexPath) as? PictureChooserCell,
			let image = cell.picture.image else { return }

		delegate?.didChoosePicture(self, picture: image)
		dismiss(animated: true)
	}

}

extension PictureChooserViewController: PictureChooserModelDelegate {
	func didPrepareStorage(_ pictureChooserModel: PictureChooserModelProtocol) {
		showModelIsReady()
	}

	func didUpdateImage(_ pictureChooserModel: PictureChooserModelProtocol, at index: Int) {
		DispatchQueue.main.async {
			self.collectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
		}
	}

	func didCatchError(_ pictureChooserModel: PictureChooserModelProtocol, description: String) {
		DispatchQueue.main.async {
			self.showError(description: description)
		}
	}
}

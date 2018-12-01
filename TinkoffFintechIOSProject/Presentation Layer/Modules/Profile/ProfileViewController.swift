//
//  ViewController.swift
//  TinkoffFintechIOSProject
//
//  Created by Юрий Забегаев on 20.09.2018.
//  Copyright © 2018 Юрий Забегаев. All rights reserved.
//

import UIKit

class ProfileViewController: KeyboardInputViewController {

    // MARK: - Outlets

    @IBOutlet var profilePhotoImageView: UIImageView!
    @IBOutlet var editButton: UIButton!
    @IBOutlet var choosePhotoButton: UIButton!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var bioTextField: UITextField!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var bioLabel: UILabel!

    // MARK: - Properties

    private(set) var isEditingContent: Bool = false {
        didSet {
            isSaveButtonEnabled = false

            editButton.isHidden = isEditingContent

            saveButton.isHidden = !isEditingContent

            choosePhotoButton.isHidden = !isEditingContent

            bioTextField.isUserInteractionEnabled = isEditingContent
            bioTextField.isHidden = !isEditingContent

            nameTextField.isUserInteractionEnabled = isEditingContent
            nameTextField.isHidden = !isEditingContent

            nameLabel.isHidden = isEditingContent

            bioLabel.isHidden = isEditingContent
        }
    }

    private var isSaveButtonEnabled: Bool {
        get { return profileModel.profileData.isModified }
        set(newValue) {
            saveButton.isEnabled = newValue
        }
    }

    // MARK: - Actions

    @IBAction func saveButtonTapped(_ sender: UIButton) {
        handleTextFieldsNewData()
        saveProfileData()
    }

    @IBAction func editButtonTapped(_ sender: Any) {
        isEditingContent = true
    }

    @IBAction func choosePhotoButtonTapped(_ sender: UIButton) {
        handleTextFieldsNewData()

        let chooseAlert = UIAlertController(
            title: "Edit profile picture",
            message: "You may choose your profile picture from photo library or make photo right now",
            preferredStyle: .actionSheet)

        chooseAlert.addAction(
            UIAlertAction(
                title: NSLocalizedString("Open photo library", comment: ""),
                style: .default,
                handler: { [weak self] _ in
                    guard let strongSelf = self else { return }
                    if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                        let imagePicker = UIImagePickerController()
                        imagePicker.delegate = strongSelf
                        imagePicker.sourceType = .photoLibrary
                        imagePicker.allowsEditing = true
                        strongSelf.present(imagePicker, animated: true, completion: nil)
                    }
            }))

        chooseAlert.addAction(
            UIAlertAction(
                title: NSLocalizedString("Make new photo", comment: ""),
                style: .default) { [weak self] _ in
                    guard let strongSelf = self else { return }
                    if UIImagePickerController.isSourceTypeAvailable(.camera) {
                        let imagePicker = UIImagePickerController()
                        imagePicker.delegate = strongSelf
                        imagePicker.sourceType = .camera
                        imagePicker.allowsEditing = false
                        strongSelf.present(imagePicker, animated: true, completion: nil)
                    }
        })

		chooseAlert.addAction(
			UIAlertAction(title: "Download",
						  style: .default) { [weak self] _ in
							guard let segueID = self?.photoChooserSegueID else { return }
							self?.performSegue(withIdentifier: segueID, sender: nil)
		})

        chooseAlert.addAction(
            UIAlertAction(
                title: "Cancel",
                style: .cancel,
                handler: nil))

        self.present(chooseAlert, animated: true)
    }

	// MARK: - Dependencies

	private var profileModel: ProfileModelProtocol!
	private var assembly: PresentationAssemblyProtocol!

	func setUpDependencies(model: ProfileModelProtocol, assembly: PresentationAssemblyProtocol) {
		profileModel = model
		profileModel.delegate = self
		self.assembly = assembly
	}

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

        isEditingContent = false

		configureTextFields()

		activityIndicator.hidesWhenStopped = true

        restoreProfileData()

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done",
                                                                 style: .done,
                                                                 target: self,
                                                                 action: #selector(self.dismissScreen))
    }

	private func configureTextFields() {
		nameTextField.delegate = self
		bioTextField.delegate = self
	}

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
		makeCornoredButtons()
    }

    // MARK: - Overrides

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.bioTextField.isFirstResponder || self.nameTextField.isFirstResponder {
            handleTextFieldsNewData()
        }
    }

	// MARK: - Navigation

	let photoChooserSegueID = "To Photo Chooser"

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		super.prepare(for: segue, sender: sender)

		switch segue.identifier {
		case photoChooserSegueID:
			guard let navigation = segue.destination as? UINavigationController,
				let photoChooserViewController = navigation.viewControllers.first as? PictureChooserViewController else { return }
			assembly.setUp(photoChooserViewController: photoChooserViewController)
			photoChooserViewController.delegate = self
		default:
			return
		}
	}

    // MARK: - Selector Methods

    @objc
    private func dismissScreen() {
        dismiss(animated: true, completion: nil)
    }

    // MARK: - Private methods

	private func makeCornoredButtons() {
		let cornerRadius = choosePhotoButton.frame.size.height / 2

		choosePhotoButton.layer.masksToBounds = true
		choosePhotoButton.layer.cornerRadius = cornerRadius
		choosePhotoButton.imageView?.contentMode = .scaleAspectFit
		choosePhotoButton.imageEdgeInsets = UIEdgeInsets(
			top: cornerRadius/2.7,
			left: cornerRadius/2.7,
			bottom: cornerRadius/2.7,
			right: cornerRadius/2.7)

		editButton.layer.cornerRadius = cornerRadius / 5
		editButton.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
		editButton.layer.borderWidth = 1.0

		saveButton.layer.cornerRadius = cornerRadius / 5
		saveButton.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
		saveButton.layer.borderWidth = 1.0

		profilePhotoImageView.layer.masksToBounds = true
		profilePhotoImageView.layer.cornerRadius = cornerRadius
	}

    private func saveProfileData() {
        self.activityIndicator.startAnimating()
        self.saveButton.isUserInteractionEnabled = false

        profileModel.save { [weak self] isSucceeded in
            if self != nil {
				DispatchQueue.main.async {
					self?.activityIndicator.stopAnimating()
					self?.isEditingContent = false
					self?.saveButton.isUserInteractionEnabled = true
				}

                if isSucceeded {
                    self?.showSuccessSaveAlert()
                    self?.restoreProfileData()
                } else {
                    self?.sendFailureSaveAlert()
                }
            }
        }
    }

    private func restoreProfileData() {
        self.activityIndicator.startAnimating()

        profileModel.loadProfileData { [weak self] in
            if self != nil {
				DispatchQueue.main.async {
					self?.activityIndicator.stopAnimating()
				}
            }
        }
    }

    private func showSuccessSaveAlert() {
        let successAlert = UIAlertController(
            title: "Your data is saved",
            message: nil,
            preferredStyle: .alert)

        successAlert.addAction(
            UIAlertAction(
                title: NSLocalizedString("Ok", comment: ""),
                style: .cancel))

        self.present(successAlert, animated: true)
    }

    private func sendFailureSaveAlert() {
        let failureAlert = UIAlertController(
            title: "Oops.. Something went wrong",
            message: nil,
            preferredStyle: .alert)

        failureAlert.addAction(
            UIAlertAction(
                title: NSLocalizedString("Ok", comment: ""),
                style: .cancel))

        failureAlert.addAction(
            UIAlertAction(title: "Retry",
                          style: .default) { _ in
                            self.saveProfileData()
        })

        self.present(failureAlert, animated: true)
    }

    private func sendEmptyNameWarningAlert() {
        let alert = UIAlertController(
            title: "Sorry, name field should not be empty.",
            message: "Please enter your name",
            preferredStyle: .alert)

        alert.addAction(
            UIAlertAction(
                title: NSLocalizedString("Ok", comment: ""),
                style: .cancel) { [weak self] _ in
                    self?.nameTextField.becomeFirstResponder()
        })

        self.present(alert, animated: true)
    }

}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.originalImage] as? UIImage {
            profileModel.profileData.image = image
            profilePhotoImageView.image = image
            dismiss(animated: true, completion: nil)

            isSaveButtonEnabled = true
        }
    }

}

extension ProfileViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleTextFieldsNewData()
        return true
    }

    private func handleTextFieldsNewData() {

        // handling name field

        if profileModel.profileData.name != nameTextField.text {

            if let text = nameTextField.text,
                text != "" {

                profileModel.profileData.name = text

            } else { // Name field should no be empty

                nameTextField.text = profileModel.profileData.name

                self.view.endEditing(true)

                self.sendEmptyNameWarningAlert()
                return
            }

            isSaveButtonEnabled = true
        }

        // handling bio field

        if profileModel.profileData.bio != bioTextField.text {
            profileModel.profileData.bio = bioTextField.text

            isSaveButtonEnabled = true
        }
        self.view.endEditing(true)
    }

}

extension ProfileViewController: ProfileModelDelegate {
	func didChangeData(_ model: ProfileModelProtocol) {
		nameTextField.text = profileModel.profileData.name
		bioTextField.text = profileModel.profileData.bio
		nameLabel.text = profileModel.profileData.name
		bioLabel.text = profileModel.profileData.bio
		profilePhotoImageView.image = profileModel.profileData.image ?? UIImage(named: "placeholder-user")

		isSaveButtonEnabled = true
	}
}

extension ProfileViewController: PictureChooserDelegate {
	func didChoosePicture(_ pictureChooser: PictureChooserViewController, picture: UIImage) {
		profileModel.profileData = ProfileData(name: profileModel.profileData.name,
											   bio: profileModel.profileData.bio,
											   image: picture)
	}
}

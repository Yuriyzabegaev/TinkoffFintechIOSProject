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
        get { return profileData.isModified }
        set(newValue) {
            saveButton.isEnabled = newValue
        }
    }

    private var profileData = ProfileData(name: nil, bio: nil, image: nil) {
        didSet {
            nameTextField.text = profileData.name
            bioTextField.text = profileData.bio
            nameLabel.text = profileData.name
            bioLabel.text = profileData.bio
            profilePhotoImageView.image = profileData.image ?? UIImage(named: "placeholder-user")
        }
    }

	private var profileDataManager: ProfileDataManager!

    // MARK: - Actions

    @IBAction func saveButtonTapped(_ sender: UIButton) {
        handleTextFieldsNewData()
        saveProfileData(via: profileDataManager)
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
            UIAlertAction(
                title: "Cancel",
                style: .cancel,
                handler: nil))

        self.present(chooseAlert, animated: true)
    }

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

		self.profileDataManager = ProfileCoreDataManager(myUserID: CommunicatorManager.shared.myUserID)

        isEditingContent = false

        nameTextField.delegate = self
        bioTextField.delegate = self

        restoreProfileData(via: profileDataManager)

        activityIndicator.hidesWhenStopped = true

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done",
                                                                 style: .done,
                                                                 target: self,
                                                                 action: #selector(self.dismissScreen))
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // setting UI
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

    // MARK: - Overrides

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.bioTextField.isFirstResponder || self.nameTextField.isFirstResponder {
            handleTextFieldsNewData()
        }
    }

    // MARK: - Selector Methods

    @objc
    private func dismissScreen() {
        dismiss(animated: true, completion: nil)
    }

    // MARK: - Private methods

    private func saveProfileData(via manager: ProfileDataManager) {
        self.activityIndicator.startAnimating()
        self.saveButton.isUserInteractionEnabled = false

        manager.save(profileData: self.profileData) { [weak self] isSucceeded in
            if self != nil {
				DispatchQueue.main.async {
					self?.activityIndicator.stopAnimating()
					self?.isEditingContent = false
					self?.saveButton.isUserInteractionEnabled = true
				}

                if isSucceeded {
                    self?.sendSuccessSaveAlert()
                    self?.restoreProfileData(via: manager)
                } else {
                    self?.sendFailureSaveAlert(via: manager)
                }
            }
        }
    }

    private func restoreProfileData(via manager: ProfileDataManager) {
        self.activityIndicator.startAnimating()

        manager.loadProfileData { [weak self] profileData in
            if self != nil {
				DispatchQueue.main.async {
					self?.activityIndicator.stopAnimating()
				}

                self?.profileData = profileData
            }
        }
    }

    private func sendSuccessSaveAlert() {
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

    private func sendFailureSaveAlert(via manager: ProfileDataManager) {
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
                            self.saveProfileData(via: manager)
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
            profileData.image = image
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

        if profileData.name != nameTextField.text {

            if let text = nameTextField.text,
                text != "" {

                profileData.name = text

            } else { // Name field should no be empty

                nameTextField.text = profileData.name

                self.view.endEditing(true)

                self.sendEmptyNameWarningAlert()
                return
            }

            isSaveButtonEnabled = true
        }

        // handling bio field

        if profileData.bio != bioTextField.text {
            profileData.bio = bioTextField.text

            isSaveButtonEnabled = true
        }

        self.view.endEditing(true)
    }

}

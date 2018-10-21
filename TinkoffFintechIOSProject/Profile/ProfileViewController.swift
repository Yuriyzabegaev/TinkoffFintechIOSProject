//
//  ViewController.swift
//  TinkoffFintechIOSProject
//
//  Created by Юрий Забегаев on 20.09.2018.
//  Copyright © 2018 Юрий Забегаев. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    // MARK: - Outlets

    @IBOutlet var profilePhotoImageView: UIImageView!
    @IBOutlet var editButton: UIButton!
    @IBOutlet var choosePhotoButton: UIButton!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var bioTextField: UITextField!
    @IBOutlet var saveViaGCDButton: UIButton!
    @IBOutlet var saveViaOperationButton: UIButton!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var bioLabel: UILabel!
    
    // MARK: - Properties
    
    private(set) var isEditingContent: Bool = false {
        didSet {
            areSaveButtonsEnabled = false
            
            editButton.isHidden = isEditingContent
            
            saveViaOperationButton.isHidden = !isEditingContent
            
            saveViaGCDButton.isHidden = !isEditingContent
            
            choosePhotoButton.isHidden = !isEditingContent
            
            bioTextField.isUserInteractionEnabled = isEditingContent
            bioTextField.isHidden = !isEditingContent
            
            nameTextField.isUserInteractionEnabled = isEditingContent
            nameTextField.isHidden = !isEditingContent
            
            nameLabel.isHidden = isEditingContent
            
            bioLabel.isHidden = isEditingContent
        }
    }
    
    private var areSaveButtonsEnabled: Bool {
        get { return profileData.isModified }
        set(newValue) {
            saveViaGCDButton.isEnabled = newValue
            saveViaOperationButton.isEnabled = newValue
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

    private let gcdProfileDataManager = GCDProfileDataManager()
    private let operationProfileDataManager = OperationProfileDataManager()

    
    // MARK: - Actions
    @IBAction func saveViaGCDButtonTapped(_ sender: UIButton) {
        handleTextFieldsNewData()
        saveProfileData(via: gcdProfileDataManager)
    }
    
    @IBAction func saveViaOperationButtonTapped(_ sender: UIButton) {
        handleTextFieldsNewData()
        saveProfileData(via: operationProfileDataManager)
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
                        imagePicker.sourceType = .photoLibrary;
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
                        imagePicker.sourceType = .camera;
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
        
        isEditingContent = false
    
        nameTextField.delegate = self
        bioTextField.delegate = self
        
        if 1.arc4random == 0 { // randomly choose to use Operation of GCD to restore data
            restoreProfileData(via: gcdProfileDataManager)
        } else {
            restoreProfileData(via: operationProfileDataManager)
        }
    
        activityIndicator.hidesWhenStopped = true
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done",
                                                                 style: .done,
                                                                 target: self,
                                                                 action: #selector(self.dismissScreen))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    override func viewDidLayoutSubviews() {
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
        
        saveViaGCDButton.layer.cornerRadius = cornerRadius / 5
        saveViaGCDButton.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        saveViaGCDButton.layer.borderWidth = 1.0
        
        saveViaOperationButton.layer.cornerRadius = cornerRadius / 5
        saveViaOperationButton.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        saveViaOperationButton.layer.borderWidth = 1.0
        
        profilePhotoImageView.layer.masksToBounds = true
        profilePhotoImageView.layer.cornerRadius = cornerRadius
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    
    // MARK: - Overrides
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.bioTextField.isFirstResponder || self.nameTextField.isFirstResponder {
            handleTextFieldsNewData()
        }
    }
    
    
    //MARK: - Selector Methods
    
    @objc
    func keyboardWillShow(notification: NSNotification) {
        if self.view.frame.origin.y == 0,
            let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            let keyboardHeight = keyboardFrame.size.height
            self.view.frame = CGRect(x: self.view.frame.origin.x,
                                     y: self.view.frame.origin.y - keyboardHeight,
                                     width: self.view.frame.width,
                                     height: self.view.frame.height)
            self.view.layoutIfNeeded()
            
        }
    }
            
    @objc
    func keyboardWillHide(notification: NSNotification) {
        self.view.frame = CGRect(x: self.view.frame.origin.x,
                                 y: 0,
                                 width: self.view.frame.width,
                                 height: self.view.frame.height)
        self.view.layoutIfNeeded()
    }
    
    @objc
    private func dismissScreen() {
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Private methods

    private func saveProfileData(via manager: ProfileDataManager) {
        self.activityIndicator.startAnimating()
        self.saveViaGCDButton.isUserInteractionEnabled = false
        self.saveViaOperationButton.isUserInteractionEnabled = false

        manager.save(profileData: self.profileData) { [weak self] isSucceeded in
            if self != nil {
                self?.activityIndicator.stopAnimating()
                
                self?.isEditingContent = false
                
                self?.saveViaGCDButton.isUserInteractionEnabled = true
                self?.saveViaOperationButton.isUserInteractionEnabled = true
                
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
                self?.activityIndicator.stopAnimating()
                
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
                          style: .default) { action in
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            profileData.image = image
            profilePhotoImageView.image = image
            dismiss(animated:true, completion: nil)
            
            areSaveButtonsEnabled = true
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
            
            areSaveButtonsEnabled = true
        }
        
        // handling bio field
        
        if profileData.bio != bioTextField.text {
            profileData.bio = bioTextField.text
            
            areSaveButtonsEnabled = true
        }
        
        self.view.endEditing(true)
    }
        
}

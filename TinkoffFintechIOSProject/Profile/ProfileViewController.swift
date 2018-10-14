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

    @IBOutlet weak var profilePhotoImageView: UIImageView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var choosePhotoButton: UIButton!
    
    
    // MARK: - Actions
    
    @IBAction func choosePhotoButtonTapped(_ sender: UIButton) {
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
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done",
                                                                 style: .done,
                                                                 target: self,
                                                                 action: #selector(self.dismissScreen))
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
        
        profilePhotoImageView.layer.masksToBounds = true
        profilePhotoImageView.layer.cornerRadius = cornerRadius
    }
    
    
    //MARK: - Private Methods
    
    @objc
    private func dismissScreen() {
        dismiss(animated: true, completion: nil)
    }
    
}


extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            profilePhotoImageView.image = image
            dismiss(animated:true, completion: nil)
        }
    }
    
}

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
    
    
    // MARK: - Properties
    
    var logger: Logger = Logger(name: String(describing: type(of: self)))
    
    // MARK: - Initialization
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
//        print(editButton.frame)
        /*
         editButton == nil failure, as the outlets are not set up in this method
        */
    }
    
    // MARK: - Actions
    
    @IBAction func choosePhotoButtonTapped(_ sender: UIButton) {
        logger.logCurrentMethod(named: #function,
                                withMessage: "Выбери изображение профиля")
        
        let chooseAlert = UIAlertController(
            title: "Edit profile picture",
            message: "You may choose your profile picture from photo gallery or make photo right now",
            preferredStyle: .actionSheet)
        
        chooseAlert.addAction(
            UIAlertAction(
                title: NSLocalizedString("Open photo gallery", comment: ""),
                style: .default,
                handler: { _ in
                    NSLog("The \"OK\" alert occured.")
            }))
        chooseAlert.addAction(
            UIAlertAction(
                title: NSLocalizedString("Make new photo", comment: ""),
                style: .default,
                handler: { _ in
                    NSLog("The \"OK\" alert occured.")
            }))
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
        
        logger.logCurrentMethod(named: #function,
                                withMessage: "self.editButton.frame == \(editButton.frame)")
        
        // setting UI
        let cornerRadius = choosePhotoButton.frame.size.height / 2 - 8
        
        choosePhotoButton.layer.masksToBounds = true
        choosePhotoButton.layer.cornerRadius = cornerRadius
        choosePhotoButton.imageView?.contentMode = .scaleAspectFit
        choosePhotoButton.imageEdgeInsets = UIEdgeInsets(
            top: cornerRadius/2.7,
            left: cornerRadius/2.7,
            bottom: cornerRadius/2.7,
            right: cornerRadius/2.7)
        
        editButton.layer.cornerRadius = cornerRadius / 3
        editButton.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        editButton.layer.borderWidth = 1.0
        
        profilePhotoImageView.layer.masksToBounds = true
        profilePhotoImageView.layer.cornerRadius = cornerRadius
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        logger.logCurrentMethod(named: #function,
                                withMessage: "self.editButton.frame == \(editButton.frame)")
        /*
            during the viewDidLoad method the frames of the views are not set correctly according to the constraints, but in viewDidAppear they are.
         */
    }
    
}

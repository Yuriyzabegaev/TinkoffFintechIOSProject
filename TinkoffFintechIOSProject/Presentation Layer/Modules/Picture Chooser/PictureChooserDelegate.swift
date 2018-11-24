//
//  PictureChooserDelegate.swift
//  TinkoffFintechIOSProject
//
//  Created by Юрий Забегаев on 24/11/2018.
//  Copyright © 2018 Юрий Забегаев. All rights reserved.
//

import Foundation

protocol PictureChooserDelegate: class {
	func didChoosePicture(_ pictureChooser: PictureChooserViewController, picture: UIImage)
}

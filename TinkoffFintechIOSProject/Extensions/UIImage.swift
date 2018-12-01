//
//  UIImage.swift
//  TinkoffFintechIOSProject
//
//  Created by Юрий Забегаев on 01/12/2018.
//  Copyright © 2018 Юрий Забегаев. All rights reserved.
//

import Foundation

extension UIImage {
	func scaleToSize(_ newSize: CGSize) -> UIImage? {
		UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
		self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
		guard let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
		UIGraphicsEndImageContext()
		return newImage
	}
}

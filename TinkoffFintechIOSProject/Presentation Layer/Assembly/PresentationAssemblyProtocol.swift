//
//  PresentationLayerProtocol.swift
//  TinkoffFintechIOSProject
//
//  Created by Юрий Забегаев on 17/11/2018.
//  Copyright © 2018 Юрий Забегаев. All rights reserved.
//

import Foundation

protocol PresentationAssemblyProtocol {
	func rootViewController() -> UIViewController?
	func setUp(profileViewController: ProfileViewController)
	func setUp(conversationViewController: ConversationViewController)
	func setUp(photoChooserViewController: PictureChooserViewController)
}

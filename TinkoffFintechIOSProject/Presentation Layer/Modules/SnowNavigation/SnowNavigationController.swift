//
//  SnowNavigationController.swift
//  TinkoffFintechIOSProject
//
//  Created by Юрий Забегаев on 01/12/2018.
//  Copyright © 2018 Юрий Забегаев. All rights reserved.
//

import Foundation

class SnowNavigation: UINavigationController {
	private var snowMaker: SnowMakerProtocol! = TinkoffSnowMaker()

	override func viewDidLoad() {
		super.viewDidLoad()
		snowMaker.configureView(view: view)
	}

}

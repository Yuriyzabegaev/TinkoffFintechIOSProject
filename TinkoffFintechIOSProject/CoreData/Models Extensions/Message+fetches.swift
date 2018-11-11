//
//  Message+fetches.swift
//  TinkoffFintechIOSProject
//
//  Created by Юрий Забегаев on 10/11/2018.
//  Copyright © 2018 Юрий Забегаев. All rights reserved.
//

import Foundation
import CoreData

extension Message {
	func configure(text: String, isIncoming: Bool) {
		self.timeStamp = Date()
		self.isIncoming = isIncoming
		self.text = text
	}

	func readMessage() {
		self.isUnread = false
	}

}

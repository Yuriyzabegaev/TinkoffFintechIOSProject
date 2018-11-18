//
//  ProfileData.swift
//  TinkoffFintechIOSProject
//
//  Created by Юрий Забегаев on 21/10/2018.
//  Copyright © 2018 Юрий Забегаев. All rights reserved.
//

import Foundation

class ProfileData {

    var name: String? {
        didSet {
            nameIsChanged = true
        }
    }
    var bio: String? {
        didSet {
            bioIsChanged = true
        }
    }
    var image: UIImage? {
        didSet {
            imageIsChanged = true
        }
    }

    var isModified: Bool {
        return nameIsChanged || bioIsChanged || imageIsChanged
    }

    private(set) var nameIsChanged: Bool = false
    private(set) var bioIsChanged: Bool = false
    private(set) var imageIsChanged: Bool = false

    init(name: String?, bio: String?, image: UIImage?) {
        self.name = name
        self.bio = bio
        self.image = image
    }
}

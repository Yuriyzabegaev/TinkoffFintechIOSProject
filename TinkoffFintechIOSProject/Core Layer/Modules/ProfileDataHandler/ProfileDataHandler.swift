//
//  ProfileDataHandler.swift
//  TinkoffFintechIOSProject
//
//  Created by Юрий Забегаев on 21/10/2018.
//  Copyright © 2018 Юрий Забегаев. All rights reserved.
//

import Foundation

class ProfileDataHandler: DisplayNameGetterProtocol, ProfileDataHandlerProtocol {

    // MARK: - Properties

    private let defaults: UserDefaults

	let suiteName = "ru.tinkoffFintechIOSProject.profile"

	let nameKey = "name"
	let bioKey = "bio"
    private let imageFileName = "photo.png"

    private let storageDirectoryURL: URL

    // MARK: - Initialization

    init() {
        defaults = UserDefaults.init(suiteName: suiteName)!
        storageDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("Profile", isDirectory: true)

        let directoryExists = FileManager.default.fileExists(atPath: storageDirectoryURL.path)
        if !directoryExists {
            try? FileManager.default.createDirectory(at: storageDirectoryURL, withIntermediateDirectories: false)
        }
    }

	func getMyDisplayName() -> String {
        return UserDefaults(suiteName: suiteName)?.object(forKey: nameKey) as? String ?? UIDevice.current.name
    }

    // MARK: - Public methods

    func save(profileData: ProfileData) -> Bool {

        if profileData.nameIsChanged,
            let name = profileData.name {
            defaults.set(name, forKey: nameKey)
        }
        if profileData.bioIsChanged,
            let bio = profileData.bio {
            defaults.set(bio, forKey: bioKey)
        }
        if profileData.imageIsChanged,
            let image = profileData.image {
            guard let imageData = image.jpegData(compressionQuality: 1) else { return false }
            do {
                try imageData.write(to: storageDirectoryURL.appendingPathComponent(imageFileName, isDirectory: false).standardizedFileURL)
            } catch let error {
                print(error.localizedDescription)
                return false
            }
        }
        return true
    }

    func loadProfileData() -> ProfileData {
        let name = defaults.object(forKey: nameKey) as? String
        let bio = defaults.object(forKey: bioKey) as? String
        let image = UIImage(contentsOfFile: storageDirectoryURL.appendingPathComponent(imageFileName, isDirectory: false).path)
        return ProfileData(name: name, bio: bio, image: image)
    }
}

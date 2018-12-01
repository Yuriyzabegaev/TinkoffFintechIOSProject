//
//  ThemesSwiftViewControllerTableViewController.swift
//  TinkoffFintechIOSProject
//
//  Created by Юрий Забегаев on 12/10/2018.
//  Copyright © 2018 Юрий Забегаев. All rights reserved.
//

import UIKit

class ThemesViewController: UIViewController {

    // MARK: - Properties

    var themePickerHandler: ((UIColor) -> Void)?

	// MARK: - Dependencies

	private var model: Themes!

	func setUpDependencies(model: Themes) {
		self.model = model
	}

    // MARK: - Actions

    @IBAction func themePicked(_ sender: UIButton) {
        let newTheme = model.getTheme(sender.tag) ?? UIColor.white
        changeThemeTo(newTheme: newTheme)
    }

    @IBAction func dismissScreen(_ sender: UIButton) {
        dismiss(animated: true)
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        if let theme = UserDefaults.standard.getTheme(forKey: "Theme") {
            view.backgroundColor = theme
            self.navigationController?.navigationBar.barTintColor = theme
        }
    }

    // MARK: - Private methods

    private func changeThemeTo(newTheme: UIColor) {
        self.view.backgroundColor = newTheme
        self.navigationController?.navigationBar.barTintColor = newTheme
        themePickerHandler?(newTheme)
    }
}

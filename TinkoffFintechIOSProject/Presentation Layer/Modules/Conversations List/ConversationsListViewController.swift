//
//  ConversationsListViewController.swift
//  TinkoffFintechIOSProject
//
//  Created by Юрий Забегаев on 03.10.2018.
//  Copyright © 2018 Юрий Забегаев. All rights reserved.
//

import UIKit
import CoreData

extension UITableView: FRCManagerDelegate {}

class ConversationsListViewController: UITableViewController {

    struct SegueIdentifier {
        static let toConversation = "toConversation"
        static let toProfile = "toProfile"
        static let toThemes = "toThemes"
    }

	private var knownConversationsIDsWithOnlineStates: [String: Bool] = [:]

    // MARK: - Dependencies
	private var conversatiosListModel: ConversationsListModelProtocol!
	private var presentationAssembly: PresentationAssemblyProtocol!

	// MARK: - Initialization

	func setUpDependencies(presentationAssembly: PresentationAssemblyProtocol,
					conversationsListModel: ConversationsListModelProtocol,
					myDisplayName: String) {
		// called from assembly
		self.presentationAssembly = presentationAssembly
		conversatiosListModel = conversationsListModel
		conversatiosListModel.displayName = myDisplayName
		conversatiosListModel.frcManagerDelegate = tableView
	}

	private func setupTableView() {
		tableView.rowHeight = UITableView.automaticDimension
		tableView.estimatedRowHeight = 70
	}

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
		setupTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        conversatiosListModel.delegate = self
        tableView.reloadData()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        conversatiosListModel.delegate = nil
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        switch segue.identifier {
		case SegueIdentifier.toProfile:
			guard let navigation = segue.destination as? UINavigationController,
				let profileViewController = navigation.viewControllers.first as? ProfileViewController else {
					return
			}
			presentationAssembly.setUp(profileViewController: profileViewController)
		case SegueIdentifier.toConversation:

			if let cell = sender as? ConversationCellConfiguration,
				let conversationViewController = segue.destination as? ConversationViewController {
				presentationAssembly.setUp(conversationViewController: conversationViewController)
				conversationViewController.configureData(with: cell)
			}

		case SegueIdentifier.toThemes:

			if let navigationController = segue.destination as? UINavigationController {

				guard let themesViewController = navigationController.viewControllers
					.first as? ThemesViewController else { return }

				presentationAssembly.setUp(themesViewController: themesViewController)

				themesViewController.themePickerHandler = { [weak self] newTheme in
					self?.updateTheme(to: newTheme)
				}

			}
		default:
			return
		}

    }

	private func updateTheme(to theme: UIColor) {
		DispatchQueue.global(qos: .background).async {
			UserDefaults.standard.setTheme(theme: theme, forKey: "Theme")
		}
		UINavigationBar.appearance().barTintColor = theme
	}

    // MARK: - TableViewDataSource and TableViewDelegate

	override func numberOfSections(in tableView: UITableView) -> Int {
		return conversatiosListModel.numberOfSections
	}

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return conversatiosListModel.numberOfRowsInSection(section)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConversationListCell", for: indexPath) as! ConversationCellView

		guard let conversation = conversatiosListModel.conversation(at: indexPath),
			let opponent = conversation.opponent else { return cell }
		cell.userID = opponent.userID ?? ""
		cell.name = opponent.name ?? ""
		cell.message = conversation.lastMessage?.text
		cell.date = conversation.lastMessage?.timeStamp
		cell.hasUnreadMessage = conversation.lastMessage?.isUnread ?? false

		let isOnline = conversation.opponent?.isOnline ?? false

		if let сonversationIndex = opponent.userID {

			if let wasOnline = knownConversationsIDsWithOnlineStates[сonversationIndex] {

				if wasOnline && !isOnline {
					cell.setOffline(animated: true)
				} else if !wasOnline && isOnline {
					cell.setOnline(animated: true)
				}

			} else {

				if isOnline {
					cell.setOnline(animated: false)
				} else {
					cell.setOffline(animated: false)
				}

			}
			knownConversationsIDsWithOnlineStates.updateValue(isOnline, forKey: сonversationIndex)
		}

        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return "Dialogues"
    }

	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

		if editingStyle == .delete {
			conversatiosListModel.deleteConversation(at: indexPath)
		}

	}

}

extension ConversationsListViewController: ConversationsListModelDelegate {
	func didUpdateData(_ model: ConversationsListModelProtocol) {
		tableView.reloadData()
	}

    func didCatchError(_ model: ConversationsListModelProtocol, error: Error) {
        let errorAlert = UIAlertController(
            title: "Oops.. An error",
            message: nil,
            preferredStyle: .alert)

        errorAlert.addAction(
            UIAlertAction(
                title: NSLocalizedString(error.localizedDescription, comment: ""),
                style: .cancel))

        self.present(errorAlert, animated: true)
    }
}

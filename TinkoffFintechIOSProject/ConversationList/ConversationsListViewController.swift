//
//  ConversationsListViewController.swift
//  TinkoffFintechIOSProject
//
//  Created by Юрий Забегаев on 03.10.2018.
//  Copyright © 2018 Юрий Забегаев. All rights reserved.
//

import UIKit
import CoreData

class ConversationsListViewController: UITableViewController {

    struct SegueIdentifier {
        static let toConversation = "toConversation"
        static let toProfile = "toProfile"
        static let toThemes = "toThemes"
    }

    // MARK: - Properties

    // initialized in viewDidLoad
    var communicatorManager: CommunicatorManager!
	var fetchedResultsController: NSFetchedResultsController<Conversation>!

	let frcManager = FRCManager()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        let myDisplayName = ProfileDataHandler.getMyDisplayName()
        CommunicatorManager.visibleName = myDisplayName
        communicatorManager = CommunicatorManager.shared

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 70

		let onlineFetchRequest: NSFetchRequest<Conversation> = Conversation.fetchRequest()

		onlineFetchRequest.sortDescriptors = [
			NSSortDescriptor(key: "opponent.isOnline", ascending: false),
			NSSortDescriptor(key: "lastMessage.timeStamp", ascending: false)
		]

		fetchedResultsController = CoreDataManager.shared.setupFRC(onlineFetchRequest,
																   frcManager: frcManager)

		frcManager.controllingTableView = tableView

		do {
			try fetchedResultsController.performFetch()
		} catch {
			print(error.localizedDescription)
		}
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        communicatorManager.delegate = self

        tableView.reloadData()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        communicatorManager.delegate = nil
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        switch segue.identifier {
        case SegueIdentifier.toConversation:

            if let cell = sender as? ConversationCellConfiguration,
                let conversationViewController = segue.destination as? ConversationViewController {
                conversationViewController.configureData(with: cell)
            }

        case SegueIdentifier.toThemes:

            if let navigationController = segue.destination as? UINavigationController {

                guard let themesSwiftViewController = navigationController.viewControllers
					.first as? ThemesSwiftViewController else { return }

                themesSwiftViewController.themePickerHandler = { [weak self] newTheme in
                    self?.considerThemeChanging(selectedTheme: newTheme)
                }

            }
        default:
            return
        }

    }

	private func considerThemeChanging(selectedTheme: UIColor) {
		DispatchQueue.global(qos: .background).async {
			UserDefaults.standard.setTheme(theme: selectedTheme, forKey: "Theme")
		}
		UINavigationBar.appearance().barTintColor = selectedTheme
	}

    // MARK: - TableViewDataSource and TableViewDelegate

	override func numberOfSections(in tableView: UITableView) -> Int {
		return fetchedResultsController?.sections?.count ?? 1
	}

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		guard let sections = fetchedResultsController?.sections else {
			return 0
		}

		return sections[section].numberOfObjects
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConversationListCell", for: indexPath) as! ConversationCell

		let conversation = fetchedResultsController.object(at: indexPath)
		guard let opponent = conversation.opponent else { return cell }
		cell.userID = opponent.userID ?? ""
		cell.name = opponent.name ?? ""
		cell.message = conversation.lastMessage?.text
		cell.date = conversation.lastMessage?.timeStamp
		cell.online = conversation.opponent?.isOnline ?? false
		cell.hasUnreadMessage = conversation.lastMessage?.isUnread ?? false

        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return "Dialogues"
    }

	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

		if editingStyle == .delete {
			let conversation: Conversation = fetchedResultsController.object(at: indexPath)
			CoreDataManager.shared.delete(conversation)
			CoreDataManager.shared.save()

		}

	}

}

extension ConversationsListViewController: CommunicatorManagerDelegate {
	func didUpdateData() {
		tableView.reloadData()
	}

    func didCatchError(error: Error) {
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

//
//  ConversationViewController.swift
//  TinkoffFintechIOSProject
//
//  Created by Юрий Забегаев on 05.10.2018.
//  Copyright © 2018 Юрий Забегаев. All rights reserved.
//

import UIKit
import CoreData

class ConversationViewController: KeyboardInputViewController {

    private struct CellIdentifiers {
        static let outgoing = "OutgoingMessageCell"
        static let incoming = "IncomingMessageCell"
    }

    // MARK: - Properties

    // configured in configureData(with:)
    var opponentID: String!
    var opponentDisplayName: String?
	var opponentIsOnline: Bool!

    // configured in viewDidLoad()
    var communicatorManager: CommunicatorManager!
	var fetchedResultsController: NSFetchedResultsController<Message>!

	let frcManager = FRCManager()

    @IBOutlet var tableView: UITableView!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var inputTextView: UITextView!
    @IBOutlet var inputContainer: UIView!

    @IBAction func didTapSendButton(_ sender: UIButton) {
        if inputTextView.hasText {
            let text: String = inputTextView.text!
            inputTextView.text = ""
            communicatorManager.sendMessage(text: text, to: opponentID)
        }
    }

    // MARK: - Called from segue

    func configureData(with cell: ConversationCellConfiguration) {
		opponentIsOnline = cell.online
        opponentID = cell.userID
        opponentDisplayName = cell.name ?? "Unknown person"

        navigationItem.title = opponentDisplayName
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.keyboardDismissMode = .onDrag

        tableView.transform = CGAffineTransform(scaleX: 1, y: -1)

        tableView.dataSource = self
        tableView.delegate = self

        inputTextView.textContainer.maximumNumberOfLines = 1
        inputTextView.textContainer.lineBreakMode = NSLineBreakMode.byTruncatingTail

        inputTextView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        inputTextView.layer.borderWidth = 0.5

        let myDisplayName = ProfileDataHandler.getMyDisplayName()
        CommunicatorManager.visibleName = myDisplayName
        communicatorManager = CommunicatorManager.shared
        communicatorManager.delegate = self

		let fetchRequest: NSFetchRequest<Message> = CoreDataManager.shared.fetchRequest(type: .messagesFromConversationWithID(opponentID))

		fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timeStamp", ascending: false)]

		fetchedResultsController = CoreDataManager.shared.setupFRC(fetchRequest,
																   frcManager: frcManager)
		frcManager.controllingTableView = tableView

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 70

        tableView.separatorStyle = .none

		do {
			try fetchedResultsController.performFetch()
		} catch {
			print(error.localizedDescription)
		}

		if !opponentIsOnline {
			disableSendButton()
		}
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        tableView.reloadData()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        communicatorManager.delegate = nil
    }

	private func disableSendButton() {
		sendButton.isEnabled = false
		sendButton.alpha = 0.4
	}

}

extension ConversationViewController: UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return fetchedResultsController?.sections?.count ?? 0
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		guard let sections = fetchedResultsController?.sections else {
			return 0
		}

		return sections[section].numberOfObjects
	}

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let message = fetchedResultsController.object(at: indexPath)
		if message.isUnread != false {
			message.isUnread = false
		}
		let identifier = message.isIncoming ? CellIdentifiers.incoming : CellIdentifiers.outgoing

		let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! MessageCell
		cell.messageText = message.text
		cell.timeStamp = message.timeStamp
		cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
		return cell
    }

}

extension ConversationViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

		if editingStyle == .delete {
			let message: Message = fetchedResultsController.object(at: indexPath)
			CoreDataManager.shared.delete(message)
			CoreDataManager.shared.save()
		}

	}

	func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
		return "-"
	}

}

extension ConversationViewController: CommunicatorManagerDelegate {
    func didCatchError(error: Error) {
        let errorAlert = UIAlertController(
            title: "Oops.. An error",
            message: nil,
            preferredStyle: .alert)

        errorAlert.addAction(
            UIAlertAction(
                title: NSLocalizedString("Cancel", comment: ""),
                style: .cancel,
                handler: { _ in
                    self.disableSendButton()
            }))

        self.present(errorAlert, animated: true)
        if let communicatorError = error as? MultipeerCommunicator.MultipeerCommunicatorError {
            switch communicatorError {
            case .sessionNotFoundError(let str):
                print(#function + " " + str)
            case .unableToSendMessage(let error):
                print(#function + " " + error.localizedDescription)
            }
        }
    }

	func didUpdateData() {
		tableView.reloadData()
	}

}

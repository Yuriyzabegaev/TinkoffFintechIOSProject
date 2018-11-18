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

	private enum CellIdentifiers: String {
        case outgoing = "OutgoingMessageCell"
        case incoming = "IncomingMessageCell"
    }

    // MARK: - Properties

    // configured in configureData(with:)
    var opponentID: String!
    var opponentDisplayName: String?
	var opponentIsOnline: Bool!

	// MARK: - Dependencies
//	private var frcManager: FRCManagerProtocol!
//	private var communicatorManager: CommunicatorManager!
//	private var fetchedResultsController: NSFetchedResultsController<Message>!
	private var conversationModel: ConversationModelProtocol!

	func setUpDependencies(conversationModel: ConversationModelProtocol) {
		self.conversationModel = conversationModel
	}

    @IBOutlet var tableView: UITableView!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var inputTextView: UITextView!
    @IBOutlet var inputContainer: UIView!

    @IBAction func didTapSendButton(_ sender: UIButton) {
        if inputTextView.hasText {
            let text: String = inputTextView.text!
            inputTextView.text = ""
			conversationModel.sendMessage(text: text)
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
		conversationModel.setUpProperties(opponentID: opponentID, frcManagerDelegate: tableView)
		setUpUI()
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
		conversationModel.delegate = nil
    }

	private func disableSendButton() {
		sendButton.isEnabled = false
		sendButton.alpha = 0.4
	}

	private func setUpUI() {
		tableView.keyboardDismissMode = .onDrag
		tableView.dataSource = self
		tableView.delegate = self
		tableView.rowHeight = UITableView.automaticDimension
		tableView.estimatedRowHeight = 70
		tableView.separatorStyle = .none
		tableView.transform = CGAffineTransform(scaleX: 1, y: -1)

		inputTextView.textContainer.maximumNumberOfLines = 1
		inputTextView.textContainer.lineBreakMode = NSLineBreakMode.byTruncatingTail
		inputTextView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
		inputTextView.layer.borderWidth = 0.5
	}

}

extension ConversationViewController: UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return conversationModel.numberOfSections
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return conversationModel.numberOfRowsInSection(section)
	}

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let message: Message = conversationModel.message(at: indexPath) else {
			return tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.outgoing.rawValue, for: indexPath) as! MessageCell
		}
		if message.isUnread != false {
			message.isUnread = false
		}
		let identifier = message.isIncoming ? CellIdentifiers.incoming.rawValue : CellIdentifiers.outgoing.rawValue

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
			conversationModel.deleteMessage(at: indexPath)
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

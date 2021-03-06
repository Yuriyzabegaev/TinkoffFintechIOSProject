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

	private var hasError: Bool = false
	private var lastTextInInputTextView: String = ""

    // MARK: - Properties

    // configured in configureData(with:)
    private var opponentID: String!
    private var opponentNameString: String?
	private var opponentIsOnline: Bool! {
		didSet {
			highlightOpponentName(opponentIsOnline, animated: true)
		}
	}

	// MARK: - Dependencies
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
        opponentNameString = cell.name ?? "Unknown person"
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
		conversationModel.setUpProperties(opponentID: opponentID, frcManagerDelegate: tableView)
		conversationModel.delegate = self
		inputTextView.delegate = self

		setUpUI()

		disableSendButton(animated: false)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
		highlightOpponentName(opponentIsOnline, animated: true)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
		conversationModel.delegate = nil
    }

	private func disableSendButton(animated: Bool) {
		sendButton.isEnabled = false
		if animated {
			animateDisableSendButton()
		}
	}

	private func enableSendButton(animated: Bool) {
		sendButton.isEnabled = true
		if animated {
			animateEnableSendButton()
		}
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

		let titleLabel = UILabel()
		titleLabel.text = opponentNameString
		titleLabel.frame = CGRect.zero
		titleLabel.textAlignment = .center
		titleLabel.sizeToFit()
		titleLabel.autoresizingMask = .flexibleTopMargin
		navigationItem.titleView = titleLabel
	}

	// MARK: - Animations

	private func animateSetButtonScale() {
		UIView.transition(with: sendButton,
								 duration: 0.25,
								 options: .curveEaseIn,
								 animations: {
									self.sendButton.transform = CGAffineTransform.init(scaleX: 1.15,
																					   y: 1.15)
		}, completion: { _ in
			UIView.transition(with: self.sendButton,
							  duration: 0.25,
							  options: .curveEaseIn,
							  animations: {
								self.sendButton.transform = CGAffineTransform.init(scaleX: 0.85,
																				   y: 0.85)
			})
		})
	}

	private func animateDisableSendButton() {
		UIView.animate(withDuration: 0.5,
					   animations: {
						self.sendButton.alpha = 0.4
		})
		animateSetButtonScale()
	}

	private func animateEnableSendButton() {
		UIView.animate(withDuration: 0.5,
					   animations: {
						self.sendButton.alpha = 1
		})
		animateSetButtonScale()
	}

	static let onlineNameLabelColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
	static let offlineNameLabelColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)

	private func highlightOpponentName(_ highlight: Bool, animated: Bool) {
		guard let titleLabel = navigationItem.titleView as? UILabel else { return }

		let textColorAnimation: () -> Void = {
			titleLabel.textColor = highlight ? ConversationViewController.onlineNameLabelColor : ConversationViewController.offlineNameLabelColor
		}

		if animated {
			let oldFrame = titleLabel.frame
			UIView.animate(withDuration: 0.5,
						   animations: {
							titleLabel.frame = CGRect(origin: oldFrame.origin,
													  size: CGSize(width: oldFrame.width * 2,
																   height: oldFrame.height * 2))

			}, completion: { _ in
							UIView.animate(withDuration: 0.5,
										   animations: {
											titleLabel.frame = oldFrame
							})
			})
//			let scaleTextAnimation = CABasicAnimation(keyPath: "frame")
//			scaleTextAnimation.beginTime = CACurrentMediaTime()
//			scaleTextAnimation.fromValue = oldFrame
//			scaleTextAnimation.toValue = CGRect(origin: oldFrame.origin,
//												size: CGSize(width: oldFrame.width * 2,
//															 height: oldFrame.height * 2))
//			scaleTextAnimation.duration = 0.5
//			scaleTextAnimation.fillMode = .removed
//			scaleTextAnimation.isRemovedOnCompletion = true
//			navigationItem.titleView?.layer.add(scaleTextAnimation, forKey: nil)
//			let scaleAnimation: () -> Void = {
//				titleLabel.transform = titleLabel.transform.scaledBy(x: 1.1, y: 1.1)
//			}
//			let scaleCompletion: () -> Void = {
//				titleLabel.transform = CGAffineTransform.identity
//			}
//			UIView.transition(with: titleLabel,
//							  duration: 0.5,
//							  options: .transitionCrossDissolve,
//							  animations: scaleAnimation,
//							  completion: { _ in
//								UIView.transition(with: titleLabel,
//												  duration: 0.5,
//												  options: .transitionCrossDissolve,
//												  animations: scaleCompletion)
//			})
			UIView.transition(with: titleLabel,
							  duration: 1,
							  options: .transitionCrossDissolve,
							  animations: textColorAnimation)
		} else {
			textColorAnimation()
		}
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

extension ConversationViewController: ConversationModelDelegate {
	func didCatchError(_ model: ConversationModelProtocol, error: Error) {
        let errorAlert = UIAlertController(
            title: "Oops.. An error",
            message: nil,
            preferredStyle: .alert)

        errorAlert.addAction(
            UIAlertAction(
                title: NSLocalizedString("Cancel", comment: ""),
                style: .cancel,
                handler: { _ in
					self.hasError = true
                    self.disableSendButton(animated: true)
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

	func didUpdateData(_ conversationModel: ConversationModelProtocol) {
		tableView.reloadData()
	}

}

extension ConversationViewController: UITextViewDelegate {
	func textViewDidChange(_ textView: UITextView) {

		var firstLetterIsAddedOrRemoved = false
		if lastTextInInputTextView.count == 0 && textView.hasText || lastTextInInputTextView.count != 0 && !textView.hasText {
			firstLetterIsAddedOrRemoved = true
		}
		lastTextInInputTextView = textView.text
		if !firstLetterIsAddedOrRemoved {
			return
		}

		if !opponentIsOnline || hasError {
			return
		}
		if textView.hasText {
			enableSendButton(animated: true)
		} else {
			disableSendButton(animated: true)
		}
	}
}

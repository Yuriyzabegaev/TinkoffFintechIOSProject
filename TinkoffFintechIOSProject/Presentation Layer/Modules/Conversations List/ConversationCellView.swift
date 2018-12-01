//
//  Cell.swift
//  TinkoffFintechIOSProject
//
//  Created by Юрий Забегаев on 03.10.2018.
//  Copyright © 2018 Юрий Забегаев. All rights reserved.
//

import UIKit

protocol ConversationCellConfiguration: class {
    var userID: String {get set}

    var name: String? {get set}
    var message: String? {get set}
    var date: Date? {get set}
    var hasUnreadMessage: Bool {get set}
	var online: Bool {get}
	func setOnline(animated: Bool)
	func setOffline(animated: Bool)
}

class ConversationCellView: UITableViewCell, ConversationCellConfiguration {

	static let onlineCellColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
	static let offlineCellColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)

    // MARK: - properties

    var userID: String = ""

    var name: String? {
        didSet {
            if name == nil {
                nameLabel.text = "Unknown person"
            } else {
                nameLabel.text = name
            }
        }
    }
    var message: String? {
        didSet {
            if let lastMessageText = message {
                lastMessageLabel.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
                lastMessageLabel.text = lastMessageText
            } else {
                lastMessageLabel.font = UIFont.italicSystemFont(ofSize: UIFont.systemFontSize - 0.5)
                lastMessageLabel.text = "No messages yet"
            }
        }
    }
    var date: Date? {
        didSet {
            guard let date = date else {
                timestampLabel.text = nil
                return
            }
            let formatter = DateFormatter()
            if Calendar.current.isDateInToday(date) {
                formatter.dateFormat = "HH:mm"
                timestampLabel.text = formatter.string(from: date)
            } else {
                formatter.dateFormat = "dd MMM"
                timestampLabel.text = formatter.string(from: date)
            }
        }
    }
    private(set) var online: Bool = false

    var hasUnreadMessage: Bool = false {
        didSet {
            if hasUnreadMessage && message != nil {
                lastMessageLabel.font = UIFont.boldSystemFont(ofSize: lastMessageLabel.font.pointSize)
            }
        }
    }

    // MARK: - Outlets

    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var lastMessageLabel: UILabel!
    @IBOutlet private var timestampLabel: UILabel!

    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        nameLabel.font = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)

        let backgroundView = UIView()
        backgroundView.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.968627451, alpha: 1)
        selectedBackgroundView = backgroundView

        lastMessageLabel!.textColor = UIColor.darkGray
    }

	// MARK: - Animations

	func setOnline(animated: Bool) {
		online = true
		performAnimations(animated: animated)
	}

	func setOffline(animated: Bool) {
		online = false
		performAnimations(animated: animated)
	}

	private func performAnimations(animated: Bool) {
		let backgroundAnimation: () -> Void = {
			self.backgroundColor = self.online ? #colorLiteral(red: 1, green: 0.9243035078, blue: 0.6523137865, alpha: 1) : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
		}
		let textColorAnimation: () -> Void = {
			self.lastMessageLabel.textColor = self.online ? ConversationCellView.onlineCellColor : ConversationCellView.offlineCellColor
		}

		if animated {
			UIView.transition(with: nameLabel,
							  duration: 0.5,
							  options: .transitionCrossDissolve,
							  animations: {
								self.nameLabel.transform = self.nameLabel.transform.scaledBy(x: 1.1, y: 1.1)
			}, completion: { _ in
				UIView.transition(with: self.nameLabel,
								  duration: 0.5,
								  options: .transitionCrossDissolve,
								  animations: {
									self.nameLabel.transform = CGAffineTransform.identity
				})
			})

			UIView.transition(with: lastMessageLabel,
							  duration: 1,
							  options: [UIView.AnimationOptions.curveEaseIn,
										UIView.AnimationOptions.transitionCrossDissolve],
							  animations: textColorAnimation)
			UIView.animate(withDuration: 1, animations: backgroundAnimation)
		} else {
			backgroundAnimation()
			textColorAnimation()
		}
	}

}

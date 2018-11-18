//
//  MessageCellTableViewCell.swift
//  TinkoffFintechIOSProject
//
//  Created by Юрий Забегаев on 05.10.2018.
//  Copyright © 2018 Юрий Забегаев. All rights reserved.
//

import UIKit

protocol MessageCellConfiguration: class {
    var messageText: String? {get set}
    var timeStamp: Date? {get set}
}

class MessageCell: UITableViewCell, MessageCellConfiguration {

    // MARK: - Properties
    var messageText: String? {
        didSet {
            messageLabel.text = messageText
        }
    }

    var timeStamp: Date? {
        didSet {
            guard let timeStamp = timeStamp else {
                timeLabel.text = nil
                return
            }
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            timeLabel.text = formatter.string(from: timeStamp)
        }
    }

    // MARK: - Outlets

    @IBOutlet var timeLabel: UILabel!
    @IBOutlet private var messageLabel: UILabel!
    @IBOutlet private var containerView: UIView!

    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()

        containerView.layer.cornerRadius = 16
    }

}

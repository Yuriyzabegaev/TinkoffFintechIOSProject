//
//  Cell.swift
//  TinkoffFintechIOSProject
//
//  Created by Юрий Забегаев on 03.10.2018.
//  Copyright © 2018 Юрий Забегаев. All rights reserved.
//

import UIKit


protocol ConversationCellConfiguration: class {
    var name : String? {get set}
    var message : String? {get set}
    var date : Date? {get set}
    var online : Bool {get set}
    var hasUnreadMessage : Bool {get set}
}


class ConversationCell: UITableViewCell, ConversationCellConfiguration {
    
    //MARK: - properties
    
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
            if let lastMessageText = message  {
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
            if Date().timeIntervalSince(date) < 60*60*24 {
                formatter.dateFormat = "HH:mm"
                timestampLabel.text = formatter.string(from: date)
            } else {
                formatter.dateFormat = "dd MMM"
                timestampLabel.text = formatter.string(from: date)
            }
        }
    }
    var online: Bool = false {
        didSet {
            if online {
                self.backgroundColor = #colorLiteral(red: 1, green: 0.9243035078, blue: 0.6523137865, alpha: 1)
            } else {
                self.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            }
        }
    }
    var hasUnreadMessage: Bool = false {
        didSet {
            if hasUnreadMessage && message != nil {
                lastMessageLabel.font = UIFont.boldSystemFont(ofSize: lastMessageLabel.font.pointSize)
            }
        }
    }
    
    
    //MARK: - Outlets
    
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var lastMessageLabel: UILabel!
    @IBOutlet private var timestampLabel: UILabel!
    
    
    //MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        nameLabel.font = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.968627451, alpha: 1)
        selectedBackgroundView = backgroundView
        
        lastMessageLabel!.textColor = UIColor.darkGray
    }

}

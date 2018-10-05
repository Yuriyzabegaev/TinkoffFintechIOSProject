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
    var online : Bool? {get set}
    var hasUnreadMessage : Bool? {get set}
}


class ConversationCell: UITableViewCell, ConversationCellConfiguration {
    
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
                lastMessageLabel.font = UIFont(name: "Courier New",
                                               size: UIFont.systemFontSize - 0.5)
                lastMessageLabel.text = "No messages yet"
            }
        }
    }
    var date: Date? {
        didSet {
            guard date != nil else {
                timestampLabel.text = nil
                return
            }
            if Date().timeIntervalSince(date!) < 60*60*24 {
                timestampLabel.text = date!.timeOnlyString
            } else {
                timestampLabel.text = date!.dateOnlyString
            }
        }
    }
    var online: Bool? {
        didSet {
            if online != nil &&
                online! {
                self.backgroundColor = #colorLiteral(red: 0.9725490196, green: 0.862745098, blue: 0, alpha: 1)
            } else {
                self.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            }
        }
    }
    var hasUnreadMessage: Bool? {
        didSet {
            if hasUnreadMessage != nil &&
                hasUnreadMessage! {
                lastMessageLabel.font = UIFont.boldSystemFont(ofSize: lastMessageLabel.font.pointSize)
            }
        }
    }
    
    //MARK: - Properties
    
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var lastMessageLabel: UILabel!
    @IBOutlet private var timestampLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        nameLabel.font = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


extension Date {
    
    var dateOnlyString: String? {
        let date = Date()
        let calender = Calendar.current
        let components = calender.dateComponents([.day, .month], from: date)
        
        guard let day = components.day,
            let month = components.month else { return nil }
        
        return day.twoNumeralsString + "." + month.twoNumeralsString
    }
    
    var timeOnlyString: String? {
        let date = Date()
        let calender = Calendar.current
        let components = calender.dateComponents([.hour, .minute, .second], from: date)
        
        guard let hour = components.hour,
            let minute = components.minute,
            let second = components.second else { return nil }
        
        let today_string = hour.twoNumeralsString + ":" + minute.twoNumeralsString + ":" + second.twoNumeralsString
        
        return today_string
    }
    
}

extension Int {
    
    var twoNumeralsString : String {
        return self > 9 ? String(self) : "0" + String(self)
    }
    
}

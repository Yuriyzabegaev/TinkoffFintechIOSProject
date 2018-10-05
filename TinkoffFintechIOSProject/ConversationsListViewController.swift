//
//  ConversationsListViewController.swift
//  TinkoffFintechIOSProject
//
//  Created by Юрий Забегаев on 03.10.2018.
//  Copyright © 2018 Юрий Забегаев. All rights reserved.
//

import UIKit

class ConversationsListViewController: UITableViewController {
    
    lazy var onlineConversationsLastMessages : [(String?, String?, Date?, Bool?, Bool?)] = {
        var result : [(String?, String?, Date?, Bool?, Bool?)] = []
        let messages = ["Hello",
                        nil,
                        "How are you?",
                        "Русский текст",
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."]
        let names = ["Egor", "Ivan Kutikov", nil, "Danya", "mom"]
        let dates = [Date(),
                     Calendar.current.date(byAdding: .hour, value: -1, to: Date()),
                     Calendar.current.date(byAdding: .day, value: -1, to: Date()),
                     Calendar.current.date(byAdding: .month, value: -1, to: Date())]
        let unreads = [true, false]
        for name in names {
            for message in messages {
                for date in dates {
                    for unread in unreads{
                        result += [(name, message, date, true, unread)]
                    }
                }
            }
        }
        return result.shuffled()
    }()
    
    lazy var historyConversationsLastMessages : [(String?, String?, Date?, Bool?, Bool?)] = {
        var result : [(String?, String?, Date?, Bool?, Bool?)] = []
        let messages = ["Bye",
                        nil,
                        "Answer me please",
                        "Русский текст",
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."]
        let names = ["Dad", "Bae", nil, "Valera", "Olya"]
        let dates = [Date(),
                     Calendar.current.date(byAdding: .hour, value: -2, to: Date()),
                     Calendar.current.date(byAdding: .day, value: -2, to: Date()),
                     Calendar.current.date(byAdding: .month, value: -2, to: Date())]
        let unreads = [true, false]
        for name in names {
            for message in messages {
                for date in dates {
                    for unread in unreads{
                        result += [(name, message, date, false, unread)]
                    }
                }
            }
        }
        return result.shuffled()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 70
    }
    

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: // Online
            return onlineConversationsLastMessages.count
        case 1: // History
            return historyConversationsLastMessages.count
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Basic cell", for: indexPath) as! ConversationCell
        let name : String?, message : String?, date : Date?, online : Bool?, unreadMessage : Bool?
        switch indexPath.section {
        case 0:
            (name, message, date, online, unreadMessage) = onlineConversationsLastMessages[indexPath.item]
        case 1:
            (name, message, date, online, unreadMessage) = historyConversationsLastMessages[indexPath.item]
        default:
            fatalError()
        }
        cell.name = name
        cell.message = message
        cell.date = date
        cell.online = online
        cell.hasUnreadMessage = unreadMessage

        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Online"
        case 1:
            return "History"
        default:
            return nil
        }
    }
    

}

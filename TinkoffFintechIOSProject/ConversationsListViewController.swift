//
//  ConversationsListViewController.swift
//  TinkoffFintechIOSProject
//
//  Created by Юрий Забегаев on 03.10.2018.
//  Copyright © 2018 Юрий Забегаев. All rights reserved.
//

import UIKit

class ConversationsListViewController: UITableViewController {
    
    struct SegueIdentifier {
        static let toConversation = "toConversation"
        static let toProfile = "toProfile"
        static let toThemes = "toThemes"
    }
    
    
    // MARK: - Properties
    
    lazy var onlineConversationsLastMessages : [(String?, String?, Date?, Bool, Bool)] = {
        var result : [(String?, String?, Date?, Bool, Bool)] = []
        let messages = ["Hello",
                        nil,
                        "How are you?"]
        let names = ["Ivan Kutikov", nil]
        let dates = [Date(),
                     Calendar.current.date(byAdding: .hour, value: -1, to: Date()),
                     Calendar.current.date(byAdding: .month, value: -1, to: Date())]
        let unreads = [true, false]
        for name in names {
            for message in messages {
                for date in dates {
                    for unread in unreads {
                        result += [(name, message, date, true, unread)]
                    }
                }
            }
        }
        return result.shuffled()
    }()
    
    lazy var historyConversationsLastMessages : [(String?, String?, Date?, Bool, Bool)] = {
        var result : [(String?, String?, Date?, Bool, Bool)] = []
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
                    for unread in unreads {
                        result += [(name, message, date, false, unread)]
                    }
                }
            }
        }
        return result.shuffled()
    }()
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 70
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
                if Product.whoAmI == "Swift Product" {
                    
                    guard let themesSwiftViewController = (storyboard?.instantiateViewController(withIdentifier: "Swift-ThemesViewController")) as? ThemesSwiftViewController else { return }
                    
                    themesSwiftViewController.themePickerHandler = { [weak self] newTheme in
                        self?.considerThemeChanging(selectedTheme: newTheme)
                    }
                    navigationController.pushViewController(themesSwiftViewController, animated: true)
                    
                } else if Product.whoAmI == "Obj-C Product" {
                    
                    guard let themesObjCViewController = (storyboard?.instantiateViewController(withIdentifier: "Obj-C-ThemesViewController")) as? ThemesViewController else { return }
                    
                    themesObjCViewController.delegate = self
                    navigationController.pushViewController(themesObjCViewController, animated: true)
                }
            }
        default:
            return
        }
        
    }
    
    
    // MARK: - TableViewDataSource and TableViewDelegate
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConversationListCell", for: indexPath) as! ConversationCell
        let name : String?, message : String?, date : Date?, online : Bool, unreadMessage : Bool
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


extension ConversationsListViewController: ThemesViewControllerDelegate {
    
    func themesViewController(_ controller: ThemesViewController!, didSelectTheme selectedTheme: UIColor!) {
        considerThemeChanging(selectedTheme: selectedTheme)
    }
    
    private func logThemeChanging(selectedTheme: UIColor) {
        print(#function, selectedTheme.debugDescription)
    }
    
    private func considerThemeChanging(selectedTheme: UIColor) {
        UserDefaults.standard.setTheme(theme: selectedTheme, forKey: "Theme")
        UINavigationBar.appearance().barTintColor = selectedTheme
        logThemeChanging(selectedTheme: selectedTheme)
    }
    
}

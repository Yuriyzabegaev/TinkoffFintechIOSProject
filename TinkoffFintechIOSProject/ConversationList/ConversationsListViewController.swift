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
    
    // initialized in viewDidLoad
    var communicatorManager: CommunicatorManager!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myDisplayName = ProfileDataHandler.getMyDisplayName()
        CommunicatorManager.deviceVisibleName = myDisplayName
        communicatorManager = CommunicatorManager.standard
        communicatorManager.conversationsListDelegate = self
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 70
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tableView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        communicatorManager.conversationsListDelegate = nil
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
                    
                guard let themesSwiftViewController = navigationController.viewControllers.first as? ThemesSwiftViewController else { return }
                
                themesSwiftViewController.themePickerHandler = { [weak self] newTheme in
                    self?.considerThemeChanging(selectedTheme: newTheme)
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
            return communicatorManager.conversations.count
        case 1: // History
            return 0
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConversationListCell", for: indexPath) as! ConversationCell
        switch indexPath.section {
        case 0:
            let conversation = communicatorManager.conversations[indexPath.item]
            cell.userID = conversation.userId
            cell.name = conversation.username
            cell.message = conversation.chatMessages.last?.text
            cell.date = conversation.chatMessages.last?.timestamp
            cell.online = true
            cell.hasUnreadMessage = conversation.chatMessages.last?.isUnread ?? false
        case 1:
            fatalError("not implemented")
        default:
            fatalError()
        }

        
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
    
    
    
    private func considerThemeChanging(selectedTheme: UIColor) {
        DispatchQueue.global(qos: .background).async {
            UserDefaults.standard.setTheme(theme: selectedTheme, forKey: "Theme")
        }
        UINavigationBar.appearance().barTintColor = selectedTheme
    }
    
}


extension ConversationsListViewController: CommunicatorManagerConversationsListDelegate {
    func didReloadConversationsList() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

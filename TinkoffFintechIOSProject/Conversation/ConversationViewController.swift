//
//  ConversationViewController.swift
//  TinkoffFintechIOSProject
//
//  Created by Юрий Забегаев on 05.10.2018.
//  Copyright © 2018 Юрий Забегаев. All rights reserved.
//

import UIKit

class ConversationViewController: KeyboardInputViewController {
    
    private struct CellIdentifiers {
        static let outgoing = "OutgoingMessageCell"
        static let incoming = "IncomingMessageCell"
    }
    
    //MARK: - Properties
    
    // configured in configureData(with:)
    var opponentID: String!
    var opponentDisplayName: String?
    
    // configured in viewDidLoad()
    var communicatorManager: CommunicatorManager!
    var conversation: ConversationModel!
    
    @IBOutlet var inputTextView: UITextView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var sendButton: UIButton!
    
    @IBAction func didTapSendButton(_ sender: UIButton) {
        if inputTextView.hasText {
            let text: String = inputTextView.text!
            communicatorManager.sendMessage(text: text, to: opponentID)
        }
    }
    
    //MARK: - Configuration
    
    func configureData(with cell: ConversationCellConfiguration) {
        opponentID = cell.userID
        opponentDisplayName = cell.name ?? "Unknown person"
        
        navigationItem.title = opponentDisplayName
    }
    
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let myDisplayName = ProfileDataHandler.getMyDisplayName()
        CommunicatorManager.deviceVisibleName = myDisplayName
        communicatorManager = CommunicatorManager.standard
        communicatorManager.conversationDelegate = self
        
        conversation = communicatorManager.conversations.first(where: { conversation in
            conversation.userId == opponentID
        })
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 70
        
        tableView.separatorStyle = .none
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tableView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        communicatorManager.conversationDelegate = nil
    }


}


extension ConversationViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversation?.chatMessages.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let message = conversation?.chatMessages[indexPath.item] {
            let identifier = message.isIncoming ? CellIdentifiers.incoming : CellIdentifiers.outgoing
            
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! MessageCell
            cell.messageText = message.text
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.outgoing, for: indexPath) as! MessageCell
        cell.messageText = nil
        return cell
    }
}


extension ConversationViewController: UITableViewDelegate { }


extension ConversationViewController: CommunicatorManagerConversationDelegate {
    func didReloadMessages(user: String) {
        if user == opponentID {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func didAbandonConversation(user: String) {
        if user == opponentID {
            sendButton.isEnabled = false
        }
    }
    
}

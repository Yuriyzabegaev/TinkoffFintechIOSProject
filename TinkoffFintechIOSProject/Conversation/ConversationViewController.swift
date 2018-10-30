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
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var inputTextView: UITextView!
    @IBOutlet var inputContainer: UIView!
    
    @IBAction func didTapSendButton(_ sender: UIButton) {
        if inputTextView.hasText {
            let text: String = inputTextView.text!
            inputTextView.text = ""
            communicatorManager.sendMessage(text: text, to: opponentID)
        }
    }
    
    //MARK: - Called from segue
    
    func configureData(with cell: ConversationCellConfiguration) {
        opponentID = cell.userID
        opponentDisplayName = cell.name ?? "Unknown person"
        
        navigationItem.title = opponentDisplayName
    }
    
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.keyboardDismissMode = .onDrag
        
        tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        inputTextView.textContainer.maximumNumberOfLines = 1
        inputTextView.textContainer.lineBreakMode = NSLineBreakMode.byTruncatingTail
        
        inputTextView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        inputTextView.layer.borderWidth = 0.5
                
        let myDisplayName = ProfileDataHandler.getMyDisplayName()
        CommunicatorManager.deviceVisibleName = myDisplayName
        communicatorManager = CommunicatorManager.shared
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
        if let endIndex = conversation?.chatMessages.endIndex,
            let lastIndex = conversation?.chatMessages.index(before: endIndex),
            let message = conversation?.chatMessages[lastIndex - indexPath.item] {
            message.readMessage()
            let identifier = message.isIncoming ? CellIdentifiers.incoming : CellIdentifiers.outgoing
            
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! MessageCell
            cell.messageText = message.text
            cell.timeStamp = message.timestamp
            cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.outgoing, for: indexPath) as! MessageCell
        cell.messageText = nil
        return cell
    }
}


extension ConversationViewController: UITableViewDelegate { }


extension ConversationViewController: CommunicatorManagerConversationDelegate {
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
                    //                    if let navigation = self.navigationController {
                    //                        navigation.popViewController(animated: true)
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
    
    func didReloadMessages(user: String) {
        if user == opponentID {
            DispatchQueue.main.async {
                self.tableView.reloadData()
//                if self.conversation.chatMessages.count > 0 {
//                    self.tableView.scrollToRow(at: IndexPath(item:self.conversation.chatMessages.count-1,
//                                                             section: 0),
//                                               at: .bottom,
//                                               animated: true)
//                }
            }
        }
    }
    
    func didAbandonConversation(user: String) {
        if user == opponentID {
            disableSendButton()
        }
    }
    
    private func disableSendButton() {
        sendButton.isEnabled = false
        sendButton.alpha = 0.4
    }
    
}

//
//  MessageCellTableViewCell.swift
//  TinkoffFintechIOSProject
//
//  Created by Юрий Забегаев on 05.10.2018.
//  Copyright © 2018 Юрий Забегаев. All rights reserved.
//

import UIKit


protocol MessageCellConfiguration : class {
    var messageText: String? {get set}
}


class MessageCell: UITableViewCell, MessageCellConfiguration {
    
    //MARK: - Properties
    var messageText: String? {
        didSet {
            messageLabel.text = messageText
        }
    }
    
    
    //MARK: - Outlets
    
    @IBOutlet private var messageLabel: UILabel!
    @IBOutlet private var containerView: UIView!
    
    
    //MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.layer.cornerRadius = 16
    }

}

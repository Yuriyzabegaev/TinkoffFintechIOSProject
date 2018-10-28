//
//  KeyboardInputViewController.swift
//  TinkoffFintechIOSProject
//
//  Created by Юрий Забегаев on 27/10/2018.
//  Copyright © 2018 Юрий Забегаев. All rights reserved.
//

import Foundation


class KeyboardInputViewController: UIViewController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    
    @objc
    func keyboardWillShow(notification: NSNotification) {
        if self.view.frame.origin.y == 0,
            let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            let keyboardHeight = keyboardFrame.size.height
            self.view.frame = CGRect(x: self.view.frame.origin.x,
                                     y: self.view.frame.origin.y - keyboardHeight,
                                     width: self.view.frame.width,
                                     height: self.view.frame.height)
            self.view.layoutIfNeeded()
        }
    }
    
    @objc
    func keyboardWillHide(notification: NSNotification) {
        self.view.frame = CGRect(x: self.view.frame.origin.x,
                                 y: 0,
                                 width: self.view.frame.width,
                                 height: self.view.frame.height)
        self.view.layoutIfNeeded()
    }
}

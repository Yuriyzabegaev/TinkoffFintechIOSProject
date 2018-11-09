//
//  Logger.swift
//  TinkoffFintechIOSProject
//
//  Created by Юрий Забегаев on 21.09.2018.
//  Copyright © 2018 Юрий Забегаев. All rights reserved.
//

import Foundation
import UIKit

class Logger {

    // MARK: - Properties

    static var isLogging = true
    let name: String
    private var previousState: UIApplication.State = UIApplication.shared.applicationState

    // MARK: - Initialization

    init(name: String) {
        self.name = name
    }

    // MARK: - Public Methods

    func logCurrentMethod(named methodName: String, withMessage message: String? = nil) {
        if Logger.isLogging {
            if let message = message {
                print("<\(name)> logged from method <\(methodName)> with message: <\(message)>")
            } else {
                print("<\(name)> logged from method <\(methodName)>")
            }
        }
    }

}

extension UIApplication.State {
    var stringRepresentation: String {
        switch self {
        case .active:
            return "active"
        case .inactive:
            return "inactive"
        case .background:
            return "background"
        }
    }
}

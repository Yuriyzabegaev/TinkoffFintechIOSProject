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
    
    //MARK: - Properties
    
    static var isLogging = true
    let name: String
    private var previousState: UIApplication.State = UIApplication.shared.applicationState
    
    //MARK: - Initialization
    
    init(name: String) {
        self.name = name
    }
    
    //MARK: - Public Methods
    
    func logChangeAppState(from methodName: String) {
        if Logger.isLogging {
            print("<\(name)> moved from <\(previousState.stringRepresentation)> to <\(UIApplication.shared.applicationState.stringRepresentation)>: <\(methodName)>")
            previousState = UIApplication.shared.applicationState
        }
    }
    
    func logCurrentMethod(named methodName: String) {
        if Logger.isLogging {
            print("<\(name)> logged from method <\(methodName)>")
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

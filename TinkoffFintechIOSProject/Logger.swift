//
//  Logger.swift
//  TinkoffFintechIOSProject
//
//  Created by Юрий Забегаев on 21.09.2018.
//  Copyright © 2018 Юрий Забегаев. All rights reserved.
//

import Foundation


class Logger {
    
    //MARK: - Properties
    
    static var isLogging = true
    let name: String
    private var previousState: String = "initial state"
    
    //MARK: - Initialization
    
    init(name: String, initialState: String) {
        self.name = name
        previousState = initialState
    }
    
    //MARK: - Public Methods
    
    func logCurrentMethod(withName methodName: String, toState newState: String) {
        if Logger.isLogging {
            print("\(name) moved from <\(previousState)> to <\(newState)>: <\(methodName)>")
            previousState = newState
        }
    }
    
    func logCurrentMethod(withName methodName: String) {
        if Logger.isLogging {
            print("\(name) reached method <\(methodName)>")
        }
    }
    
}

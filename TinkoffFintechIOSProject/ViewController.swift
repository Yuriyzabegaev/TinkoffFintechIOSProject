//
//  ViewController.swift
//  TinkoffFintechIOSProject
//
//  Created by Юрий Забегаев on 20.09.2018.
//  Copyright © 2018 Юрий Забегаев. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Properties
    
    var logger: Logger!
    
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        logger = Logger(name: "ViewController", initialState: "")
        logger.logCurrentMethod(withName: #function)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        logger.logCurrentMethod(withName: #function)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        logger.logCurrentMethod(withName: #function)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        logger.logCurrentMethod(withName: #function)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        logger.logCurrentMethod(withName: #function)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        logger.logCurrentMethod(withName: #function)

    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        logger.logCurrentMethod(withName: #function)
    }
    
}


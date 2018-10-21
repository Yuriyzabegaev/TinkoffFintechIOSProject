//
//  GCDDataManager.swift
//  TinkoffFintechIOSProject
//
//  Created by Юрий Забегаев on 21/10/2018.
//  Copyright © 2018 Юрий Забегаев. All rights reserved.
//

import Foundation


protocol DataManager {
    func saveToFile(data: Data, fileName: String, completion: (Bool) -> ())
    func saveToFile(image: UIImage, fileName: String, completion: (Bool) -> ())
    
    func saveToUserDefaults(data: Data, withKey key: String, completion: (Bool) -> ())
    func saveToUserDefaults(text: String, withKey key: String, completion: (Bool) -> ())
}


class GCDDataManager: DataManager {
    func saveToFile(data: Data, fileName: String, completion: (Bool) -> () ) {
        
    }
    
    func saveToFile(image: UIImage, fileName: String, completion: (Bool) -> ()) {
        
    }

    func saveToUserDefaults(data: Data, withKey key: String, completion: (Bool) -> ()) {
        
    }
    
    func saveToUserDefaults(text: String, withKey key: String, completion: (Bool) -> ()) {
        
    }
}

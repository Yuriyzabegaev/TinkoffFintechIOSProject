//
//  CoreDataStack.swift
//  TinkoffFintechIOSProject
//
//  Created by Юрий Забегаев on 31/10/2018.
//  Copyright © 2018 Юрий Забегаев. All rights reserved.
//

import Foundation
import CoreData


class CoreDataStack {
    
    private let storeURL: URL = {
        let documentDirURL : URL = FileManager.default.urls(for: .documentDirectory,
                                                            in: .userDomainMask).first!
        let url = documentDirURL.appendingPathComponent("Store.sqlite")
        
        return url
    }()
    private let managedObjectModelName = "Storage"
    
    private(set) lazy var managedObjectModel: NSManagedObjectModel? = {
        guard let modelUrl = Bundle.main.url(forResource: self.managedObjectModelName, withExtension: "momd"),
            let result = NSManagedObjectModel(contentsOf: modelUrl) else {
                print(#function + " could not initialize managedObjectModel !!!")
                return nil
        }
        return result
    }()
    
    private(set) lazy var persistentStoreCoordiantor: NSPersistentStoreCoordinator? = {
        guard let model = managedObjectModel else {
            print(#function + " could not initialize persistentStoreCoordiantor !!!")
            return nil
        }
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                               configurationName: nil,
                                               at: storeURL,
                                               options: nil)
        } catch {
            fatalError("Error adding persistent store to coordinator: \(error.localizedDescription)")
        }
        return coordinator
    }()
    
    private(set) lazy var masterContext: NSManagedObjectContext? = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        guard let coordinator = persistentStoreCoordiantor else {
            print("Empty persistentStoreCoordinator!")
            return nil
        }
        
        context.persistentStoreCoordinator = coordinator
        context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        context.undoManager = nil
        return context
    }()

    
    private(set) lazy var mainContext: NSManagedObjectContext? = {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        guard let parentContext = masterContext else {
            print("No masterContext!")
            return nil
        }
        
        context.persistentStoreCoordinator = nil
        context.parent = parentContext
        context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        context.undoManager = nil
        return context
    }()
    
    private(set) lazy var saveContext: NSManagedObjectContext? = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        guard let parentContext = mainContext else {
            print("No mainContext!")
            return nil
        }
        
        context.parent = parentContext
        context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        context.undoManager = nil
        return context
    }()
    
    init() {
        // initializing lazy variables
        let _ = managedObjectModel
        let _ = persistentStoreCoordiantor
        let _ = masterContext
        let _ = mainContext
        let _ = saveContext
    }

    func performSave(context: NSManagedObjectContext, completionHandler: ((Bool)->())? = nil) {
        if context.hasChanges {
            context.perform { [weak self] in
                do {
                    try context.save()
                } catch {
                    print("Context save error: \(error.localizedDescription)")
                    completionHandler?(false)
                    return
                }
                
                if let parent = context.parent {
                    self?.performSave(context: parent, completionHandler: completionHandler)
                } else {
                    completionHandler?(true)
                }
            }
        } else {
            completionHandler?(true)
        }
    }
    
}

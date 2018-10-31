//
//  AppDelegate.swift
//  TinkoffFintechIOSProject
//
//  Created by Юрий Забегаев on 20.09.2018.
//  Copyright © 2018 Юрий Забегаев. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor : UIColor.lightGray]
        
        if let theme = UserDefaults.standard.getTheme(forKey: "Theme") {
            UINavigationBar.appearance().barTintColor = theme
//            UINavigationBar.appearance().backgroundColor = theme
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        saveContext()
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    // MARK: - Core Data stack
    
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
    
//    private(set) lazy var masterContext
    
    lazy var persistentContainer: NSPersistentContainer? = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "test")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        guard let context = persistentContainer?.viewContext else { return }
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}


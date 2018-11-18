//
//  AppDelegate.swift
//  TinkoffFintechIOSProject
//
//  Created by Юрий Забегаев on 20.09.2018.
//  Copyright © 2018 Юрий Забегаев. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

	private let rootAssembly = RootAssembly()
	private var coreDataManager: CoreDataManagerProtocol!

    func application(_ application: UIApplication,
					 didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		coreDataManager = rootAssembly.serviceAssembly.coreDataManager
		window = UIWindow(frame: UIScreen.main.bounds)

		window?.rootViewController = rootAssembly.presentationAssembly.rootViewController()
		window?.makeKeyAndVisible()

		restoreTheme()
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
        coreDataManager.save()
    }

	private func restoreTheme() {
		UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.lightGray]

		if let theme = UserDefaults.standard.getTheme(forKey: "Theme") {
			UINavigationBar.appearance().barTintColor = theme
		}
	}

}

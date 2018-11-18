//
//  CoreDataStackProtocol.swift
//  TinkoffFintechIOSProject
//
//  Created by Юрий Забегаев on 18/11/2018.
//  Copyright © 2018 Юрий Забегаев. All rights reserved.
//

import Foundation
import CoreData

protocol CoreDataStackProtocol {
	var mainContext: NSManagedObjectContext? { get }
	var saveContext: NSManagedObjectContext? { get }
	var managedObjectModel: NSManagedObjectModel? { get }
	func performSave(context: NSManagedObjectContext, completionHandler: ((Bool) -> Void)? )
}

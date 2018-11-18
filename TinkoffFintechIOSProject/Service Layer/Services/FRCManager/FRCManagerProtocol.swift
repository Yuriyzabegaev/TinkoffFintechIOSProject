//
//  FRCManagerProtocol.swift
//  TinkoffFintechIOSProject
//
//  Created by Юрий Забегаев on 17/11/2018.
//  Copyright © 2018 Юрий Забегаев. All rights reserved.
//

import Foundation
import CoreData

protocol FRCManagerDelegate: class {
	func beginUpdates()
	func endUpdates()
	func insertRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation)
	func deleteRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation)
	func reloadRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation)
}

protocol FRCManagerProtocol: class, NSFetchedResultsControllerDelegate {
	var delegate: FRCManagerDelegate? {get set}
}

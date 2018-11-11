//
//  FRCManager.swift
//  TinkoffFintechIOSProject
//
//  Created by Юрий Забегаев on 10/11/2018.
//  Copyright © 2018 Юрий Забегаев. All rights reserved.
//

import Foundation
import CoreData

class FRCManager: NSObject, NSFetchedResultsControllerDelegate {

	weak var controllingTableView: UITableView?

	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
		switch type {
		case .insert:
			guard let newIndexPath = newIndexPath else { return }
			controllingTableView?.insertRows(at: [newIndexPath], with: .automatic)
		case .move:
			guard let indexPath = indexPath,
				let newIndexPath = newIndexPath else { return }
			controllingTableView?.deleteRows(at: [indexPath], with: .automatic)
			controllingTableView?.insertRows(at: [newIndexPath], with: .automatic)
		case .update:
			guard let indexPath = indexPath else { return }
			controllingTableView?.reloadRows(at: [indexPath], with: .automatic)
		case .delete:
			guard let indexPath = indexPath else { return }
			controllingTableView?.deleteRows(at: [indexPath], with: .automatic)
		}
	}

	func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		controllingTableView?.beginUpdates()
	}

	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		controllingTableView?.endUpdates()
	}

	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, sectionIndexTitleForSectionName sectionName: String) -> String? {
		return nil
	}
}

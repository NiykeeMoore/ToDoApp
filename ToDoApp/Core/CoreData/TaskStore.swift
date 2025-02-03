//
//  TaskStore.swift
//  ToDoApp
//
//  Created by Niykee Moore on 03.02.2025.
//

import Foundation
import CoreData

final class TaskStore: NSObject,
                       NSFetchedResultsControllerDelegate {

    // MARK: - Properties
    
    private let coreData: CoreDataManager
    private var fetchedResultsController: NSFetchedResultsController<CDTask>?
    private let managedObjectContext: NSManagedObjectContext

    // MARK: - Initialization

    init(coreData: CoreDataManager = CoreDataManager.shared,
         managedObjectContext: NSManagedObjectContext = CoreDataManager.shared.persistentContainer.viewContext) {
        self.coreData = coreData
        self.managedObjectContext = managedObjectContext
        super.init()
        setupFetchedResultsController()
    }

    // MARK: - Setup FetchedResultsControllerDelegate
    private func setupFetchedResultsController() {
        let fetchRequest: NSFetchRequest<CDTask> = CDTask.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]

        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: managedObjectContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        fetchedResultsController?.delegate = self

        do {
            try fetchedResultsController?.performFetch()
        } catch {
            print("Ошибка performFetch: \(error)")
        }
    }

    // MARK: - Public Helper Methods

    //TODO: методы взаимодействия

    // MARK: - NSFetchedResultsControllerDelegate

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("данные изменились")
    }
}

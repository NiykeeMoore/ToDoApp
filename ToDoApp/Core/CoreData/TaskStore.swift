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

    func saveTask(entity: TaskEntity)
    {
        let cdTask = fetchCDTask(by: entity) ?? CDTask(context: coreData.context)
        
        cdTask.id = Int64(entity.taskId)
        cdTask.title = entity.title
        cdTask.taskDescription = entity.description
        cdTask.isCompleted = entity.isCompleted
        cdTask.dateCreation = entity.dateCreation
        cdTask.userId = Int64(entity.userId)
        
        coreData.saveContext()
    }

    func fetchAllTasks() -> [TaskEntity]? {
        guard let fetchedObjects = fetchedResultsController?.fetchedObjects else { return nil }
        return fetchedObjects.map { cdTask in
            TaskEntity(taskId: Int(cdTask.id),
                       title: cdTask.title ?? "",
                       description: cdTask.taskDescription ?? "",
                       isCompleted: cdTask.isCompleted,
                       dateCreation: cdTask.dateCreation ?? Date(),
                       userId: Int(cdTask.userId))
        }
    }

    func remove(task: TaskEntity) {
        guard let selectedTask = fetchCDTask(by: task) else { return }
        coreData.context.delete(selectedTask)
        coreData.saveContext()
    }

    private func fetchCDTask(by task: TaskEntity) -> CDTask? {
        let fetchRequest: NSFetchRequest<CDTask> = CDTask.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", task.taskId as CVarArg)

        if let existingTracker = try? coreData.context.fetch(fetchRequest).first {
            return existingTracker
        }
        return nil
    }

    // MARK: - NSFetchedResultsControllerDelegate

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("данные изменились")
    }
}

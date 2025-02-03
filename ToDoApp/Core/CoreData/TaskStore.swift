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
    private var fetchedResultsController: NSFetchedResultsController<CDTask>? // работает с основным контекстом для UI
    private let managedObjectContext: NSManagedObjectContext
    
    // MARK: - Initialization
    
    init(coreData: CoreDataManager = CoreDataManager.shared,
         managedObjectContext: NSManagedObjectContext = CoreDataManager.shared.context) {
        self.coreData = coreData
        self.managedObjectContext = managedObjectContext
        super.init()
        setupFetchedResultsController()
    }
    
    // MARK: - Setup NSFetchedResultsController
    
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
    
    func saveTask(entity: TaskEntity) {
        coreData.performBackgroundTask { context in
            let cdTask = self.fetchCDTask(by: entity, in: context) ?? CDTask(context: context)
            
            cdTask.id = Int64(entity.taskId)
            cdTask.title = entity.title
            cdTask.taskDescription = entity.description
            cdTask.isCompleted = entity.isCompleted
            cdTask.dateCreation = entity.dateCreation
            cdTask.userId = Int64(entity.userId)
            
            do {
                try context.save()
            } catch {
                print("Ошибка сохранения фонового контекста: \(error)")
            }
        }
    }
    
    func fetchAllTasks(completion: @escaping ([TaskEntity]) -> Void) {
        coreData.performBackgroundTask { context in
            let fetchRequest: NSFetchRequest<CDTask> = CDTask.fetchRequest()
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
            
            do {
                let cdTasks = try context.fetch(fetchRequest)
                let tasks = cdTasks.map { cdTask in
                    TaskEntity(taskId: Int(cdTask.id),
                               title: cdTask.title ?? "",
                               description: cdTask.taskDescription ?? "",
                               isCompleted: cdTask.isCompleted,
                               dateCreation: cdTask.dateCreation ?? Date(),
                               userId: Int(cdTask.userId))
                }
                DispatchQueue.main.async {
                    completion(tasks)
                }
            } catch {
                print("Ошибка выборки задач в фоне: \(error)")
                DispatchQueue.main.async {
                    completion([])
                }
            }
        }
    }
    
    func remove(task: TaskEntity) {
        coreData.performBackgroundTask { context in
            guard let selectedTask = self.fetchCDTask(by: task, in: context) else { return }
            context.delete(selectedTask)
            
            do {
                try context.save()
            } catch {
                print("Ошибка удаления задачи: \(error)")
            }
        }
    }
    
    // MARK: - Private Helper
    
    private func fetchCDTask(by task: TaskEntity, in context: NSManagedObjectContext) -> CDTask? {
        let fetchRequest: NSFetchRequest<CDTask> = CDTask.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", task.taskId as CVarArg)
        return try? context.fetch(fetchRequest).first
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("данные изменились")
    }
}

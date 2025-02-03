//
//  CoreDataManger.swift
//  ToDoApp
//
//  Created by Niykee Moore on 03.02.2025.
//

import Foundation
import CoreData

final class CoreDataManager {
    
    // MARK: - Properties
    
    static let shared = CoreDataManager()
    let persistentContainer: NSPersistentContainer
    
    // MARK: - Initialization
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "ToDoApp")
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                print("Ошибка загрузки хранилища: \(error)")
            }
        }
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    // MARK: - Context
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func newBackgroundContext() -> NSManagedObjectContext {
        return persistentContainer.newBackgroundContext()
    }
    
    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        persistentContainer.performBackgroundTask(block)
    }
    
    func saveContext() {
        let context = persistentContainer.viewContext
        context.performAndWait {
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    print("Ошибка при сохранении: \(error)")
                }
            }
        }
    }
}

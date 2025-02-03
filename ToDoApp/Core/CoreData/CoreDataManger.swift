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
    }

    // MARK: - Context

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Ошибка при сохранении: \(error)")
            }
        }
    }
}

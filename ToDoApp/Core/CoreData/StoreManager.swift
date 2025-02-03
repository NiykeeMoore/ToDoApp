//
//  StoreManager.swift
//  ToDoApp
//
//  Created by Niykee Moore on 03.02.2025.
//

import Foundation

final class StoreManager {
    static let shared = StoreManager()
    
    let taskStore: TaskStore

    private init() {
        let context = CoreDataManager.shared.context
        self.taskStore = TaskStore(managedObjectContext: context)
    }
}

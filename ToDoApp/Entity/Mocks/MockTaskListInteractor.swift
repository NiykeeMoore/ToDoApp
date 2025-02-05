//
//  MockTaskListInteractor.swift
//  ToDoApp
//
//  Created by Niykee Moore on 05.02.2025.
//

import Foundation

final class MockTaskListInteractor: TaskListInteractorInput {
    var didFetchTasks = false
    var didToggleCompletion = false
    var didShareTask = false
    var didDeleteTask = false
    
    func fetchTasks() {
        didFetchTasks = true
    }
    
    func toggleTaskCompletion(at index: Int) {
        didToggleCompletion = true
    }
    
    func shareTask(with shareContent: String) {
        didShareTask = true
    }
    
    func taskDeletion(for task: TaskEntity, completion: @escaping (Result<Void, Error>) -> Void) {
        didDeleteTask = true
        completion(.success(()))
    }
}

//
//  TaskDetailInteractor.swift
//  ToDoApp
//
//  Created by Niykee Moore on 03.02.2025.
//

import Foundation

protocol TaskDetailInteractorInput {
    func saveTask(_ task: TaskEntity)
}

final class TaskDetailInteractorImpl: TaskDetailInteractorInput {
    
    weak var presenter: TaskDetailPresenterInput?
    
    private let taskStore = StoreManager.shared.taskStore

    func saveTask(_ task: TaskEntity) {
        taskStore.saveTask(entity: task)
    }
}

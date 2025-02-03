//
//  TaskListInteractor.swift
//  ToDoApp
//
//  Created by Niykee Moore on 02.02.2025.
//

import Foundation

protocol TaskListInteractorInput: AnyObject {
    func fetchTasks()
    func toggleTaskCompletion(at index:Int)
}

protocol TaskListInteractorOutput: AnyObject {
    func tasksFetched(_ tasks: [TaskEntity])
    func onError(_ error: Error)
}


final class TaskListInteractorImpl: TaskListInteractorInput {
    // MARK: - Properties
    weak var presenter: TaskListInteractorOutput?
    
    private var tasks: [TaskEntity] = []
    private let todosLoader: TodosLoading
    private let taskStore = StoreManager.shared.taskStore
    
    // MARK: - Init
    init(todosLoader: TodosLoading) {
        self.todosLoader = todosLoader
    }
    
    //MARK: - TaskListInteractorInput
    func fetchTasks() {
        if UserDefaultsSettings.shared.hasLaunchedBefore {
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                
                self.taskStore.fetchAllTasks { tasks in
                    self.tasks = tasks
                    self.presenter?.tasksFetched(self.tasks)
                }
            }
        } else {
            todosLoader.load { result in
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    switch result {
                    case .success(let loadedTasks):
                        UserDefaultsSettings.shared.hasLaunchedBefore = true
                        
                        self.presenter?.tasksFetched(loadedTasks)
                        self.tasks = loadedTasks
                        loadedTasks.forEach { task in
                            self.taskStore.saveTask(entity: task)
                        }
                    case .failure(let failure):
                        self.presenter?.onError(failure)
                    }
                }
            }
        }
    }
    
    func toggleTaskCompletion(at index: Int) {
        tasks[index].isCompleted.toggle()
        taskStore.saveTask(entity: tasks[index])
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.presenter?.tasksFetched(self.tasks)
        }
    }
}

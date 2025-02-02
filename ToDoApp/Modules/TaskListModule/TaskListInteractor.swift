//
//  TaskListInteractor.swift
//  ToDoApp
//
//  Created by Niykee Moore on 02.02.2025.
//

import Foundation

protocol TaskListInteractorInput: AnyObject {
    func fetchTasks()
}

protocol TaskListInteractorOutput: AnyObject {
    func tasksFetched(_ tasks: [TaskEntity])
    func onError(_ error: Error)
}


final class TaskListInteractorImpl: TaskListInteractorInput {
    // MARK: - Properties
    weak var presenter: TaskListInteractorOutput?
    private let todosLoader: TodosLoading
    
    // MARK: - Init
    init(todosLoader: TodosLoading) {
        self.todosLoader = todosLoader
    }
    
    //MARK: - TaskListInteractorInput
    func fetchTasks() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self else { return }
            
            todosLoader.load { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let success):
                        self.presenter?.tasksFetched(success)
                    case .failure(let failure):
                        self.presenter?.onError(failure)
                    }
                }
            }
        }
    }
}

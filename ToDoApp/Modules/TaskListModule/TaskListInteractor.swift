//
//  TaskListInteractor.swift
//  ToDoApp
//
//  Created by Niykee Moore on 02.02.2025.
//

import Foundation

protocol TaskListInteractorInput: AnyObject {
    func fetchTasks()
    func toggleTaskComplition(at index:Int)
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
    
    // MARK: - Init
    init(todosLoader: TodosLoading) {
        self.todosLoader = todosLoader
    }
    
    //MARK: - TaskListInteractorInput
    func fetchTasks() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self else { return }
            
            if UserDefaultsSettings.shared.hasLaunchedBefore {
                
            } else {
                UserDefaultsSettings.shared.hasLaunchedBefore = true
                todosLoader.load { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let success):
                            self.presenter?.tasksFetched(success)
                            self.tasks = success
                        case .failure(let failure):
                            self.presenter?.onError(failure)
                        }
                    }
                }
            }
        }
    }
    
    func toggleTaskComplition(at index: Int) {
        tasks[index].isCompleted.toggle()
        presenter?.tasksFetched(tasks)
    }
}

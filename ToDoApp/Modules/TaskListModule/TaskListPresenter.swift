//
//  TaskListPresenter.swift
//  ToDoApp
//
//  Created by Niykee Moore on 02.02.2025.
//

import Foundation

protocol TaskListPresenterInput: AnyObject {
    func viewDidLoad()
    func checkboxDidTapped(at index: Int)
    func didSelectMenuOption(_ option: ContextMenu)
}

final class TaskListPresenterImpl: TaskListPresenterInput,
                                   TaskListInteractorOutput {
    
    //MARK: - Properties
    weak var view: TaskListView?
    var interactor: TaskListInteractorInput?
    
    // MARK: - TaskListPresenterInput
    func viewDidLoad() {
        interactor?.fetchTasks()
    }
    
    func checkboxDidTapped(at index: Int) {
        interactor?.toggleTaskCompletion(at: index)
    }
    
    func didSelectMenuOption(_ option: ContextMenu) {
        switch option {
        case .edit:
            print(1)
        case .share:
            print(2)
        case .delete:
            print(3)
        }
    }
    
    // MARK: - TaskListInteractorOutput
    func tasksFetched(_ tasks: [TaskEntity]) {
        view?.showTasks(tasks: tasks)
    }
    
    func onError(_ error: Error) {
        view?.showError(error: error)
    }
}

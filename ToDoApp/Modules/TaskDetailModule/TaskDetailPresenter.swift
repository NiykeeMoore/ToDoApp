//
//  TaskDetailPresenter.swift
//  ToDoApp
//
//  Created by Niykee Moore on 03.02.2025.
//

import Foundation

protocol TaskDetailPresenterInput: AnyObject {
    func viewDidLoad()
    func didTapExit()
}

final class TaskDetailPresenterImpl: TaskDetailPresenterInput {
    weak var view: TaskDetailView?
    var interactor: TaskDetailInteractorInput?
    var router: TaskDetailRouter?
    
    var task: TaskEntity?
    
    // MARK: - TaskListDetailPresenterInput
    func viewDidLoad() {
        if let task {
            view?.showTaskDetail(task: task)
        }
    }
    
    // MARK: - TaskListDetailInteractorOutput
    func taskFetched(_ task: TaskEntity) {
        
    }
    
    func didTapExit() {
        if let task {
            interactor?.saveTask(task)
        }
    }
}

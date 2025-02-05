//
//  TaskDetailPresenter.swift
//  ToDoApp
//
//  Created by Niykee Moore on 03.02.2025.
//

import Foundation

protocol TaskDetailPresenterInput: AnyObject {
    func viewDidLoad()
    func didTapExit(save: TaskEntity?)
}

final class TaskDetailPresenterImpl: TaskDetailPresenterInput {
    
    weak var view: TaskDetailView?
    var interactor: TaskDetailInteractorInput?
    var router: TaskDetailRouter?
    
    var task: TaskEntity?
    
    // MARK: - TaskListDetailPresenterInput
    func viewDidLoad() {
        if let exsitingTask = task {
            view?.showTaskDetail(task: exsitingTask)
        } else {
            let newTask = TaskEntity(taskId: 0,
                                     title: "",
                                     description: "",
                                     isCompleted: false,
                                     dateCreation: Date(),
                                     userId: 0)
            self.task = newTask
            view?.showTaskDetail(task: newTask)
        }
    }
    
    func didTapExit(save task: TaskEntity?) {
        if let task {
            interactor?.saveTask(task: task)
        }
        router?.navigateBack()
    }
}

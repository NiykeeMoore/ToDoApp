//
//  TaskListPresenter.swift
//  ToDoApp
//
//  Created by Niykee Moore on 02.02.2025.
//

import UIKit

protocol TaskListPresenterInput: AnyObject {
    func viewWillAppear()
    func checkboxDidTapped(at index: Int)
    func didSelectMenuOption(_ option: ContextMenu, task: TaskEntity, view: UIViewController?)
    func createNewTaskButtonTapped(from view: UIViewController)
    func filterTasks(with inputText: String)
}

final class TaskListPresenterImpl: TaskListPresenterInput,
                                   TaskListInteractorOutput {
    //MARK: - Properties
    weak var view: TaskListView?
    var interactor: TaskListInteractorInput?
    var router: TaskListRouter?
    
    private var filteredTasks: [TaskEntity] = []
    // MARK: - TaskListPresenterInput
    func viewWillAppear() {
        interactor?.fetchTasks()
    }
    
    func checkboxDidTapped(at index: Int) {
        interactor?.toggleTaskCompletion(at: index)
    }
    
    func didSelectMenuOption(_ option: ContextMenu, task: TaskEntity, view: UIViewController?) {
        switch option {
        case .edit:
            guard let view else { return }
            router?.navigateToTaskDetail(for: task, from: view)
            
        case .share:
            let shareContent = task.title
            interactor?.shareTask(with: shareContent)
        case .delete:
            interactor?.taskDeletion(for: task) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success():
                    self.interactor?.fetchTasks()
                case .failure(let error):
                    self.view?.showError(error: error)
                }
            }
        }
    }
    
    func createNewTaskButtonTapped(from view: UIViewController) {
        router?.navigateToTaskDetail(for: nil, from: view)
    }
    
    func filterTasks(with inputText: String) {
        if inputText.isEmpty {
            view?.showTasks(tasks: filteredTasks)
        } else {
            let filtered = filteredTasks.filter { task in
                task.title.lowercased().contains(inputText.lowercased()) ||
                task.description.lowercased().contains(inputText.lowercased())
            }
            view?.showTasks(tasks: filtered)
        }
    }
    
    // MARK: - TaskListInteractorOutput
    func tasksFetched(_ tasks: [TaskEntity]) {
        filteredTasks = tasks
        view?.showTasks(tasks: tasks)
    }
    
    func onError(_ error: Error) {
        view?.showError(error: error)
    }
    
    func shareTask(with shareContent: String) {
        view?.showShareScreen(with: shareContent)
    }
}

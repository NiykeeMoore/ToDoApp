//
//  TaskDetailRouter.swift
//  ToDoApp
//
//  Created by Niykee Moore on 03.02.2025.
//

import UIKit

protocol TaskDetailRouter {
    static func createModule(with task: TaskEntity?) -> UIViewController
    func navigateBack()
}

final class TaskDetailRouterImpl: TaskDetailRouter {
    weak var viewController: UIViewController?
    
    static func createModule(with task: TaskEntity?) -> UIViewController {
        let view = TaskDetailViewController()
        let presenter = TaskDetailPresenterImpl()
        let interactor = TaskDetailInteractorImpl()
        let router = TaskDetailRouterImpl()
        
        view.presenter = presenter          // View -> Presenter
        presenter.view = view               // Presenter -> View
        presenter.interactor = interactor   // Presenter -> Interactor
        presenter.router = router           // Presenter -> Router
        interactor.presenter = presenter    // Interactor -> Presenter
        
        presenter.task = task
        router.viewController = view
        
        return view
    }
    
    func navigateBack() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}

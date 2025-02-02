//
//  TaskListRouter.swift
//  ToDoApp
//
//  Created by Niykee Moore on 02.02.2025.
//

import UIKit

protocol TaskListRouter: AnyObject {
    static func createModule() -> UIViewController
}

final class TaskListRouterImpl: TaskListRouter {
    static func createModule() -> UIViewController {
        let view = TaskListViewController()
        let presenter = TaskListPresenterImpl()
        let networkClient = NetworkClient()
        let todosLoader = TodosLoader(networkClient: networkClient)
        let interactor = TaskListInteractorImpl(todosLoader: todosLoader)
        
        
        view.presenter = presenter             // View -> Presenter
        presenter.view = view                  // Presenter -> View
        presenter.interactor = interactor      // Presenter -> Interactor
        interactor.presenter = presenter      // Interactor -> Presenter
        
        return view
    }
}

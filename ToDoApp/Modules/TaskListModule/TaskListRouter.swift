//
//  TaskListRouter.swift
//  ToDoApp
//
//  Created by Niykee Moore on 02.02.2025.
//

import UIKit

protocol TaskListRouter: AnyObject {
    static func createModule() -> UIViewController
    func navigateToShare(with content: String, from view: UIViewController)
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
    
    func navigateToShare(with content: String, from view: UIViewController) {
        let activityVC = UIActivityViewController(activityItems: [content], applicationActivities: nil)
        if let popoverController = activityVC.popoverPresentationController {
            popoverController.sourceView = view.view
            popoverController.sourceRect = CGRect(x: view.view.bounds.midX,
                                                  y: view.view.bounds.midY,
                                                  width: 0,
                                                  height: 0)
            popoverController.permittedArrowDirections = []
        }
        view.present(activityVC, animated: true, completion: nil)
    }
}

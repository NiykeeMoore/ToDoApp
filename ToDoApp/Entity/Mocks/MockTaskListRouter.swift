//
//  MockTaskListRouter.swift
//  ToDoApp
//
//  Created by Niykee Moore on 05.02.2025.
//

import UIKit

final class MockTaskListRouter: TaskListRouter {
    var didNavigateToDetail = false
    var passedTask: TaskEntity?
    var passedView: UIViewController?
    
    static func createModule() -> UIViewController {
        return UIViewController() // не используется - не важно
    }
    
    func navigateToShare(with content: String, from view: UIViewController) {
        // пустой
    }
    
    func navigateToTaskDetail(for task: TaskEntity?, from view: UIViewController) {
        didNavigateToDetail = true
        passedTask = task
        passedView = view
    }
}

//
//  MockTaskListView.swift
//  ToDoApp
//
//  Created by Niykee Moore on 05.02.2025.
//

import Foundation

final class MockTaskListView: TaskListView {
    var displayedTasks: [TaskEntity] = []
    var error: Error?
    var shareContent: String?
    
    func showTasks(tasks: [TaskEntity]) {
        displayedTasks = tasks
    }
    
    func showError(error: Error) {
        self.error = error
    }
    
    func showShareScreen(with shareContent: String) {
        self.shareContent = shareContent
    }
}

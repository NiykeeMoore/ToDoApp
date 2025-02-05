//
//  TaskEntity.swift
//  ToDoApp
//
//  Created by Niykee Moore on 02.02.2025.
//

import Foundation

struct TaskEntity: Codable {
    let taskId: Int
    let title: String
    let description: String
    let isCompleted: Bool
    let dateCreation: Date
    let userId: Int // никак не используется
    
    func update(newTitle: String) -> Self {
        return TaskEntity(
            taskId: self.taskId,
            title: newTitle,
            description: self.description,
            isCompleted: self.isCompleted,
            dateCreation: self.dateCreation,
            userId: self.userId
        )
    }
    
    func update(newDescription: String) -> Self {
        return TaskEntity(
            taskId: self.taskId,
            title: self.title,
            description: newDescription,
            isCompleted: self.isCompleted,
            dateCreation: self.dateCreation,
            userId: self.userId
        )
    }
    
    func update(isCompleted: Bool) -> Self {
        return TaskEntity(
            taskId: self.taskId,
            title: self.title,
            description: self.description,
            isCompleted: isCompleted,
            dateCreation: self.dateCreation,
            userId: self.userId
        )
    }
}

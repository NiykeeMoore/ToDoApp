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
    var isCompleted: Bool
    let userId: Int // никак не используется
}

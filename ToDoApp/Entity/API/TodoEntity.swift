//
//  TodoEntity.swift
//  ToDoApp
//
//  Created by Niykee Moore on 02.02.2025.
//

import Foundation

struct TodoEntity: Codable {
    let id: Int
    let todo: String
    let completed: Bool
    let userId: Int
}

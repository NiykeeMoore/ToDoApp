//
//  TodosLoader.swift
//  ToDoApp
//
//  Created by Niykee Moore on 02.02.2025.
//

import Foundation

protocol TodosLoading {
    func load(handler: @escaping (Result<[TaskEntity], Error>) -> Void)
}

struct TodosLoader: TodosLoading {
    private let networkClient: NetworkRouting
    
    private var dummyTodos: URL {
        guard let url = URL(string: "https://dummyjson.com/todos") else {
            preconditionFailure("Некорректный URL")
        }
        return url
    }
    
    init(networkClient: NetworkRouting) {
        self.networkClient = networkClient
    }
    
    func load(handler: @escaping (Result<[TaskEntity], any Error>) -> Void) {
        networkClient.fetch(url: dummyTodos) { result in
            switch result {
            case .success(let data):
                do {
                    let decoded = try JSONDecoder().decode(TodosResponse.self, from: data)
                    let tasks = decoded.todos.map { task in
                        TaskEntity(taskId: task.id,
                                   title: task.todo,
                                   description: "YOOOOOOO",
                                   isCompleted: task.completed,
                                   userId: task.userId)
                    }
                    handler(.success(tasks))
                } catch {
                    handler(.failure(error))
                }
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
}

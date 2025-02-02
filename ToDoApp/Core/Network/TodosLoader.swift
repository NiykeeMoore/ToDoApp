//
//  TodosLoader.swift
//  ToDoApp
//
//  Created by Niykee Moore on 02.02.2025.
//

import Foundation

protocol TodosLoading {
    func load(handler: @escaping (Result<TodosResponse, Error>) -> Void)
}

private struct TodosLoader: TodosLoading {
    private let networkClient: NetworkRouting
    
    private var dummyTodos: URL {
        guard let url = URL(string: "https://dummyjson.com/todos") else {
            preconditionFailure("Некорректный URL")
        }
        return url
    }
    
    func load(handler: @escaping (Result<TodosResponse, any Error>) -> Void) {
        networkClient.fetch(url: dummyTodos) { result in
            switch result {
            case .success(let data):
                do {
                    let decoded = try JSONDecoder().decode(TodosResponse.self, from: data)
                    let task = decoded.todos
                    
                    DispatchQueue.main.async {
                        print(task.count)
                    }
                } catch {
                    print("Ошибка декода: \(error.localizedDescription)")
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

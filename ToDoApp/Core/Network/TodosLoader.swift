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
                                   description: getDescription(for: task),
                                   isCompleted: task.completed,
                                   dateCreation: generateRandomDate(),
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
    
    // В api нет данных о дате или описании, поэтому генерим мок
    
    private func getDescription(for task: TodoEntity) -> String {
        let todoDescriptions: [Int: String] = [
            1: "This task encourages you to do something kind for someone special. A small act of kindness can brighten both your day and theirs.",
            2: "Memorize a poem to enrich your mind. Let the rhythm and words inspire you.",
            3: "Watching a classic movie transports you to a different time. Enjoy the timeless storytelling and cinematic art.",
            4: "Watch a documentary to gain new perspectives. Learn from real stories and expand your horizons.",
            5: "Invest in cryptocurrency to explore modern finance. Research the market and make informed decisions.",
            6: "Contribute code or donate to an open-source project. This is a great way to give back to the tech community.",
            7: "Solve a Rubik's cube to challenge your brain. Sharpen your problem-solving skills with this fun puzzle.",
            8: "Bake pastries for yourself and a neighbor. Enjoy the creative process and share the delicious results.",
            9: "Go see a Broadway production and immerse yourself in live theater. Experience the energy and passion on stage.",
            10: "Write a thank you letter to someone influential in your life. Express your gratitude in a heartfelt, personal note.",
            11: "Invite some friends over for a game night. Create a relaxed atmosphere for fun and friendly competition.",
            12: "Have a football scrimmage with friends to boost team spirit. Enjoy physical activity and build lasting memories.",
            13: "Text a friend you haven't talked to in a long time. Reconnect and share a few kind words to brighten their day.",
            14: "Organize your pantry to bring order into your space. A tidy environment can make daily tasks easier.",
            15: "Buy a new house decoration to refresh your home. Choose something that adds a touch of personality and warmth.",
            16: "Plan a vacation you've always wanted to take. Let your imagination run wild and start mapping out your adventure.",
            17: "Clean out your car for a more pleasant drive. A well-maintained car can boost your mood and efficiency.",
            18: "Draw and color a Mandala to find inner calm. Enjoy the meditative process and let your creativity flow.",
            19: "Create a cookbook with your favorite recipes. Capture your culinary adventures in a personal collection.",
            20: "Bake a pie with some friends to share a sweet moment. Enjoy the process and celebrate your teamwork.",
            21: "Create a compost pile to contribute to a greener planet. Turn organic waste into nourishment for your garden.",
            22: "Take a hike at a local park to reconnect with nature. Let the fresh air and scenic views rejuvenate you.",
            23: "Take a class at your local community center that interests you. Learn something new and expand your skill set.",
            24: "Research a topic that interests you to fuel your curiosity. Delve into learning and discover fresh insights.",
            25: "Plan a trip to another country to experience a new culture. Broaden your perspective with exciting travel adventures.",
            26: "Improve your touch typing skills to boost your productivity. Practice consistently and watch your speed increase.",
            27: "Learn Express.js to enhance your web development skills. Embrace this opportunity to build robust applications.",
            28: "Learn calligraphy to add an artistic touch to your writing. Enjoy the process of creating beautiful, handwritten letters.",
            29: "Have a photo session with some friends to capture fun moments. Create lasting memories through creative snapshots.",
            30: "Go to the gym to improve your fitness and energy. Consistent workouts lead to a healthier body and mind."
        ]
        
        guard let description = todoDescriptions[task.id] else { return "Ошибка в определении описания" }
        return description
    }
    
    private func generateRandomDate() -> Date {
        let today = Date()
        guard let threeDaysAgo = Calendar.current.date(byAdding: .day, value: -3, to: today) else {
            return today
        }
        
        let interval = today.timeIntervalSince(threeDaysAgo)
        let randomInterval = TimeInterval(arc4random_uniform(UInt32(interval)))
        return threeDaysAgo.addingTimeInterval(randomInterval)
    }
}

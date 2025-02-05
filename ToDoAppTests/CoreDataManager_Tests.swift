import XCTest
import CoreData
@testable import ToDoApp

final class CoreDataManagerTests: XCTestCase {
    
    var persistentContainer: NSPersistentContainer!
    var coreDataManager: CoreDataManager!
    var taskStore: TaskStore!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        persistentContainer = NSPersistentContainer(name: "ToDoApp")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        persistentContainer.persistentStoreDescriptions = [description]
        
        let loadExpectation = expectation(description: "Загрузка in-memory persistent хранилища")
        persistentContainer.loadPersistentStores { _, error in
            XCTAssertNil(error, "Ошибка загрузки in‑memory хранилища: \(error?.localizedDescription ?? "Неизвестная ошибка")")
            loadExpectation.fulfill()
        }
        waitForExpectations(timeout: 1.0, handler: nil)
        
        coreDataManager = CoreDataManager.shared
        taskStore = TaskStore(coreData: coreDataManager, managedObjectContext: persistentContainer.viewContext)
    }
    
    override func tearDownWithError() throws {
        taskStore = nil
        persistentContainer = nil
        coreDataManager = nil
        try super.tearDownWithError()
    }
    
    func testSaveAndFetchTask() throws {
        let task = TaskEntity(taskId: 1337,
                              title: "Test Task",
                              description: "Test Description",
                              isCompleted: false,
                              dateCreation: Date(),
                              userId: 1)
        
        let saveExpectation = expectation(description: "Сохраняем задачу и фетчим")
        
        taskStore.saveTask(entity: task)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.taskStore.fetchAllTasks { fetchedTasks in
                let foundTask = fetchedTasks.first { $0.taskId == 1337 }
                XCTAssertNotNil(foundTask, "Задача с id 1337 ДОЛЖНА быть найдена в базе")
                saveExpectation.fulfill()
            }
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testRemoveTask() throws {
        let task = TaskEntity(taskId: 1337,
                              title: "Task to Delete",
                              description: "Description",
                              isCompleted: false,
                              dateCreation: Date(),
                              userId: 1)
        
        let saveExpectation = expectation(description: "Сохраняем задачу на удаление")
        taskStore.saveTask(entity: task)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            saveExpectation.fulfill()
        }
        wait(for: [saveExpectation], timeout: 1)
        
        let removeExpectation = expectation(description: "Удаляем задачу")
        taskStore.remove(task: task)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.taskStore.fetchAllTasks { tasks in
                let foundTask = tasks.first { $0.taskId == 1337 }
                XCTAssertNil(foundTask, "Задача с id 1337 НЕ ДОЛЖНА быть в базе после удаления")
                removeExpectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 2, handler: nil)
    }
}

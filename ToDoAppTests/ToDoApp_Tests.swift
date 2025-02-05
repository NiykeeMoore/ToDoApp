//
//  ToDoAppTests.swift
//  ToDoAppTests
//
//  Created by Niykee Moore on 05.02.2025.
//

import XCTest
@testable import ToDoApp

class TaskListPresenterTests: XCTestCase {
    
    var presenter: TaskListPresenterImpl!
    var mockView: MockTaskListView!
    var mockRouter: MockTaskListRouter!
    var mockInteractor: MockTaskListInteractor!
    
    override func setUp() {
        super.setUp()
        presenter = TaskListPresenterImpl()
        mockView = MockTaskListView()
        mockRouter = MockTaskListRouter()
        mockInteractor = MockTaskListInteractor()
        
        presenter.view = mockView
        presenter.router = mockRouter
        presenter.interactor = mockInteractor
    }
    
    override func tearDown() {
        presenter = nil
        mockView = nil
        mockRouter = nil
        mockInteractor = nil
        super.tearDown()
    }
    
    func testTasksFetchedUpdatesView() {
        let newTask = TaskEntity(taskId: 2,
                                 title: "New Task",
                                 description: "New Description",
                                 isCompleted: false,
                                 dateCreation: Date(),
                                 userId: 1)
        presenter.tasksFetched([newTask])
        XCTAssertEqual(mockView.displayedTasks.count, 1)
        XCTAssertEqual(mockView.displayedTasks.first?.title, "New Task")
    }
    
    func testDidSelectEditOptionNavigatesToDetail() {
        let sampleTask = TaskEntity(taskId: 1,
                                    title: "Edit Task",
                                    description: "Edit Description",
                                    isCompleted: false,
                                    dateCreation: Date(),
                                    userId: 1)
        let dummyView = UIViewController()
        presenter.didSelectMenuOption(.edit, task: sampleTask, view: dummyView)
        XCTAssertTrue(mockRouter.didNavigateToDetail)
        XCTAssertEqual(mockRouter.passedTask?.title, "Edit Task")
    }
    
    func testDidSelectShareOptionCallsInteractor() {
        let sampleTask = TaskEntity(taskId: 1,
                                    title: "Share Task",
                                    description: "Description",
                                    isCompleted: false,
                                    dateCreation: Date(),
                                    userId: 1)
        presenter.didSelectMenuOption(.share, task: sampleTask, view: UIViewController())
        XCTAssertTrue(mockInteractor.didShareTask)
    }
    
    func testDidSelectDeleteOptionCallsInteractor() {
        let sampleTask = TaskEntity(taskId: 1,
                                    title: "Delete Task",
                                    description: "Description",
                                    isCompleted: false,
                                    dateCreation: Date(),
                                    userId: 1)
        presenter.didSelectMenuOption(.delete, task: sampleTask, view: nil)
        XCTAssertTrue(mockInteractor.didDeleteTask)
    }
}

// MARK: - Тесты TaskEntity

class TaskEntityTests: XCTestCase {
    
    func testUpdateTitle() {
        let original = TaskEntity(taskId: 1,
                                  title: "Old Title",
                                  description: "Description",
                                  isCompleted: false,
                                  dateCreation: Date(),
                                  userId: 1)
        let updated = original.update(newTitle: "New Title")
        XCTAssertEqual(updated.title, "New Title")
        XCTAssertEqual(updated.description, original.description)
    }
    
    func testUpdateDescription() {
        let original = TaskEntity(taskId: 1,
                                  title: "Title",
                                  description: "Old Description",
                                  isCompleted: false,
                                  dateCreation: Date(),
                                  userId: 1)
        let updated = original.update(newDescription: "New Description")
        XCTAssertEqual(updated.description, "New Description")
        XCTAssertEqual(updated.title, original.title)
    }
    
    func testUpdateIsCompleted() {
        let original = TaskEntity(taskId: 1,
                                  title: "Title",
                                  description: "Description",
                                  isCompleted: false,
                                  dateCreation: Date(),
                                  userId: 1)
        let updated = original.update(isCompleted: true)
        XCTAssertTrue(updated.isCompleted)
    }
}

//
//  TaskListViewController.swift
//  ToDoApp
//
//  Created by Niykee Moore on 03.02.2025.
//

import UIKit

protocol TaskDetailView: AnyObject {
    func showTaskDetail(task: TaskEntity)
    func showError(error: Error)
}

final class TaskDetailViewController: UIViewController,
                                      TaskDetailView {
    
    // MARK: - Properties
    var presenter: TaskDetailPresenterInput?
    var task: TaskEntity?
    
    private lazy var taskTitleTextField: UITextField = {
        let textField = UITextField()
        textField.font = .boldSystemFont(ofSize: 34)
        textField.textColor = .ccWhite
        textField.placeholder = "Тема todo"
        return textField
    }()
    
    private lazy var taskDateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .ccWhite50Percent
        return label
    }()
    
    private lazy var taskDescriptionTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.textColor = .ccWhite
        textView.font = .systemFont(ofSize: 16)
        return textView
    }()
    
    private lazy var headStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [taskTitleTextField, taskDateLabel])
        stack.axis = .vertical
        stack.backgroundColor = .clear
        stack.alignment = .leading
        stack.spacing = 8
        return stack
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        configureUI()
        configureConstraints()
        
        configureNavigationBar()
        presenter?.viewDidLoad()
    }
    
    // MARK: - UI Setup
    private func configureUI() {
        addSubviews()
        configureConstraints()
    }
    
    private func addSubviews() {
        [headStackView, taskDescriptionTextView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func configureNavigationBar() {
        let backButton = UIBarButtonItem(title: "Назад",
                                         style: .plain,
                                         target: self,
                                         action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
    }
    
    // MARK: - Constraints
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            headStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            headStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            headStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            taskDescriptionTextView.topAnchor.constraint(equalTo: headStackView.bottomAnchor, constant: 16),
            taskDescriptionTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            taskDescriptionTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            taskDescriptionTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    // MARK: - TasklistView
    func showTaskDetail(task: TaskEntity) {
        self.task = task
        
        taskTitleTextField.text = task.title
        taskDateLabel.text = shortDateFormat(with: task.dateCreation)
        taskDescriptionTextView.text = task.description
    }
    
    func showError(error: any Error) {
        let alert = UIAlertController(title: "Ошибка",
                                      message: error.localizedDescription,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    // MARK: - Private Helper methods
    private func shortDateFormat(with date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: date)
    }
    
    @objc private func backButtonTapped() {
        guard let currentTask = task,
              let newTitle = taskTitleTextField.text, !newTitle.isEmpty,
              let newDescription = taskDescriptionTextView.text else {
            presenter?.didTapExit(save: nil)
            return
        }
        
        if currentTask.title == newTitle && currentTask.description == newDescription {
            presenter?.didTapExit(save: nil)
        } else {
            let updatedTask = currentTask.update(newTitle: newTitle)
                .update(newDescription: newDescription)
            presenter?.didTapExit(save: updatedTask)
        }
    }
}

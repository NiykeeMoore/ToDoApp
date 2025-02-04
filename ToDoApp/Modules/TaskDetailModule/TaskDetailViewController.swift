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
    
    private lazy var taskTitleTextField: UITextField = {
        let textField = UITextField()
        textField.font = .boldSystemFont(ofSize: 34)
        textField.textColor = .ccWhite
        textField.text = "lolkekechebutertn"
        return textField
    }()
    
    private lazy var taskDateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .ccWhite50Percent
        label.text = "25.52.52"
        return label
    }()
    
    private lazy var taskDescriptionTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.textColor = .ccWhite
        textView.text = "asdadasdasdasdasdasdasd"
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
        
        presenter?.viewDidLoad()
    }
    
    // MARK: - UI Setup
    func configureUI() {
        addSubviews()
        configureConstraints()
    }
    
    func addSubviews() {
        [headStackView, taskDescriptionTextView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    // MARK: - Constraints
    func configureConstraints() {
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
        taskTitleTextField.text = task.title
        taskDateLabel.text = task.dateCreation.description
        taskDescriptionTextView.text = task.description
    }
    
    func showError(error: any Error) {
        let alert = UIAlertController(title: "Ошибка",
                                      message: error.localizedDescription,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

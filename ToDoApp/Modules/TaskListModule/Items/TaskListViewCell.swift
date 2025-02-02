//
//  TaskListViewCell.swift
//  ToDoApp
//
//  Created by Niykee Moore on 01.02.2025.
//

import UIKit

final class TaskListViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let reuseIdentifier = "TaskListCell"
    
    private lazy var checkbox: CheckBox = {
        let checkbox = CheckBox()
        return checkbox
    }()
    
    private lazy var spacer: UIView = {
        let view = UIView()
        view.setContentHuggingPriority(.defaultLow, for: .vertical)
        return view
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [checkbox, spacer])
        stack.axis = .vertical
        stack.distribution = .fill
        stack.backgroundColor = .clear
        return stack
    }()
    
    private lazy var taskTitle: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    private lazy var taskDescription: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.lineBreakMode = .byTruncatingTail
        label.textColor = .white
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var taskCreationDate: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .ccWhite50Percent
        return label
    }()
    
    private lazy var taskStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [taskTitle, taskDescription, taskCreationDate])
        stack.backgroundColor = .clear
        stack.alignment = .leading
        stack.axis = .vertical
        stack.spacing = 6
        return stack
    }()
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        [checkbox, spacer, taskTitle, taskDescription, taskCreationDate].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [buttonStackView, taskStackView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
    }
    
    // MARK: - Constraints
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            buttonStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            buttonStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            buttonStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            taskStackView.topAnchor.constraint(equalTo: buttonStackView.topAnchor),
            taskStackView.leadingAnchor.constraint(equalTo: buttonStackView.trailingAnchor, constant: 8),
            taskStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            taskStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
    
    // MARK: - Public Helper Methods
    
    func renderCell(title: String, description: String, date: Date, done: Bool) {
        taskTitle.text = title
        taskDescription.text = description
        taskCreationDate.text = date.description
        checkbox.setChecked(done)
    }
}

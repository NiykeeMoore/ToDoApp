//
//  ViewController.swift
//  ToDoApp
//
//  Цвета определены в Assets.xcassets: .cc* читать, как custom color
//
//  Created by Niykee Moore on 01.02.2025.

import UIKit

protocol TaskListView: AnyObject {
    func showTasks(tasks: [TaskEntity])
    func showError(error: Error)
    func showShareScreen(with shareContent: String)
}

final class TaskListViewController: UIViewController,
                                    UITableViewDataSource, UITableViewDelegate,
                                    UISearchResultsUpdating,
                                    TaskListView,
                                    CheckboxDelegate {
    
    
    
    // MARK: - Properties
    
    var presenter: TaskListPresenterInput?
    private var tasks: [TaskEntity] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.taskList.reloadData()
                self.countOfTasks = self.tasks.count
                self.configureToolbar()
            }
        }
    }
    private var filteredTasks: [TaskEntity] = []
    
    private var countOfTasks: Int = 0
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.tintColor = .ccWhite
        return searchController
    }()
    
    private lazy var taskList: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TaskListViewCell.self, forCellReuseIdentifier: TaskListViewCell.reuseIdentifier)
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        configureUI()
        configureConstraints()
        
        definesPresentationContext = true // обеспечивает представление UISearchController в границах этого VC
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewWillAppear()
    }
    
    // MARK: - UI Setup
    
    private func configureUI() {
        addSubviews()
        configureNavigationBar()
        configureSearchController()
        configureToolbar()
    }
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Задачи"
    }
    
    private func configureSearchController() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.searchTextField.textColor = .ccWhite
    }
    
    private func configureToolbar() {
        let toolBar = ToolbarConfigurator.createToolbarView(title: "\(countOfTasks) задач",
                                                            buttonImage: "square.and.pencil",
                                                            buttonTarget: self,
                                                            buttonAction: #selector(createNoteButtonTapped),
                                                            tintColor: .ccYellow)
        ToolbarConfigurator.configureToolbar(for: navigationController, toolbarItems: toolBar)
    }
    
    private func addSubviews() {
        [taskList].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    // MARK: - Constraints
    
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            taskList.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            taskList.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            taskList.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            taskList.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    // MARK: - UISearchResultsUpdating
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let inputText = searchController.searchBar.text else { return }
        presenter?.filterTasks(with: inputText)
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskListViewCell.reuseIdentifier,
                                                       for: indexPath) as? TaskListViewCell else {
            return UITableViewCell()
        }
        
        cell.checkbox.checkboxDelegate = self
        
        let task = tasks[indexPath.row]
        cell.renderCell(title: task.title,
                        description: task.description,
                        date: customDateFormat(with: task.dateCreation),
                        done: task.isCompleted)
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    //MARK: - TaskListView
    func showTasks(tasks: [TaskEntity]) {
        self.tasks = tasks
    }
    
    func showError(error: any Error) {
        let alert = UIAlertController(title: "Ошибка",
                                      message: error.localizedDescription,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func checkboxTapped(in cell: TaskListViewCell) {
        guard let indexPath = taskList.indexPath(for: cell) else { return }
        presenter?.checkboxDidTapped(at: indexPath.row)
    }
    
    func showShareScreen(with shareContent: String) {
        let activityVC = UIActivityViewController(activityItems: [shareContent],
                                                  applicationActivities: nil)
        if let popoverController = activityVC.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX,
                                                  y: self.view.bounds.midY,
                                                  width: 0,
                                                  height: 0)
            popoverController.permittedArrowDirections = []
        }
        self.present(activityVC, animated: true, completion: nil)
    }
    
    //MARK: - contextMenuConfigurationForRowAt
    
    func tableView(_ tableView: UITableView,
                   contextMenuConfigurationForRowAt indexPath: IndexPath,
                   point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: indexPath as NSCopying,
                                          previewProvider: nil) { _ in
            
            let edit = UIAction(title: ContextMenu.edit.rawValue,
                                image: UIImage(systemName: "square.and.pencil")) { [weak self] _ in
                guard let self else { return }
                
                self.presenter?.didSelectMenuOption(.edit,
                                                    task: tasks[indexPath.row],
                                                    view: self)
            }
            let share = UIAction(title: ContextMenu.share.rawValue,
                                 image: UIImage(systemName: "square.and.arrow.up")) { [weak self] _ in
                guard let self else { return }
                
                self.presenter?.didSelectMenuOption(.share,
                                                    task: tasks[indexPath.row],
                                                    view: self)
            }
            let delete = UIAction(title: ContextMenu.delete.rawValue,
                                  image: UIImage(systemName: "trash"),
                                  attributes: [.destructive]) { [weak self] _ in
                guard let self else { return }
                
                self.presenter?.didSelectMenuOption(.delete,
                                                    task: tasks[indexPath.row],
                                                    view: nil)
            }
            
            return UIMenu(title: "", children: [edit, share, delete])
        }
    }
    
    func tableView(_ tableView: UITableView, previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        return makeTargetedPreview(for: configuration)
    }
    
    func tableView(_ tableView: UITableView, previewForDismissingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        return makeTargetedPreview(for: configuration)
    }
    
    private func makeTargetedPreview(for configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        guard let indexPath = configuration.identifier as? IndexPath else { return nil }
        guard let cell = taskList.cellForRow(at: indexPath) as? TaskListViewCell else { return nil }
        
        let parameters = UIPreviewParameters()
        parameters.backgroundColor = .ccGray
        parameters.visiblePath = UIBezierPath(rect: cell.taskStackView.bounds)
        
        return UITargetedPreview(view: cell.taskStackView, parameters: parameters)
    }
    
    // MARK: - Private Helper Methods
    
    private func customDateFormat(with date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: date)
    }
    
    //MARK: - Action's
    @objc private func createNoteButtonTapped() {
        presenter?.createNewTaskButtonTapped(from: self)
    }
}

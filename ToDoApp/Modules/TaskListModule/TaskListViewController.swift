//
//  ViewController.swift
//  ToDoApp
//
//  Цвета определены в Assets.xcassets: .cc* читать, как custom color
//
//  Created by Niykee Moore on 01.02.2025.

import UIKit

final class TaskListViewController: UIViewController,
                              UITableViewDataSource, UITableViewDelegate,
                              UISearchResultsUpdating {
    // MARK: - Properties
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
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .ccBlack
        appearance.titleTextAttributes = [.foregroundColor: UIColor.ccWhite]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.ccWhite]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func configureSearchController() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.searchTextField.textColor = .ccWhite
    }
    
    private func configureToolbar() {
        let toolBar = ToolbarConfigurator.createToolbarView(title: "7 задач",
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
        guard let _ = searchController.searchBar.text?.lowercased() else { return }
        print("4e-to iwem")
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 32
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskListViewCell.reuseIdentifier,
                                                       for: indexPath) as? TaskListViewCell else {
            return UITableViewCell()
        }
        
        cell.renderCell(title: "TEST CASE OF TITLE", description: "Make some test for description label if its goona be okay make it deep. However this text is a random fill for cell like a test", date: Date(), done: Bool.random())
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    //MARK: - Action's
    @objc private func createNoteButtonTapped() {
        print("tapped")
    }
}

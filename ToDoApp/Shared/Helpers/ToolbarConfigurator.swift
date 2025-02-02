//
//  ToolbarConfigurator.swift
//  ToDoApp
//
//  Created by Niykee Moore on 02.02.2025.
//


import UIKit

final class ToolbarConfigurator {
    static func createToolbarView(title: String,
                                  buttonImage icon: String,
                                  buttonTarget: Any?,
                                  buttonAction: Selector,
                                  tintColor: UIColor) -> [UIBarButtonItem] {
        let spacer: UIBarButtonItem = .init(systemItem: .flexibleSpace)
        
        let label = UILabel()
        label.text = title
        label.textColor = .ccWhite
        
        let counterContainer: UIBarButtonItem = .init(customView: label)
        
        let newTask: UIBarButtonItem = .init(image: UIImage(systemName: "square.and.pencil"),
                                             style: .done,
                                             target: buttonTarget,
                                             action: buttonAction)
        return [spacer, counterContainer, spacer, newTask]
    }
    
    static func configureToolbar(for navigationController: UINavigationController?, toolbarItems: [UIBarButtonItem]) {
        guard let navController = navigationController else { return }
        navController.topViewController?.toolbarItems = toolbarItems
        navController.toolbar.isUserInteractionEnabled = true
        navController.toolbar.barTintColor = .ccGray
        navController.toolbar.tintColor = .ccYellow
        navController.setToolbarHidden(false, animated: false)
    }
}

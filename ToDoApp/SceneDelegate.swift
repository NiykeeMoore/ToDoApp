//
//  SceneDelegate.swift
//  ToDoApp
//
//  Created by Niykee Moore on 01.02.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .ccBlack
        appearance.titleTextAttributes = [.foregroundColor: UIColor.ccWhite]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.ccWhite]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        
        let rootVC = TaskListRouterImpl.createModule()
        window.rootViewController = UINavigationController(rootViewController: rootVC)
        
        self.window = window
        window.makeKeyAndVisible()
    }
}


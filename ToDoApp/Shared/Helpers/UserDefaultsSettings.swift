//
//  UserDefaultsSettings.swift
//  ToDoApp
//
//  Created by Niykee Moore on 03.02.2025.
//

import Foundation

final class UserDefaultsSettings {
    static let shared = UserDefaultsSettings()
    private let userDefaults = UserDefaults.standard
    
    private enum Keys: String {
        case firstLaunch
    }
    
    private init() {}
    
    var hasLaunchedBefore: Bool {
        get {
            userDefaults.bool(forKey: Keys.firstLaunch.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.firstLaunch.rawValue)
        }
    }
}

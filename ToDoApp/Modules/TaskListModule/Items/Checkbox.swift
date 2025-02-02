//
//  Checkbox.swift
//  ToDoApp
//
//  Created by Niykee Moore on 01.02.2025.
//

import UIKit

final class CheckBox: UIButton {
    
    // MARK: - Public Properties
    
    var onTap: (() -> Void)?
    
    // MARK: - Private Properties
    
    private lazy var image = UIImage()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        tintColor = .ccYellow
        addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    func setChecked(_ checked: Bool) {
        let config = UIImage.SymbolConfiguration(pointSize: 24)
        let imageName = checked ? "checkmark.circle" : "circle"
        let image = UIImage(systemName: imageName, withConfiguration: config)
        setImage(image, for: .normal)
    }
    
    // MARK: - Actions
    
    @objc func buttonClicked(sender: UIButton) {
        print("sasdf")
        onTap?()
    }
}

//
//  Entity+CoreDataProperties.swift
//  ToDoApp
//
//  Created by Niykee Moore on 03.02.2025.
//
//

import Foundation
import CoreData


extension Entity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entity> {
        return NSFetchRequest<Entity>(entityName: "Entity")
    }

    @NSManaged public var id: String?
    @NSManaged public var title: String?
    @NSManaged public var taskDescription: String?
    @NSManaged public var isCompleted: Bool
    @NSManaged public var dateCreation: Date?
    @NSManaged public var userId: Int32

}

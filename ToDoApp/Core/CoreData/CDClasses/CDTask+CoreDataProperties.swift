//
//  CDTask+CoreDataProperties.swift
//  ToDoApp
//
//  Created by Niykee Moore on 03.02.2025.
//
//

import Foundation
import CoreData


extension CDTask {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDTask> {
        return NSFetchRequest<CDTask>(entityName: "CDTask")
    }

    @NSManaged public var id: Int64
    @NSManaged public var title: String?
    @NSManaged public var taskDescription: String?
    @NSManaged public var isCompleted: Bool
    @NSManaged public var dateCreation: Date?
    @NSManaged public var userId: Int64

}

extension CDTask : Identifiable {

}

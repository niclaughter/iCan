//
//  Assignment.swift
//  iCan
//
//  Created by Nicholas Laughter on 6/16/16.
//  Copyright © 2016 Nicholas Laughter. All rights reserved.
//

import Foundation
import CoreData


class Assignment: NSManagedObject {
    
    static let assignmentKey = "Assignment"
    static let titleKey = "title"

    convenience init(title: String, notes: String? = nil, imageData: NSData? = nil, isComplete: Bool = false, student: Student, context: NSManagedObjectContext = Stack.sharedStack.managedObjectContext) {
        guard let entity = NSEntityDescription.entityForName(Assignment.assignmentKey, inManagedObjectContext: context) else { fatalError("Could not get entity") }
        self.init(entity: entity, insertIntoManagedObjectContext: context)
        
        self.title = title
        self.notes = notes
        self.imageData = imageData
        self.student = student
        self.isComplete = false
    }
}
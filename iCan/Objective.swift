//
//  Objective.swift
//  iCan
//
//  Created by Nicholas Laughter on 6/20/16.
//  Copyright © 2016 Nicholas Laughter. All rights reserved.
//

import Foundation
import CoreData


class Objective: NSManagedObject {
    
    static let typeKey = "Objective"
    static let studentCanKey = "studentCan"
    
    convenience init(studentCan: String, notes: String?, evidence: NSOrderedSet = [], context: NSManagedObjectContext = Stack.sharedStack.managedObjectContext) {
        guard let entity = NSEntityDescription.entityForName(Objective.typeKey, inManagedObjectContext: context) else { fatalError("Failed to create entity from moc") }
        self.init(entity: entity, insertIntoManagedObjectContext: context)
        
        self.studentCan = studentCan
        self.notes = notes
        self.evidence = evidence
    }
}

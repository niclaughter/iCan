//
//  Student.swift
//  iCan
//
//  Created by Nicholas Laughter on 6/20/16.
//  Copyright © 2016 Nicholas Laughter. All rights reserved.
//

import Foundation
import CoreData


class Student: NSManagedObject {
    
    static let typeKey = "Student"
    static let nameKey = "name"
    
    convenience init(name: String, evidence: NSOrderedSet = [], context: NSManagedObjectContext = Stack.sharedStack.managedObjectContext) {
        guard let entity = NSEntityDescription.entityForName(Student.typeKey, inManagedObjectContext: context) else { fatalError("Could not create entity from moc") }
        self.init(entity: entity, insertIntoManagedObjectContext: context)
        
        self.name = name
        self.evidence = evidence
    }
    
    var numberPassed: Int {
        guard let evidenceArray = self.evidence.array as? [Evidence] else { return 0 }
        let passedArray = evidenceArray.filter { $0.competencyRating.intValue > 1 }
        return passedArray.count
    }
}

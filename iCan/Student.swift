//
//  Student.swift
//  iCan
//
//  Created by Nicholas Laughter on 6/16/16.
//  Copyright © 2016 Nicholas Laughter. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Student: NSManagedObject {

    static let studentKey = "Student"
    static let nameKey = "name"
    static let classroomNameKey = "classroomName"
    
    convenience init(name: String, classroomName: String? = nil, parentsNames: String? = nil, contact: String? = nil, assignments: NSSet? = nil, imageData: NSData? = nil, context: NSManagedObjectContext = Stack.sharedStack.managedObjectContext) {
        guard let entity = NSEntityDescription.entityForName(Student.studentKey, inManagedObjectContext: context) else { fatalError("Could not get context") }
        self.init(entity: entity, insertIntoManagedObjectContext: context)
        
        self.name = name
        self.classroomName = classroomName
        self.parentsNames = parentsNames
        self.contact = contact
        self.assignments = assignments
        self.imageData = imageData
    }
    
    var photo: UIImage? {
        guard let photoData = self.imageData else { return nil }
        return UIImage(data: photoData)
    }
}
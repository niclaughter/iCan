//
//  Evidence.swift
//  iCan
//
//  Created by Nicholas Laughter on 6/20/16.
//  Copyright © 2016 Nicholas Laughter. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Evidence: NSManagedObject {

    static let typeKey = "Evidence"
    
    convenience init(imageData: NSData, competencyRating: NSNumber?, student: Student, objective: Objective, context: NSManagedObjectContext = Stack.sharedStack.managedObjectContext) {
        guard let entity = NSEntityDescription.entityForName(Evidence.typeKey, inManagedObjectContext: context) else { fatalError("Failed to create entity from moc") }
        self.init(entity: entity, insertIntoManagedObjectContext: context)
        
        self.imageData = imageData
        self.competencyRating = competencyRating
        self.student = student
        self.objective = objective
    }
    
    var photo: UIImage? {
        return UIImage(data: imageData)
    }
}

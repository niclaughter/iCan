//
//  Student+CoreDataProperties.swift
//  iCan
//
//  Created by Nicholas Laughter on 6/16/16.
//  Copyright © 2016 Nicholas Laughter. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Student {

    @NSManaged var classroomName: String?
    @NSManaged var contact: String?
    @NSManaged var name: String
    @NSManaged var parentsNames: String?
    @NSManaged var imageData: NSData?
    @NSManaged var assignments: NSSet?

}

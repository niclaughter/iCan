//
//  Assignment+CoreDataProperties.swift
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

extension Assignment {

    @NSManaged var imageData: NSData?
    @NSManaged var notes: String?
    @NSManaged var title: String
    @NSManaged var isComplete: NSNumber
    @NSManaged var student: Student

}

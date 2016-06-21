//
//  Objective+CoreDataProperties.swift
//  iCan
//
//  Created by Nicholas Laughter on 6/20/16.
//  Copyright © 2016 Nicholas Laughter. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Objective {

    @NSManaged var studentCan: String
    @NSManaged var notes: String?
    @NSManaged var evidence: NSSet

}

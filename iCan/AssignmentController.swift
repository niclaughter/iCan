//
//  AssignmentController.swift
//  iCan
//
//  Created by Nicholas Laughter on 6/16/16.
//  Copyright © 2016 Nicholas Laughter. All rights reserved.
//

import Foundation
import CoreData

class AssignmentController {
    
    static let sharedAssignmentController = AssignmentController()
    let fetchedResultsController: NSFetchedResultsController
    
    init() {
        let moc = Stack.sharedStack.managedObjectContext
        let request = NSFetchRequest(entityName: Assignment.assignmentKey)
        let sortDescriptor1 = NSSortDescriptor(key: Assignment.titleKey, ascending: true)
        request.sortDescriptors = [sortDescriptor1]
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        _ = try? fetchedResultsController.performFetch()
    }
    
    // MARK: - Controller Methods
    
    func addAssignment(title: String, student: Student) {
        _ = Assignment(title: title, student: student)
        saveToPersistentStore()
    }
    
    func deleteAssignment(assignment: Assignment) {
        assignment.managedObjectContext?.deleteObject(assignment)
        saveToPersistentStore()
    }
    
    func isCompleteSet(assignment: Assignment, isComplete: Bool) {
        assignment.isComplete = isComplete
    }
    
    func saveToPersistentStore() {
        _ = try? Stack.sharedStack.managedObjectContext.save()
    }
}
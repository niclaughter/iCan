//
//  StudentController.swift
//  iCan
//
//  Created by Nicholas Laughter on 6/16/16.
//  Copyright © 2016 Nicholas Laughter. All rights reserved.
//

import Foundation
import CoreData

class StudentController {
    
    static let sharedStudentController = StudentController()
    let fetchedResultsController: NSFetchedResultsController
    
    init() {
        let moc = Stack.sharedStack.managedObjectContext
        let request = NSFetchRequest(entityName: Student.studentKey)
        let sortDescriptor1 = NSSortDescriptor(key: Student.nameKey, ascending: true)
        request.sortDescriptors = [sortDescriptor1]
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: moc, sectionNameKeyPath: Student.nameKey, cacheName: nil)
        _ = try? fetchedResultsController.performFetch()
    }
    
    // MARK: - Controller Methods
    
    func addStudent(name: String) {
        _ = Student(name: name)
        saveToPersistentStore()
    }
    
    func deleteStudent(student: Student) {
        student.managedObjectContext?.deleteObject(student)
        saveToPersistentStore()
    }
    
    func updateStudent(student: Student, name: String, classroomName: String? = nil, parentsNames: String? = nil, contact: String? = nil, assignments: NSSet? = nil) {
        student.name = name
        student.classroomName = classroomName
        student.parentsNames = parentsNames
        student.contact = contact
        student.assignments = assignments
        saveToPersistentStore()
    }
    
    func saveToPersistentStore() {
        _ = try? Stack.sharedStack.managedObjectContext.save()
    }
}
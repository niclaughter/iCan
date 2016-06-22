//
//  StudentController.swift
//  iCan
//
//  Created by Nicholas Laughter on 6/20/16.
//  Copyright © 2016 Nicholas Laughter. All rights reserved.
//

import Foundation
import CoreData

class StudentController {
    
    static let shared = StudentController()
    
    var students: [Student] {
        let fetchRequest = NSFetchRequest(entityName: Student.typeKey)
        let sortDescriptor = NSSortDescriptor(key: Student.nameKey, ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let results = (try? Stack.sharedStack.managedObjectContext.executeFetchRequest(fetchRequest)) as? [Student] ?? []
        return results
    }
    
    func createStudent(name: String) {
        _ = Student(name: name)
        saveToPersistentStore()
    }
    
    func updateStudent(student: Student, name: String) {
        student.name = name
        saveToPersistentStore()
    }
    
    func deleteStudent(student: Student) {
        student.managedObjectContext?.deleteObject(student)
        saveToPersistentStore()
    }
    
    func saveToPersistentStore() {
        do {
            try Stack.sharedStack.managedObjectContext.save()
        } catch {
            print("Could not save in StudentController")
        }
    }
}
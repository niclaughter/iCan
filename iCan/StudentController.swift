//
//  StudentController.swift
//  iCan
//
//  Created by Nicholas Laughter on 6/20/16.
//  Copyright © 2016 Nicholas Laughter. All rights reserved.
//

import Foundation

class StudentController {
    
    static let shared = StudentController()
    
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
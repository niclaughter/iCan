//
//  ObjectiveController.swift
//  iCan
//
//  Created by Nicholas Laughter on 6/20/16.
//  Copyright © 2016 Nicholas Laughter. All rights reserved.
//

import Foundation

class ObjectiveController {
    
    static let shared = ObjectiveController()
    
    func createObjective(studentCan: String) {
        _ = Objective(studentCan: studentCan, notes: "Optional notes for your objective")
        saveToPersistentStore()
    }
    
    func updateObjective(objective: Objective, studentCan: String, notes: String?) {
        objective.studentCan = studentCan
        objective.notes = notes
        saveToPersistentStore()
    }
    
    func deleteObjective(objective: Objective) {
        objective.managedObjectContext?.deleteObject(objective)
        saveToPersistentStore()
    }
    
    func saveToPersistentStore() {
        do {
            try Stack.sharedStack.managedObjectContext.save()
        } catch {
            print("Could not save in ObjectiveController")
        }
    }
}
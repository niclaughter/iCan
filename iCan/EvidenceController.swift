//
//  EvidenceController.swift
//  iCan
//
//  Created by Nicholas Laughter on 6/20/16.
//  Copyright © 2016 Nicholas Laughter. All rights reserved.
//

import Foundation

class EvidenceController {
    
    static let shared = EvidenceController()
    
    func createEvidence(imageData: NSData, competencyRating: NSNumber?, student: Student, objective: Objective) {
        _ = Evidence(imageData: imageData, competencyRating: competencyRating, student: student, objective: objective)
        saveToPersistentStore()
    }
    
    func updateEvidence(evidence: Evidence, imageData: NSData, competencyRating: NSNumber?) {
        evidence.imageData = imageData
        evidence.competencyRating = competencyRating
        saveToPersistentStore()
    }
    
    func deleteEvidence(evidence: Evidence) {
        evidence.managedObjectContext?.deleteObject(evidence)
        saveToPersistentStore()
    }
    
    func saveToPersistentStore() {
        do {
            try Stack.sharedStack.managedObjectContext.save()
        } catch {
            print("Could not save in EvidenceController")
        }
    }
}
//
//  ObjectiveDetailViewController.swift
//  iCan
//
//  Created by Nicholas Laughter on 6/20/16.
//  Copyright © 2016 Nicholas Laughter. All rights reserved.
//

import UIKit

class ObjectiveDetailViewController: UIViewController, UITextFieldDelegate {
    
    var objective: Objective?
    @IBOutlet weak var objectiveTitleTextField: UITextField!
    @IBOutlet weak var notesTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let objective = objective else { return }
        objectiveTitleTextField.text = objective.studentCan
        notesTextView.text = objective.notes
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        guard let objective = objective,
        objectiveTitleText = objectiveTitleTextField.text else { return false }
        ObjectiveController.shared.updateObjective(objective, studentCan: objectiveTitleText, notes: notesTextView.text)
        return true
    }
    
    // MARK: - IBAction
    
    @IBAction func addEvidenceButtonTapped(sender: AnyObject) {
        
    }
    
    @IBAction func saveButtonTapped(sender: AnyObject) {
    }

    @IBAction func clearButtonTapped(sender: AnyObject) {
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let destinationVC = segue.destinationViewController as? StudentListTableViewController else { return }
        destinationVC.addEvidence = true
        destinationVC.objective = objective
    }
}

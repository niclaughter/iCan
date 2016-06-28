//
//  ObjectiveDetailViewController.swift
//  iCan
//
//  Created by Nicholas Laughter on 6/20/16.
//  Copyright © 2016 Nicholas Laughter. All rights reserved.
//

import UIKit

class ObjectiveDetailViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    var objective: Objective?
    @IBOutlet weak var objectiveTitleTextField: UITextField!
    @IBOutlet weak var notesTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let objective = objective else { return }
        updateWithObjective(objective)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if let titleText = objectiveTitleTextField.text,
            objective = objective {
            ObjectiveController.shared.updateObjective(objective, studentCan: titleText, notes: notesTextView.text)
        }
        resignFirstResponder()
        return true
    }
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        notesTextView.text = nil
        return true
    }
    
    // MARK: - IBAction
    
    @IBAction func saveButtonTapped(sender: AnyObject) {
        guard let objective = objective,
            studentCan = objectiveTitleTextField.text else { return }
        ObjectiveController.shared.updateObjective(objective, studentCan: studentCan, notes: notesTextView.text)
    }
    
    @IBAction func clearButtonTapped(sender: AnyObject) {
        presentClearAlertController(sender)
    }
    
    func updateWithObjective(objective: Objective) {
        objectiveTitleTextField.text = objective.studentCan
        notesTextView.text = objective.notes
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let destinationVC = segue.destinationViewController as? StudentListTableViewController else { return }
        destinationVC.addEvidence = true
        destinationVC.objective = objective
    }
    
    // MARK: - AlertController
    
    func presentClearAlertController(sender: AnyObject) {
        let alert = UIAlertController(title: "Clear info?", message: "Are you sure you'd like to clear this info?", preferredStyle: .Alert)
        if let popover = alert.popoverPresentationController,
            sender = sender as? UIButton {
            popover.sourceView = sender
            popover.sourceRect = sender.bounds
            popover.permittedArrowDirections = UIPopoverArrowDirection.Any
        }
        let yesAction = UIAlertAction(title: "Clear", style: .Destructive) { (_) in
            self.objectiveTitleTextField.text = ""
            self.notesTextView.text = ""
            guard let objective = self.objective else { return }
            ObjectiveController.shared.deleteObjective(objective)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
        alert.addAction(yesAction)
        alert.addAction(cancelAction)
        presentViewController(alert, animated: true, completion: nil)
    }
}

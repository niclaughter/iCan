//
//  StudentListTableViewController.swift
//  iCan
//
//  Created by Nicholas Laughter on 6/20/16.
//  Copyright © 2016 Nicholas Laughter. All rights reserved.
//

import UIKit
import CoreData

class StudentListTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        addEvidenceStudentListDelegate?.addEvidence = false
    }
    
    var fetchedResultsController: NSFetchedResultsController?
    var addEvidenceStudentListDelegate: AddEvidenceSegueDelegate?
    var objective: Objective?
    
    // MARK: - IBAction
    
    @IBAction func addStudentButtonTapped(sender: AnyObject) {
        presentAddStudentAlert()
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("studentCell", forIndexPath: indexPath)
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
 
    // MARK: - Navigation
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if addEvidenceStudentListDelegate?.addEvidence == true {
            addEvidenceStudentListDelegate?.addEvidence = false
            performSegueWithIdentifier("addEvidenceSegue", sender: self)
        } else {
            performSegueWithIdentifier("studentDetailSegue", sender: self)
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "studentDetailSegue" {
            
        } else if segue.identifier == "addEvidenceSegue" {
            guard let destinationVC = segue.destinationViewController as? AddEvidenceViewController,
                indexPath = tableView.indexPathForSelectedRow,
                objective = objective,
                student = fetchedResultsController?.objectAtIndexPath(indexPath) as? Student else { return }
            destinationVC.student = student
            destinationVC.objective = objective
        }
    }

    // MARK: - PresentAddStudentAlert
    
    func presentAddStudentAlert() {
        let alert = UIAlertController(title: "Add a student", message: nil, preferredStyle: .Alert)
        alert.addTextFieldWithConfigurationHandler { (name) in
            name.placeholder = "Student name"
        }
        let saveAction = UIAlertAction(title: "Save", style: .Default) { (_) in
            guard let textField = alert.textFields?.first,
                nameText = textField.text where !nameText.isEmpty else { return }
            StudentController.shared.createStudent(nameText)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        presentViewController(alert, animated: true, completion: nil)
    }
}
//
//  StudentListTableViewController.swift
//  iCan
//
//  Created by Nicholas Laughter on 6/16/16.
//  Copyright © 2016 Nicholas Laughter. All rights reserved.
//

import UIKit
import CoreData

class StudentListTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        StudentController.sharedStudentController.fetchedResultsController.delegate = self
    }
    
    // MARK: - IBActions
    
    @IBAction func addStudentButtonTapped(sender: AnyObject) {
        presentNewStudentAlert()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        guard let sections = StudentController.sharedStudentController.fetchedResultsController.sections else { return 1 }
        return sections.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = StudentController.sharedStudentController.fetchedResultsController.sections else { return 0 }
        return sections[section].numberOfObjects
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("studentCell", forIndexPath: indexPath)
        guard let student = StudentController.sharedStudentController.fetchedResultsController.objectAtIndexPath(indexPath) as? Student else { return UITableViewCell() }
        cell.textLabel?.text = student.name
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            guard let student = StudentController.sharedStudentController.fetchedResultsController.objectAtIndexPath(indexPath) as? Student else { return }
            StudentController.sharedStudentController.deleteStudent(student)
        }
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let indexPath = tableView.indexPathForSelectedRow,
            detailVC = segue.destinationViewController as? StudentDetailViewController,
            student = StudentController.sharedStudentController.fetchedResultsController.objectAtIndexPath(indexPath) as? Student else { return }
        detailVC.updateWithStudent(student)
        
    }
    
    // MARK: - New Student Alert
    
    func presentNewStudentAlert() {
        let alert = UIAlertController(title: "Add Student", message: "Enter your student's name.", preferredStyle: .Alert)
        alert.addTextFieldWithConfigurationHandler { (nameText) in
            nameText.placeholder = "Name"
        }
        let saveAction = UIAlertAction(title: "Save", style: .Default) { (_) in
            guard let textField = alert.textFields?.first,
                nameText = textField.text where !nameText.isEmpty else { return }
            StudentController.sharedStudentController.addStudent(nameText)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    // MARK: - NSFetchedResultsControllerDelegate Methods
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch type {
        case .Delete:
            tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Automatic)
        case .Insert:
            tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Automatic)
        default:
            break
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Left)
        case .Insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Right)
        case .Move:
            guard let indexPath = indexPath,
                newIndexPath = newIndexPath else { return }
            tableView.moveRowAtIndexPath(indexPath, toIndexPath: newIndexPath)
        case .Update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
}
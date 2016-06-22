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
        
        addEvidence = false
        setUpFetchedResultsController()
    }
    
    var fetchedResultsController: NSFetchedResultsController?
    var addEvidence: Bool?
    var objective: Objective?
    
    // MARK: - IBAction
    
    @IBAction func addStudentButtonTapped(sender: AnyObject) {
        presentAddStudentAlert()
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController?.sections else { return 0 }
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("studentCell", forIndexPath: indexPath)
        if let student = fetchedResultsController?.objectAtIndexPath(indexPath) as? Student {
            cell.textLabel?.text = student.name
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            guard let student = fetchedResultsController?.objectAtIndexPath(indexPath) as? Student else { return }
            StudentController.shared.deleteStudent(student)
        }
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    
    func setUpFetchedResultsController() {
        let request = NSFetchRequest(entityName: Student.typeKey)
        let sortDescriptor = NSSortDescriptor(key: Student.nameKey, ascending: true)
        request.returnsObjectsAsFaults = false
        request.sortDescriptors = [sortDescriptor]
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: Stack.sharedStack.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        do {
            try fetchedResultsController?.performFetch()
        } catch let error as NSError {
            print("Unable to perform fetch request in StudentListTVC = \(error.localizedDescription)")
        }
        fetchedResultsController?.delegate = self
    }
    
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
            guard let indexPath = indexPath else {return}
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        case .Insert:
            guard let newIndexPath = newIndexPath else {return}
            tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Automatic)
        case .Move:
            guard let indexPath = indexPath,
                newIndexPath = newIndexPath else {return}
            tableView.moveRowAtIndexPath(indexPath, toIndexPath: newIndexPath)
        case .Update:
            guard let indexPath = indexPath else {return}
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
    
    // MARK: - Navigation
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if addEvidence == true {
            addEvidence = false
            performSegueWithIdentifier("addEvidenceSegue", sender: self)
        } else {
            performSegueWithIdentifier("studentDetailSegue", sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "studentDetailSegue" {
            guard let destinationVC = segue.destinationViewController as? StudentDetailViewController,
                indexPath = tableView.indexPathForSelectedRow,
                student = fetchedResultsController?.objectAtIndexPath(indexPath) as? Student else { return }
            destinationVC.student = student
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
//
//  ObjectiveListTableViewController.swift
//  iCan
//
//  Created by Nicholas Laughter on 6/20/16.
//  Copyright © 2016 Nicholas Laughter. All rights reserved.
//

import UIKit
import CoreData

class ObjectiveListTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, UISplitViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        splitViewController?.delegate = self
        setUpFetchedResultsController()
    }
    
    var fetchedResultsController: NSFetchedResultsController?
    var addEvidence: Bool? = false
    var student: Student?
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    // MARK: - IBAction
    
    @IBAction func addObjectiveButtonTapped(sender: AnyObject) {
        presentAddObjectiveAlert()
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController?.sections else { return 0 }
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("objectiveCell", forIndexPath: indexPath)
        if let objective = fetchedResultsController?.objectAtIndexPath(indexPath) as? Objective {
            cell.textLabel?.text = objective.studentCan
        }
        cell.textLabel?.textColor = UIColor.whiteColor()
        if (Int(indexPath.row) % 2 == 0) {
            cell.backgroundColor = UIColor(netHex: 0x58595B)
        } else {
            cell.backgroundColor = UIColor(netHex: 0x6D6E71)
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            guard let objective  = fetchedResultsController?.objectAtIndexPath(indexPath) as? Objective else { return }
            ObjectiveController.shared.deleteObjective(objective)
        }
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    
    func setUpFetchedResultsController() {
        let request = NSFetchRequest(entityName: Objective.typeKey)
        let sortDescriptor = NSSortDescriptor(key: Objective.studentCanKey, ascending: true)
        request.returnsObjectsAsFaults = false
        request.sortDescriptors = [sortDescriptor]
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: Stack.sharedStack.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        do {
            try fetchedResultsController?.performFetch()
        } catch let error as NSError {
            print("Unable to perform fetch request in ObjectiveListTVC = \(error.localizedDescription)")
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
            performSegueWithIdentifier("objectiveDetailSegue", sender: self)
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "objectiveDetailSegue" {
            guard let destinationVC = segue.destinationViewController as? ObjectiveDetailViewController,
                indexPath = tableView.indexPathForSelectedRow,
                objective = fetchedResultsController?.objectAtIndexPath(indexPath) as? Objective else { return }
            destinationVC.objective = objective
        } else if segue.identifier == "addEvidenceSegue" {
            guard let destinationVC = segue.destinationViewController as? AddEvidenceViewController,
                indexPath = tableView.indexPathForSelectedRow,
                objective = fetchedResultsController?.objectAtIndexPath(indexPath) as? Objective,
                student = student else { return }
            destinationVC.student = student
            destinationVC.objective = objective
            destinationVC.fromStudentDetail = true
        }
    }
    
    // MARK: - PresentAddObjectiveAlert
    
    func presentAddObjectiveAlert() {
        let alert = UIAlertController(title: "Add an objective", message: nil, preferredStyle: .Alert)
        alert.addTextFieldWithConfigurationHandler { (studentCan) in
            studentCan.placeholder = "Student can..."
            studentCan.autocapitalizationType = .Sentences
            studentCan.returnKeyType = .Done
        }
        let saveAction = UIAlertAction(title: "Save", style: .Default) { (_) in
            guard let textField = alert.textFields?.first,
                studentCanText = textField.text where !studentCanText.isEmpty else { return }
            ObjectiveController.shared.createObjective(studentCanText)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        presentViewController(alert, animated: true, completion: nil)
    }
}
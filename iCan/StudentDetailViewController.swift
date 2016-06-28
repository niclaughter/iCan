//
//  StudentDetailViewController.swift
//  iCan
//
//  Created by Nicholas Laughter on 6/20/16.
//  Copyright © 2016 Nicholas Laughter. All rights reserved.
//

import UIKit
import CoreData

class StudentDetailViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    
    var student: Student?
    var fetchedResultsController: NSFetchedResultsController?
    @IBOutlet weak var studentNameTextField: UITextField!
    @IBOutlet weak var ratioLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpFetchedResultsController()
        guard let student = student else { return }
        updateWithStudent(student)
    }
    
    func updateWithStudent(student: Student) {
        studentNameTextField.text = student.name
        ratioLabel.text = "\(student.numberPassed) passed - \(student.evidence.count) total"
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if let nameText = studentNameTextField.text,
            student = student {
            StudentController.shared.updateStudent(student, name: nameText)
        }
        resignFirstResponder()
        return true
    }
    
    // MARK: - IBAction
    
    @IBAction func addEvidenceButtonTapped(sender: AnyObject) {
    }
    
    // MARK: - TableViewDataSource and Delegate
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return student?.evidence.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "evidenceCell")
        guard let evidence = student?.evidence[indexPath.row] as? Evidence else { return cell }
        cell.textLabel?.text = evidence.objective.studentCan
        cell.textLabel?.textColor = UIColor.whiteColor()
        if (Int(indexPath.row) % 2 == 0) {
            cell.backgroundColor = UIColor(netHex: 0x58595B)
        } else {
            cell.backgroundColor = UIColor(netHex: 0x6D6E71)
        }
        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            guard let evidence = fetchedResultsController?.objectAtIndexPath(indexPath) as? Evidence else { return }
            EvidenceController.shared.deleteEvidence(evidence)
            guard let student = student else { return }
            updateWithStudent(student)
        }
    }
    
    // MARK: - Navigation
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("evidenceDetailSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "evidenceDetailSegue" {
            guard let destinationVC = segue.destinationViewController as? AddEvidenceViewController,
                indexPath = tableView.indexPathForSelectedRow,
                evidence = student?.evidence[indexPath.row] as? Evidence else { return }
            destinationVC.evidence = evidence
            destinationVC.fromStudentDetail = true
        } else {
            guard let destinationVC = segue.destinationViewController as? ObjectiveListTableViewController else { return }
            destinationVC.addEvidence = true
            destinationVC.student = student
        }
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    
    func setUpFetchedResultsController() {
        let request = NSFetchRequest(entityName: Evidence.typeKey)
        let sortDescriptor = NSSortDescriptor(key: Evidence.objectiveKey, ascending: true)
        request.returnsObjectsAsFaults = false
        request.sortDescriptors = [sortDescriptor]
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: Stack.sharedStack.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        do {
            try fetchedResultsController?.performFetch()
        } catch let error as NSError {
            print("Unable to perform fetch request = \(error.localizedDescription)")
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
}

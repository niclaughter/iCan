//
//  StudentDetailViewController.swift
//  iCan
//
//  Created by Nicholas Laughter on 6/20/16.
//  Copyright © 2016 Nicholas Laughter. All rights reserved.
//

import UIKit

class StudentDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var student: Student?
    @IBOutlet weak var studentNameTextField: UITextField!
    @IBOutlet weak var ratioLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let student = student else { return }
        studentNameTextField.text = student.name
        ratioLabel.text = "\(student.numberPassed)/\(student.evidence.count)"
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
        return cell
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    }
}

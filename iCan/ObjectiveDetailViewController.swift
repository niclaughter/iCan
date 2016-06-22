//
//  ObjectiveDetailViewController.swift
//  iCan
//
//  Created by Nicholas Laughter on 6/20/16.
//  Copyright © 2016 Nicholas Laughter. All rights reserved.
//

import UIKit

class ObjectiveDetailViewController: UIViewController {
    
    var objective: Objective?
    @IBOutlet weak var objectiveTitleTextField: UITextField!
    @IBOutlet weak var notesTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

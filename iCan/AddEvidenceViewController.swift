//
//  AddEvidenceViewController.swift
//  iCan
//
//  Created by Nicholas Laughter on 6/20/16.
//  Copyright © 2016 Nicholas Laughter. All rights reserved.
//

import UIKit

class AddEvidenceViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var student: Student?
    var objective: Objective?
    var rating: Int?
    var fromStudentDetail = Bool()
    
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var studentNameLabel: UILabel!
    @IBOutlet weak var objectiveTitleLabel: UILabel!
    
    weak var delegate: PhotoSelectViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let student = student,
            objective = objective else { return }
        updateWithStudent(student, andObjective: objective)
    }
    
    // MARK: - IBActions
    
    @IBAction func noButtonTapped(sender: AnyObject) {
        rating = 1
    }
    
    @IBAction func okButtonTapped(sender: AnyObject) {
        rating = 2
    }
    
    @IBAction func yesButtonTapped(sender: AnyObject) {
        rating = 3
    }
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        if fromStudentDetail {
            performSegueWithIdentifier("studentDetailSegue", sender: self)
        } else {
            performSegueWithIdentifier("objectiveDetailSegue", sender: self)
        }
    }
    
    @IBAction func saveButtonTapped(sender: AnyObject) {
        guard let student = student,
            objective = objective,
            rating = rating,
            image = imageView.image,
            imageRepresentation = UIImagePNGRepresentation(image) else { return }
        EvidenceController.shared.createEvidence(imageRepresentation, competencyRating: rating, student: student, objective: objective)
        if fromStudentDetail {
            performSegueWithIdentifier("studentDetailSegue", sender: self)
        } else {
            performSegueWithIdentifier("objectiveDetailSegue", sender: self)
        }
    }
    
    @IBAction func selectPhotoButtonTapped() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        let alert = UIAlertController(title: "Select Photo Source", message: nil, preferredStyle: .ActionSheet)
        if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
            alert.addAction(UIAlertAction(title: "Photo Library", style: .Default, handler: { (_) in
                imagePicker.sourceType = .PhotoLibrary
                self.presentViewController(imagePicker, animated: true, completion: nil)
            }))
        }
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            alert.addAction(UIAlertAction(title: "Camera", style: .Default, handler: { (_) in
                imagePicker.sourceType = .Camera
                self.presentViewController(imagePicker, animated: true, completion: nil)
            }))
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        if let popoverPresentationController = alert.popoverPresentationController {
            popoverPresentationController.sourceView = self.view
            popoverPresentationController.sourceRect = CGRectMake(self.view.bounds.size.width / 2.0 - 105, self.view.bounds.size.height / 2.0 + 70, 1.0, 1.0)
        }
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func updateWithStudent(student: Student, andObjective: Objective) {
        studentNameLabel.text = student.name
        objectiveTitleLabel.text = andObjective.studentCan
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        picker.dismissViewControllerAnimated(true, completion: nil)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            delegate?.photoSelectViewControllerSelected(image)
            addPhotoButton.setTitle("", forState: .Normal)
            imageView.image = image
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "studentDetailSegue" {
            guard let destinationVC = segue.destinationViewController as? StudentDetailViewController,
                student = student else { return }
            destinationVC.student = student
        } else {
            guard let destinationVC = segue.destinationViewController as? ObjectiveDetailViewController,
                objective = objective else { return }
            destinationVC.objective = objective
        }
    }
}

protocol PhotoSelectViewControllerDelegate: class {
    func photoSelectViewControllerSelected(image: UIImage)
}
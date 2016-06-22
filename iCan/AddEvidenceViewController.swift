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
    var rating: NSNumber?
    
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    weak var delegate: PhotoSelectViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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
    }
    
    @IBAction func saveButtonTapped(sender: AnyObject) {
        guard let student = student,
            objective = objective,
            image = imageView.image,
            imageRepresentation = UIImagePNGRepresentation(image) else { return }
        EvidenceController.shared.createEvidence(imageRepresentation, competencyRating: rating, student: student, objective: objective)
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
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        picker.dismissViewControllerAnimated(true, completion: nil)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            delegate?.photoSelectViewControllerSelected(image)
            addPhotoButton.setTitle("", forState: .Normal)
            imageView.image = image
        }
    }
}

protocol PhotoSelectViewControllerDelegate: class {
    func photoSelectViewControllerSelected(image: UIImage)
}
//
//  StudentDetailViewController.swift
//  iCan
//
//  Created by Nicholas Laughter on 6/16/16.
//  Copyright © 2016 Nicholas Laughter. All rights reserved.
//

import UIKit

class StudentDetailViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Properties
    
    var student: Student?
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var classTextField: UITextField!
    @IBOutlet weak var parentsTextField: UITextField!
    @IBOutlet weak var contactTextField: UITextField!
    @IBOutlet weak var studentImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: self.view.window)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: self.view.window)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        guard let student = student,
            name = nameTextField.text else { return true }
        StudentController.sharedStudentController.updateStudent(student, name: name, classroomName: classTextField.text, parentsNames: parentsTextField.text, contact: contactTextField.text)
        return true
    }
    
    // MARK: - Keyboard Show/Hide Functions
    
    func keyboardWillShow(sender: NSNotification) {
        guard let userInfo: [NSObject: AnyObject] = sender.userInfo,
            keyboardSize: CGSize = userInfo[UIKeyboardFrameBeginUserInfoKey]?.CGRectValue.size,
            offset: CGSize = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue.size else { return }
        if keyboardSize.height == offset.height && self.view.frame.origin.y == 0 {
            UIView.animateWithDuration(0.1, animations: {
                self.view.frame.origin.y -= keyboardSize.height
            })
        } else {
            UIView.animateWithDuration(0.1, animations: {
                self.view.frame.origin.y += (keyboardSize.height - offset.height)
            })
        }
    }
    
    func keyboardWillHide(sender: NSNotification) {
        guard let userInfo: [NSObject: AnyObject] = sender.userInfo,
            keyboardSize: CGSize = userInfo[UIKeyboardFrameBeginUserInfoKey]?.CGRectValue.size else { return }
        self.view.frame.origin.y  += keyboardSize.height
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: self.view.window)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: self.view.window)
    }
    
    // MARK: - View Functions
    
    @IBAction func selectImage(sender: UITapGestureRecognizer) {
        print("Image tapped!")
    }
    
    func updateWithStudent(student: Student) {
        self.student = student
        nameTextField.text = student.name
//        classTextField.text = student.classroomName
//        parentsTextField.text = student.parentsNames
//        contactTextField.text = student.contact
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  ReminderViewController.swift
//  RemindMe
//
//  Created by Reid Bixler on 2/21/16.
//  Copyright © 2016 Reid Bixler. All rights reserved.
//

import UIKit

class ReminderViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UINavigationControllerDelegate{
    
    // MARK: Properties
    @IBOutlet weak var reminderTitleField: UITextField!
    @IBOutlet weak var reminderDescField: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var dateTimePicker: UIDatePicker!
    
    var reminder: Reminder?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Handle the text field’s user input through delegate callbacks
        reminderTitleField.delegate = self
        
        if let reminder = reminder {
            navigationItem.title = reminder.title
            reminderTitleField.text = reminder.title
            reminderDescField.text = reminder.description
            dateTimePicker.setDate(reminder.dateTime, animated: false)
        }
        
        reminderDescField.delegate = self
        
        let currentDate = NSDate()
        dateTimePicker.minimumDate = currentDate
        
        checkValidReminderName()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        saveButton.enabled = false
    }
    
    func checkValidReminderName() {
        let text = reminderTitleField.text ?? ""
        saveButton.enabled = !text.isEmpty
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        checkValidReminderName()
        navigationItem.title = textField.text
    }
    
    // MARK: UITextViewDelegate
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    // MARK: Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if saveButton === sender {
            let title = reminderTitleField.text ?? ""
            let description = reminderDescField.text ?? ""
            var dateTime = dateTimePicker.date
            
            let timeInterval = floor(dateTime.timeIntervalSinceReferenceDate / 60.0) * 60.0
            dateTime = NSDate(timeIntervalSinceReferenceDate: timeInterval)

            
            reminder = Reminder(title: title, description: description, dateTime: dateTime)
        }
    }
    @IBAction func cancel(sender: UIBarButtonItem) {
        let isPresentingInAddReminderMode = presentingViewController is UINavigationController
        if isPresentingInAddReminderMode {
            dismissViewControllerAnimated(true, completion: nil)
        }
        else{
            navigationController!.popViewControllerAnimated(true)
        }
    }


}


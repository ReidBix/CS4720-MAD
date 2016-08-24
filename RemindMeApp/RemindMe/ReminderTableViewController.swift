//
//  ReminderTableViewController.swift
//  RemindMe
//
//  Created by Reid Bixler on 2/22/16.
//  Copyright © 2016 Reid Bixler. All rights reserved.
//

import UIKit

var sortedReminders = [Reminder]()

func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}

func forceRefresh(inout reminders: [Reminder], controller: UITableViewController){
    sortedReminders = reminders.sort { $0.dateTime.timeIntervalSince1970 < $1.dateTime.timeIntervalSince1970 }
    reminders = sortedReminders
    controller.tableView.reloadData()
}

func makeAlarm(reminder: Reminder, var reminders: [Reminder], viewcontroller: UITableViewController){
    let notification = UILocalNotification()
    notification.fireDate = reminder.dateTime
    notification.alertAction = ("Hi?")
    notification.alertBody = (reminder.title)
    notification.soundName = UILocalNotificationDefaultSoundName
    notification.userInfo = ["title": reminder.title, "dateTime": reminder.dateTime]
    UIApplication.sharedApplication().scheduleLocalNotification(notification)
    
    //print(NSDate())
    //print(reminder.dateTime)
    let secondsBetween = reminder.dateTime.timeIntervalSinceDate(NSDate())
    //print("Seconds between now and alert: \(secondsBetween)")
    
    delay(secondsBetween){
        var exists = false
        for r in reminders{
            if (r.title == reminder.title){
                exists = true
            }
        }
        if (exists){
        
            let alertController = UIAlertController(title: "RemindMe!", message:
                reminder.title, preferredStyle: UIAlertControllerStyle.Alert)
        
            let dismissAction = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default){
                UIAlertAction in
                //print("Dismissed!")
                //if let userInfo = notification.userInfo {
                    //let title = userInfo["title"] as! String
                    //let dateTime = userInfo["dateTime"] as! NSDate
                    //print("didReceiveLocalNotification: \(title) \(dateTime)")
                //}
            }
        
            let postponeAction = UIAlertAction(title: "Postpone", style: UIAlertActionStyle.Default){
                UIAlertAction in
                //print("Postponed!")
                if let userInfo = notification.userInfo {
                    let title = userInfo["title"] as! String
                    let dateTime = userInfo["dateTime"] as! NSDate
                    //print("didReceiveLocalNotification: \(title) \(dateTime)")
                    for r in reminders{
                        if (r.title == title && r.dateTime == dateTime){
                            //print(r.dateTime)
                            let newDate = r.dateTime.dateByAddingTimeInterval(3600)
                            //print(newDate)
                            r.dateTime = newDate
                        
                            makeAlarm(r, reminders: reminders, viewcontroller: viewcontroller)
                            forceRefresh(&reminders, controller: viewcontroller)
                        }
                    }
                }
            }
        
            // Add the actions
            alertController.addAction(dismissAction)
            alertController.addAction(postponeAction)
        
            viewcontroller.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
}

class ReminderTableViewController: UITableViewController {
    // MARK: Properties
    
    var reminders = [Reminder]()
    
    func loadSampleReminders() {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        let dateTime1S = "04-05-2016 01:02"
        let dateTime1 = dateFormatter.dateFromString(dateTime1S)
        let dateTime2S = "04-07-2016 03:04"
        let dateTime2 = dateFormatter.dateFromString(dateTime2S)
        let dateTime3S = "04-09-2016 05:06"
        let dateTime3 = dateFormatter.dateFromString(dateTime3S)
        
        let rem1 = Reminder(title: "Title 1", description: "This is a description for Title 1", dateTime: (dateTime1)!)!
        
        let rem2 = Reminder(title: "Second Title", description: "WORDS WORDS WORDS", dateTime: (dateTime2)!)!
        
        let rem3 = Reminder(title: "THIS IS A TITLE", description: "Short description", dateTime: (dateTime3)!)!
        
        reminders += [rem1, rem2, rem3]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = editButtonItem()
        
        //sortedReminders = reminders.sort { $0.dateTime.timeIntervalSince1970 < $1.dateTime.timeIntervalSince1970 }
        //reminders = sortedReminders
        //self.tableView.reloadData()
        
        self.refreshControl?.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
        //Load the sample data.
        //loadSampleReminders()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reminders.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       
        let cellIdentifier = "ReminderTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ReminderTableViewCell
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        
        let reminder = reminders[indexPath.row]
        cell.titleLabel.text = reminder.title
        cell.dateTimeLabel.text = dateFormatter.stringFromDate(reminder.dateTime)
        
        
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            reminders.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            
        }
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    // MARK: Actions
    @IBAction func unwindToReminderList(sender: UIStoryboardSegue) {
        //print("ACTION!")
        if let sourceViewController = sender.sourceViewController as? ReminderViewController, reminder = sourceViewController.reminder {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                reminders[selectedIndexPath.row] = reminder
                tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)
            }
            else {
                let newIndexPath = NSIndexPath(forRow: reminders.count, inSection:0)
                reminders.append(reminder)
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
            }
            
            makeAlarm(reminder, reminders: reminders, viewcontroller: self)
            forceRefresh(&reminders, controller: self)
        }
    }
    
    // MARK: Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowDetail" {
            let reminderDetailViewController = segue.destinationViewController as! ReminderViewController
            if let selectedReminderCell = sender as? ReminderTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedReminderCell)!
                let selectedReminder = reminders[indexPath.row]
                reminderDetailViewController.reminder = selectedReminder
            }
        }
        else if segue.identifier == "AddItem" {
            //print("Adding new reminder.")
        }
    }
    
    override func viewDidAppear(animated: Bool)
    {
        forceRefresh(&reminders, controller: self)
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        forceRefresh(&reminders, controller: self)
        
        refreshControl.endRefreshing()
    }
}

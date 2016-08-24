//
//  ThirdViewController.swift
//  4720Final
//
//  Created by Reid Bixler on 4/18/16.
//  Copyright © 2016 Reid Bixler. All rights reserved.
//
//
//  FirstViewController.swift
//  4720Final
//
//  Created by Reid Bixler on 4/4/16.
//  Copyright © 2016 Reid Bixler. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class ThirdViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Properties
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textLabel: UILabel!
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var id: UITextField!
    @IBOutlet weak var abv: UITextField!
    @IBOutlet weak var ibu: UITextField!
    
    var controller:UIAlertController?
    
    func textFieldShouldReturn(textField: UITextField) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        textField.resignFirstResponder()
        return true;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let prefs = NSUserDefaults.standardUserDefaults()
        self.textField.delegate = self
        self.name.delegate = self
        self.id.delegate = self
        self.abv.delegate = self
        self.ibu.delegate = self
        do {
            let path = NSTemporaryDirectory() + "savedText.txt"
            
            let readString = try String(contentsOfFile: path, encoding: NSUTF8StringEncoding)
            textLabel.text = readString
        } catch let error as NSError {
            textLabel.text = "No file saved yet!"
            print(error)
        }
        
        if let savedText = prefs.stringForKey("savedText"){
            print("NSUserDefaults contains: " + savedText)
        }else{
            //Nothing stored in NSUserDefaults yet. Set a value.
            print("Nothing stored yet in NSUserDefaults")
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Actions
    
    @IBAction func saveButton(sender: UIButton) {
        let someText = textField.text!
        let destinationPath = NSTemporaryDirectory() +  "savedText.txt"
        do {
            try someText.writeToFile(destinationPath,
                                     atomically: true,
                                     encoding: NSUTF8StringEncoding)
            showAlert(someText)
            print("Successfully stored the file at path \(destinationPath)")
        } catch let error as NSError {
            print("An error occurred: \(error)")
        }
        let prefs = NSUserDefaults.standardUserDefaults()
        prefs.setValue(someText, forKey: "savedText")
        
    }
    
    func showAlert(text: NSString) {
        controller = UIAlertController(title: "Saved Text",
                                       message: (text as String) + " was saved!",
                                       preferredStyle: .Alert)
        
        let action = UIAlertAction(title: "Done",
                                   style: UIAlertActionStyle.Default,
                                   handler: {(paramAction:UIAlertAction!) in
                                    print((text as String) + " was saved!", terminator: "")
        })
        
        controller!.addAction(action)
        self.presentViewController(controller!, animated: true, completion: nil)
    }
    
    func createNewBeer(name: String,
                                      id: String, abv: String, ibu: String) -> Bool{
        
        let newBeer =
            NSEntityDescription.insertNewObjectForEntityForName("Beer",
                                                                inManagedObjectContext: managedObjectContext) as! Beer
        
        (newBeer.name, newBeer.id, newBeer.abv, newBeer.ibu) =
            (name, id, abv, ibu)
        
        do{
            try managedObjectContext.save()
        } catch let error as NSError{
            print("Failed to save the new beer. Error = \(error)")
        }
        
        return false
        
    }
    @IBAction func saveBeer(sender: UIButton) {
        print("Executing saveBeer")
        createNewBeer(name.text!, id: id.text!,abv: abv.text!, ibu: ibu.text!)
        showAlert(name.text! + " " + id.text!)
        print("Finishing saveBeer")
    }
        
        

        
        @IBAction func loadBeer(sender: UIButton) {
        print("Executing loadBeer")
        
        /* Create the fetch request first */
        let fetchRequest = NSFetchRequest(entityName: "Beer")
        
        let abvSort = NSSortDescriptor(key: "abv", ascending: true)
        
        let nameSort = NSSortDescriptor(key: "name", ascending: true)
        
        fetchRequest.sortDescriptors = [abvSort, nameSort]
        
        /* And execute the fetch request on the context */
        do{
            let beers = try managedObjectContext.executeFetchRequest(fetchRequest) as! [Beer]
            let randomIndex = Int(arc4random_uniform(UInt32(beers.count)))
            for beer in beers{
                print("Name = \(beer.name)")
                print("ID = \(beer.id)")
                print("ABV = \(beer.abv)")
                print("IBU = \(beer.ibu)")
                if(beers.indexOf(beer) == randomIndex) {
                    name.text = beer.name
                    id.text = beer.id
                    abv.text = beer.abv
                    ibu.text = beer.ibu
                }
            }
        } catch let error as NSError{
            print(error)
        }
        print("Finishing loadBeer")
    }
    
    
    
    
}


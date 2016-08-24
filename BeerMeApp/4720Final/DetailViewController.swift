//
//  DetailViewController.swift
//  BeerMe
//
//  Created by Reid Bixler on 4/28/16.
//  Copyright © 2016 Reid Bixler. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class DetailViewController: UIViewController {
    
    @IBOutlet weak var detailLabel2: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var abv: UILabel!
    @IBOutlet weak var ibu: UILabel!
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var controller:UIAlertController?

    var searchBeerViewController: SearchBeerViewController? = nil
    
    var first = true;
    var ref : SearchBeerViewController?
    
    var detailBeer: BeerItem? {
        didSet {
            configureView()
        }
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        textField.resignFirstResponder()
        return true;
    }
    
    
    func configureView() {
        first = false
        if let detailBeer = detailBeer {
            if let detailLabel = detailLabel, detailLabel2 = detailLabel2 {
                detailLabel.text = detailBeer.name
                detailLabel2.text = detailBeer.id
                abv.text = detailBeer.abv
                ibu.text = detailBeer.ibu
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let splitViewController = splitViewController {
            let controllers = splitViewController.viewControllers
            searchBeerViewController = (controllers[controllers.count - 1] as! UINavigationController).topViewController as? SearchBeerViewController
        }
        
        let prefs = NSUserDefaults.standardUserDefaults()

        if (first){
            //Send back
        }
        configureView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        createNewBeer(detailLabel.text!, id: detailLabel2.text!,abv: abv.text!, ibu: ibu.text!)
        showAlert(detailLabel.text! + " " + detailLabel2.text!)
        print("Finishing saveBeer")
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
    
    @IBAction func deleteBeer(sender: UIButton){
        /* Create the fetch request first */
        let fetchRequest = NSFetchRequest(entityName: "Beer")
        
        let abvSort = NSSortDescriptor(key: "abv", ascending: true)
        
        let nameSort = NSSortDescriptor(key: "name", ascending: true)
        
        fetchRequest.sortDescriptors = [abvSort, nameSort]
        
        /* And execute the fetch request on the context */
        do{
            let beers = try managedObjectContext.executeFetchRequest(fetchRequest) as! [Beer]
            for beer in beers{
                if (beer.id == detailLabel2.text){
                    managedObjectContext.deleteObject(beer)
                    try managedObjectContext.save()
                }
            }
        } catch let error as NSError{
            print(error)
        }

    }
   
    
    
}

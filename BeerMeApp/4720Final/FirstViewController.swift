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


class FirstViewController: UIViewController, UITextFieldDelegate {
    
    
     let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    @IBOutlet weak var BeerID: UILabel!
    @IBOutlet weak var BeerName: UILabel!
    @IBOutlet weak var BeerABV: UILabel!
    @IBOutlet weak var BeerIBU: UILabel!
    
    var controller:UIAlertController?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
        // Doing a GET
        let postEndpoint: String = "http://jsonplaceholder.typicode.com/posts/1"
        guard let url = NSURL(string: postEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        let urlRequest = NSURLRequest(URL: url)
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        
        let task = session.dataTaskWithRequest(urlRequest, completionHandler: { (data, response, error) in
            // do stuff with response, data & error here
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            guard error == nil else {
                print("error calling GET on /posts/1")
                print(error)
                return
            }
            // parse the result as JSON, since that's what the API provides
            let post: NSDictionary
            do {
                post = try NSJSONSerialization.JSONObjectWithData(responseData,
                    options: []) as! NSDictionary
            } catch  {
                print("error trying to convert data to JSON")
                return
            }
            // now we have the post, let's just print it to prove we can access it
            print("The post is: " + post.description)
            
            // the post object is a dictionary
            // so we just access the title using the "title" key
            // so check for a title and print it if we have one
            if let postTitle = post["title"] as? String {
                print("The title is: " + postTitle)
            }
            
        })
        task.resume()
        
        
        
        // Method other than a GET
        
        let postsEndpoint: String = "http://jsonplaceholder.typicode.com/posts"
        guard let postsURL = NSURL(string: postsEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        let postsUrlRequest = NSMutableURLRequest(URL: postsURL)
        postsUrlRequest.HTTPMethod = "POST"
        
        let newPost: NSDictionary = ["title": "Frist Psot", "body": "I iz fisrt", "userId": 1]
        do {
            let jsonPost = try NSJSONSerialization.dataWithJSONObject(newPost, options: [])
            postsUrlRequest.HTTPBody = jsonPost
            
            let config = NSURLSessionConfiguration.defaultSessionConfiguration()
            let session = NSURLSession(configuration: config)
            
            let task = session.dataTaskWithRequest(postsUrlRequest, completionHandler: {
                (data, response, error) in
                guard let responseData = data else {
                    print("Error: did not receive data")
                    return
                }
                guard error == nil else {
                    print("error calling GET on /posts/1")
                    print(error)
                    return
                }
                
                // parse the result as JSON, since that's what the API provides
                let post: NSDictionary
                do {
                    post = try NSJSONSerialization.JSONObjectWithData(responseData,
                        options: []) as! NSDictionary
                } catch  {
                    print("error parsing response from POST on /posts")
                    return
                }
                // now we have the post, let's just print it to prove we can access it
                print("The post is: " + post.description)
                
                // the post object is a dictionary
                // so we just access the title using the "title" key
                // so check for a title and print it if we have one
                if let postID = post["id"] as? Int
                {
                    print("The ID is: \(postID)")
                }
            } )
            task.resume()
        }
        catch  {
            print("error trying to convert data to JSON")
            return
        }
        
        
        // Deleting
        let firstPostEndpoint: String = "http://jsonplaceholder.typicode.com/posts/1"
        let firstPostUrlRequest = NSMutableURLRequest(URL: NSURL(string: firstPostEndpoint)!)
        firstPostUrlRequest.HTTPMethod = "DELETE"
        
        let task2 = session.dataTaskWithRequest(firstPostUrlRequest, completionHandler: {
            (data, response, error) in
            guard let _ = data else {
                print("error calling DELETE on /posts/1")
                return
            }
        })
        task2.resume()
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getBeer() {
        let beers = true;
        let postEndpoint: String
        let randomABV = arc4random_uniform(20)
        let ABVString :String = "" + String(randomABV)
        
        
        // Doing a GET
        if (beers){
            postEndpoint = "http://api.brewerydb.com/v2/beers?abv=" + ABVString + "&order=random&randomCount=1&key=bc8f922546c6985e5d402f8bc79262bc"
            print(postEndpoint)
        } else {
            postEndpoint = "http://api.brewerydb.com/v2/beer/oeGSxs/?key=bc8f922546c6985e5d402f8bc79262bc"
        }
        //If contains ?, use &key, else /?key
        //let key: String = "key=bc8f922546c6985e5d402f8bc79262bc"
        guard let url = NSURL(string: postEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        let urlRequest = NSURLRequest(URL: url)
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        
        let task = session.dataTaskWithRequest(urlRequest, completionHandler: { (data, response, error) in
            // do stuff with response, data & error here
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            guard error == nil else {
                print("error calling GET on /posts/1")
                print(error)
                return
            }
            // parse the result as JSON, since that's what the API provides
            let post: NSDictionary
            do {
                post = try NSJSONSerialization.JSONObjectWithData(responseData,
                    options: []) as! NSDictionary
            } catch  {
                print("error trying to convert data to JSON")
                return
            }
            // now we have the post, let's just print it to prove we can access it
            print("The post is: " + post.description)
            
            // the post object is a dictionary
            // so we just access the title using the "title" key
            // so check for a title and print it if we have one
            if let postTitle = post["title"] as? String {
                print("The title is: " + postTitle)
            }
            
            if (beers){
                if let postArray = post["data"] as? NSArray {
                    if let postData = postArray[0] as? NSDictionary {
                        if let postID = postData["id"] as? String {
                            print("The post ID is \(postID)")
                            dispatch_async(dispatch_get_main_queue(), {
                                self.BeerID.text = postID
                            })
                        } else {
                            dispatch_async(dispatch_get_main_queue(), {
                                self.BeerID.text = "NA"
                            })
                        }
                        if let postName = postData["name"] as? String {
                            print("The name is \(postName)")
                            dispatch_async(dispatch_get_main_queue(), {
                                self.BeerName.text = postName
                            })
                        } else {
                            dispatch_async(dispatch_get_main_queue(), {
                                self.BeerName.text = "NA"
                            })
                        }
                        if let postABV = postData["abv"] as? String {
                            print("The ABV is \(postABV)")
                            dispatch_async(dispatch_get_main_queue(), {
                                self.BeerABV.text = postABV
                            })
                        } else {
                            dispatch_async(dispatch_get_main_queue(), {
                                self.BeerABV.text = "NA"
                            })
                        }
                        if let postIBU = postData["ibu"] as? String {
                            print("The name is \(postIBU)")
                            dispatch_async(dispatch_get_main_queue(), {
                                self.BeerIBU.text = postIBU
                            })
                        } else {
                            dispatch_async(dispatch_get_main_queue(), {
                                self.BeerIBU.text = "NA"
                            })
                        }
                    }
                }
            } else {
                if let postData = post["data"] as? NSDictionary {
                    if let postID = postData["id"] as? String {
                        print("The post ID is \(postID)")
                        dispatch_async(dispatch_get_main_queue(), {
                            self.BeerID.text = postID
                        })
                    } else {
                        dispatch_async(dispatch_get_main_queue(), {
                            self.BeerID.text = "NA"
                        })
                    }
                    if let postName = postData["name"] as? String {
                        print("The name is \(postName)")
                        dispatch_async(dispatch_get_main_queue(), {
                            self.BeerName.text = postName
                        })
                    } else {
                        dispatch_async(dispatch_get_main_queue(), {
                            self.BeerName.text = "NA"
                        })
                    }
                    if let postABV = postData["abv"] as? String {
                        print("The ABV is \(postABV)")
                        dispatch_async(dispatch_get_main_queue(), {
                            self.BeerABV.text = postABV
                        })
                    } else {
                        dispatch_async(dispatch_get_main_queue(), {
                            self.BeerABV.text = "NA"
                        })
                    }
                    if let postIBU = postData["ibu"] as? String {
                        print("The name is \(postIBU)")
                        dispatch_async(dispatch_get_main_queue(), {
                            self.BeerIBU.text = postIBU
                        })
                    } else {
                        dispatch_async(dispatch_get_main_queue(), {
                            self.BeerIBU.text = "NA"
                        })
                    }
                }
            }
            
            if let postName = post["name"] as? String {
                print("The name is \(postName)")
            }
        })
        task.resume()
    }
    
    // function to allow for detecting a shake
    override func motionEnded(motion: UIEventSubtype,
                              withEvent event: UIEvent?) {
        
        if motion == .MotionShake{
            self.getBeer()
        }
        
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
        createNewBeer(BeerName.text!, id: BeerID.text!,abv: BeerABV.text!, ibu: BeerIBU.text!)
        showAlert(BeerName.text! + " " + BeerID.text!)
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

    

    
    @IBAction func buttonPress(sender: AnyObject) {
        self.getBeer()

    }
}


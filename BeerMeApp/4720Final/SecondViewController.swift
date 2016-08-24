//
//  SecondViewController.swift
//  4720Final
//
//  Created by Reid Bixler on 4/4/16.
//  Copyright © 2016 Reid Bixler. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import CoreMotion

class SecondViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager?
    
    var locations = [String: Float]()
    
    lazy var motionManager = CMMotionManager()
    var xDir: Double!
    var yDir: Double!
    var zDir: Double!
    
    // MARK: Properties
    
    @IBOutlet weak var lat: UILabel!
    @IBOutlet weak var lon: UILabel!
    @IBOutlet weak var n1: UILabel!
    @IBOutlet weak var n2: UILabel!
    @IBOutlet weak var n3: UILabel!
    @IBOutlet weak var n4: UILabel!
    @IBOutlet weak var n5: UILabel!
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if locations.count == 0{
            //handle error here
            return
        }
        
        let newLocation = locations[0]
        
        print("Latitude = \(newLocation.coordinate.latitude)")
        print("Longitude = \(newLocation.coordinate.longitude)")
        lat.text = String(newLocation.coordinate.latitude)
        lon.text = String(newLocation.coordinate.longitude)
        
    }
    
    func locationManager(manager: CLLocationManager,
                         didFailWithError error: NSError){
        print("Location manager failed with error = \(error)")
    }
    
    func locationManager(manager: CLLocationManager,
                         didChangeAuthorizationStatus status: CLAuthorizationStatus){
        
        print("The authorization status of location services is changed to: ", terminator: "")
        
        switch CLLocationManager.authorizationStatus(){
        case .AuthorizedAlways:
            print("Authorized")
        case .AuthorizedWhenInUse:
            print("Authorized when in use")
        case .Denied:
            print("Denied")
        case .NotDetermined:
            print("Not determined")
        case .Restricted:
            print("Restricted")
        }
        
    }
    
    func displayAlertWithTitle(title: String, message: String){
        let controller = UIAlertController(title: title,
                                           message: message,
                                           preferredStyle: .Alert)
        
        controller.addAction(UIAlertAction(title: "OK",
            style: .Default,
            handler: nil))
        
        presentViewController(controller, animated: true, completion: nil)
        
    }
    
    func createLocationManager(startImmediately startImmediately: Bool){
        locationManager = CLLocationManager()
        if let manager = locationManager{
            print("Successfully created the location manager")
            manager.delegate = self
            if startImmediately{
                manager.startUpdatingLocation()
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        /* Are location services available on this device? */
        if CLLocationManager.locationServicesEnabled(){
            
            /* Do we have authorization to access location services? */
            switch CLLocationManager.authorizationStatus(){
            case .AuthorizedAlways:
                /* Yes, always */
                createLocationManager(startImmediately: true)
            case .AuthorizedWhenInUse:
                /* Yes, only when our app is in use */
                createLocationManager(startImmediately: true)
            case .Denied:
                /* No */
                displayAlertWithTitle("Not Determined",
                                      message: "Location services are not allowed for this app")
            case .NotDetermined:
                /* We don't know yet, we have to ask */
                createLocationManager(startImmediately: false)
                if let manager = self.locationManager{
                    manager.requestWhenInUseAuthorization()
                }
            case .Restricted:
                /* Restrictions have been applied, we have no access
                 to location services */
                displayAlertWithTitle("Restricted",
                                      message: "Location services are not allowed for this app")
            }
            
            
        } else {
            /* Location services are not enabled.
             Take appropriate action: for instance, prompt the
             user to enable the location services */
            print("Location services are not enabled")
        }
    }
    
    @IBAction func getLocations(sender: UIButton){
        // Doing a GET
        let postEndpoint: String
        postEndpoint = "http://api.brewerydb.com/v2/locations?region=Virginia&key=bc8f922546c6985e5d402f8bc79262bc"
        print(postEndpoint)
        
        var newName: String! = "NA"
        var newLat: Float! = 0
        var newLon: Float! = 0
        var curLat: Float! = Float(lat.text!)
        var curLon: Float! = Float(lon.text!)
        
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
            
            if let postArray = post["data"] as? NSArray {
                for var i = 0; i < postArray.count; ++i {
                    if let postData = postArray[i] as? NSDictionary {
                        if let postName = postData["name"] as? String {
                            //print("The name is \(postName)")
                            dispatch_async(dispatch_get_main_queue(), {
                                newName = postName
                            })
                        } else {
                            dispatch_async(dispatch_get_main_queue(), {
                                newName = "NA"
                            })
                        }
                        if let postLat = postData["latitude"] as? Float {
                            //print("The latitude is \(postLat)")
                            dispatch_async(dispatch_get_main_queue(), {
                                newLat = postLat
                            })
                        } else {
                            dispatch_async(dispatch_get_main_queue(), {
                                newLat = 0
                            })
                        }
                        if let postLon = postData["longitude"] as? Float {
                            //print("The longitude is \(postLon)")
                            dispatch_async(dispatch_get_main_queue(), {
                                newLon = postLon
                            })
                        } else {
                            dispatch_async(dispatch_get_main_queue(), {
                                newLon = 0
                            })
                        }
                        
                        let xd = curLat-newLat
                        let yd = curLon-newLon
                        let d = sqrt(xd*xd + yd*yd)
                        if let dist = self.locations[newName] {
                            if (d < dist){
                                self.locations[newName] = d
                            }
                        } else {
                            self.locations[newName] = d
                        }
                        print("A")
                    }
                }
                print("B")
                for (name, dist) in self.locations {
                    print("\(name): \(dist)")
                }
                var i = 0
                for (k,v) in (Array(self.locations).sort {$0.1 < $1.1}) {
                    if (i == 0){
                        dispatch_async(dispatch_get_main_queue()) {
                            self.n1.text = k + "-" + v.description
                        }
                    }
                    if (i == 1){
                        dispatch_async(dispatch_get_main_queue()) {
                            self.n2.text = k + "-" + v.description
                        }
                     }
                    if (i == 2){
                        dispatch_async(dispatch_get_main_queue()) {
                            self.n3.text = k + "-" + v.description
                        }
                    }
                    if (i == 3){
                        dispatch_async(dispatch_get_main_queue()) {
                            self.n4.text = k + "-" + v.description
                        }
                    }
                    if (i == 4){
                        dispatch_async(dispatch_get_main_queue()) {
                            self.n5.text = k + "-" + v.description
                        }
                    }
                    i += 1
                }

            }
        })
        task.resume()
        
        
    }
            
}



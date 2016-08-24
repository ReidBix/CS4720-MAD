//
//  SearchBeerViewController.swift
//  BeerMe
//
//  Created by Reid Bixler on 4/28/16.
//  Copyright © 2016 Reid Bixler. All rights reserved.
//


import UIKit
import Foundation
import CoreData

class SearchBeerViewController: UITableViewController {
    
    var detailViewController: DetailViewController? = nil
    let searchController = UISearchController(searchResultsController: nil)
    var beers = [BeerItem]()
    var filteredBeers = [BeerItem]()
    
    var str: NSString?
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    func forceRefresh(inout beersGiven: [BeerItem], controller: UITableViewController){
        filteredBeers = beers.filter { beer in
            return beer.name.lowercaseString.containsString("")
        }
        
        tableView.reloadData()
    }
    
    override func viewDidLoad() {

        super.viewDidLoad()
        var i = self.tabBarController!.selectedIndex
        print(self.tabBarController!.selectedIndex)
        if i == 2 {
            self.loadBeer()
            filterContentForSearchText(searchController.searchBar.text!)
        }
        if let splitViewController = splitViewController {
            let controllers = splitViewController.viewControllers
            detailViewController = (controllers[controllers.count - 1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        beers = [
            //BeerItem(name:"Beer", id:"12345", abv:"5", ibu:"3")!,
            //BeerItem(name:"B", id:"222", abv:"22", ibu:"3")!,
            //BeerItem(name:"C", id:"333", abv:"11", ibu:"4")!,
            //BeerItem(name:"D", id:"111", abv:"33", ibu:"5")!,
            //BeerItem(name:"E", id:"321", abv:"44", ibu:"3")!,
        ]
    }
    
    override func viewWillAppear(animated: Bool) {

        clearsSelectionOnViewWillAppear = splitViewController!.collapsed
        super.viewWillAppear(animated)
        self.forceRefresh(&self.beers, controller: self)

    }
    
    override func didReceiveMemoryWarning() {

        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active && searchController.searchBar.text != "" {
            return filteredBeers.count
        }
        return beers.count
    }
    
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {

        filteredBeers = beers.filter { beer in
            return beer.name.lowercaseString.containsString(searchText.lowercaseString)
        }
        
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        let beer: BeerItem
        if searchController.active && searchController.searchBar.text != "" {
            beer = filteredBeers[indexPath.row]
        } else {
            beer = beers[indexPath.row]
        }
        cell.textLabel?.text = beer.name
        cell.detailTextLabel?.text = beer.id
        return cell
    }
    
    // MARK: - Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let beer: BeerItem
                if searchController.active && searchController.searchBar.text != "" {
                    beer = filteredBeers[indexPath.row]
                } else {
                    beer = beers[indexPath.row]
                }
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.detailBeer = beer
                controller.ref = self
                print(beer.name)
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    
    // function to allow for detecting a shake
    override func motionEnded(motion: UIEventSubtype,
                              withEvent event: UIEvent?) {
        var i = self.tabBarController!.selectedIndex
        print(self.tabBarController!.selectedIndex)
        if i == 0 {
            if motion == .MotionShake{
                self.getBeer()
            }
            filterContentForSearchText(searchController.searchBar.text!)
        }
        if i == 2 {
            if motion == .MotionShake{
                self.loadBeer()
            }
            filterContentForSearchText(searchController.searchBar.text!)
        }
    }
    
    func getBeer() {

        var newBeerID: String! = "NA"
        var newBeerName: String! = "NA"
        var newBeerABV: String! = "NA"
        var newBeerIBU: String! = "NA"
        
        let beers = true;
        let postEndpoint: String
        let randomABV = arc4random_uniform(20)
        let ABVString :String = "" + String(randomABV)
        
        
        // Doing a GET
        if (beers){
            postEndpoint = "http://api.brewerydb.com/v2/beers?abv=" + ABVString + "&order=random&randomCount=10&key=bc8f922546c6985e5d402f8bc79262bc"
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
                    for var i = 0; i < postArray.count; ++i {
                        if let postData = postArray[i] as? NSDictionary {
                            print("A")
                            if let postID = postData["id"] as? String {
                                print("The beer ID is \(postID)")
                                dispatch_async(dispatch_get_main_queue(), {
                                    newBeerID = postID
                                })
                            } else {
                                dispatch_async(dispatch_get_main_queue(), {
                                    newBeerID = "NA"
                                })
                            }
                            if let postName = postData["name"] as? String {
                                print("The beer name is \(postName)")
                                dispatch_async(dispatch_get_main_queue(), {
                                    newBeerName = postName
                                })
                            } else {
                                dispatch_async(dispatch_get_main_queue(), {
                                    newBeerName = "NA"
                                })
                            }
                            if let postABV = postData["abv"] as? String {
                                print("The beer ABV is \(postABV)")
                                dispatch_async(dispatch_get_main_queue(), {
                                    newBeerABV = postABV
                                })
                            } else {
                                dispatch_async(dispatch_get_main_queue(), {
                                    newBeerABV = "NA"
                                })
                            }
                            print("HI")
                            if let postIBU = postData["ibu"] as? String {
                                print("The beer IBU is \(postIBU)")
                                dispatch_async(dispatch_get_main_queue(), {
                                    newBeerIBU = postIBU
                                })
                            } else {
                                dispatch_async(dispatch_get_main_queue(), {
                                    newBeerIBU = "NA"
                                })
                            }
                            print("BYE")
                        }
                        //print(newBeerName)
                        do {
                            print(newBeerName)
                            let newBeer = BeerItem(name:newBeerName, id:newBeerID, abv:newBeerABV, ibu:newBeerIBU)!
                            self.beers.append(newBeer)
                            print("Added beer")
                        }  catch {
                            print("FAILURE")
                        }
                    }
                } else {
                    if let postData = post["data"] as? NSDictionary {
                        print("B")
                        if let postID = postData["id"] as? String {
                            print("The beer ID is \(postID)")
                            dispatch_async(dispatch_get_main_queue(), {
                                newBeerID = postID
                            })
                        } else {
                            dispatch_async(dispatch_get_main_queue(), {
                                newBeerID = "NA"
                            })
                        }
                        if let postName = postData["name"] as? String {
                            print("The beer name is \(postName)")
                            dispatch_async(dispatch_get_main_queue(), {
                                newBeerName = postName
                            })
                        } else {
                            dispatch_async(dispatch_get_main_queue(), {
                                newBeerName = "NA"
                            })
                        }
                        if let postABV = postData["abv"] as? String {
                            print("The beer ABV is \(postABV)")
                            dispatch_async(dispatch_get_main_queue(), {
                                newBeerABV = postABV
                            })
                        } else {
                            dispatch_async(dispatch_get_main_queue(), {
                                newBeerABV = "NA"
                            })
                        }
                        if let postIBU = postData["ibu"] as? String {
                            print("The beer IBU is \(postIBU)")
                            dispatch_async(dispatch_get_main_queue(), {
                                newBeerIBU = postIBU
                            })
                        } else {
                            dispatch_async(dispatch_get_main_queue(), {
                                newBeerIBU = "NA"
                            })
                        }
                    }

                }
                
            }
            
            if let postName = post["name"] as? String {
                print("The name is \(postName)")
            }
            self.filterContentForSearchText(self.searchController.searchBar.text!)
            self.forceRefresh(&self.beers, controller: self)
        })
        
        task.resume()
    }
    
    
    func loadBeer() {
        print("Executing loadBeer")
        
        /* Create the fetch request first */
        let fetchRequest = NSFetchRequest(entityName: "Beer")
        
        let abvSort = NSSortDescriptor(key: "abv", ascending: true)
        
        let nameSort = NSSortDescriptor(key: "name", ascending: true)
        
        fetchRequest.sortDescriptors = [abvSort, nameSort]
        
        /* And execute the fetch request on the context */
        do{
            let beers = try managedObjectContext.executeFetchRequest(fetchRequest) as! [Beer]
            self.beers.removeAll()
            for beer in beers{
                print("Name = \(beer.name)")
                print("ID = \(beer.id)")
                print("ABV = \(beer.abv)")
                print("IBU = \(beer.ibu)")
                let newBeer = BeerItem(name: beer.name, id: beer.id, abv: beer.abv, ibu: beer.ibu)!
                self.beers.append(newBeer)
            }
        } catch let error as NSError{
            print(error)
        }
        self.forceRefresh(&self.beers, controller: self)
        print("Finishing loadBeer")
    }

    
    
}

extension SearchBeerViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}




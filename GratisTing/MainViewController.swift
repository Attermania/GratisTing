//
//  MainViewController.swift
//  GratisTing
//
//  Created by Steffen on 11/05/16.
//  Copyright © 2016 SJT. All rights reserved.
//

import UIKit


class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var dao: DAOProtocol!
    var auth: Authentication!
    
    var itemToPassOn: Item?
    
    var categories: [Category] = [] {
        didSet {
            categoriesTableView.reloadData()
        }
    }
    
    @IBAction func createItem(sender: AnyObject) {
        // Check if token is set - present create view controler        
        if auth.getToken() != nil {
            let storyboard = UIStoryboard(name: "Create", bundle: nil)
            let controller = storyboard.instantiateViewControllerWithIdentifier("Create") as! UINavigationController
            self.presentViewController(controller, animated: true, completion: nil)
            
            return
        }
        
        // If token is not set - show alert instructring user to create error.
        let alertController = UIAlertController(title: "Bruger påkrævet", message: "Du skal være logget ind for at oprette en gratis ting.", preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    @IBOutlet weak var categoriesTableView: UITableView!
    
    /**
     Method that should be called when returning from another viewController that has information.
    */
    func returnedWithAction(action: String, object: AnyObject?) {
        switch action {
        case "LoggedIn":
            let alertController = UIAlertController(title: "Velkommen", message: "Du er nu logget ind", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            presentViewController(alertController, animated: true, completion: nil)
        case "LoggedOut":
            let alertController = UIAlertController(title: "På gensyn", message: "Du er nu logget ud", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            presentViewController(alertController, animated: true, completion: nil)
        case "ItemCreated":
            let item = object as! Item
            itemToPassOn = item
            performSegueWithIdentifier("goToItem", sender: self)
        default:
            return
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // We need to set Authentication and DAO here because they are not set in AppDelegate when this class is instantiated
        auth = AppDelegate.authentication
        dao  = AppDelegate.dao

        categoriesTableView.delegate = self
        categoriesTableView.dataSource = self

        loadCategories()
        // Do any additional setup after loading the view.
    }

    @IBAction func goToLogin(sender: AnyObject) {
        if auth.user == nil {
            let storyboard = UIStoryboard(name: "Authentication", bundle: nil)
            let controller = storyboard.instantiateViewControllerWithIdentifier("Login") as! UINavigationController
            self.presentViewController(controller, animated: true, completion: nil)
            return
        }
        let storyboard = UIStoryboard(name: "User", bundle: nil)
        let controller = storyboard.instantiateViewControllerWithIdentifier("User") as! UINavigationController
        self.presentViewController(controller, animated: true, completion: nil)
        
    }
    
    func loadCategories() {
        dao.getAllCategories { (categories: [Category]?, error: NSError?) in
            if let _ = error {
                return
            }
            
            self.categories = categories!
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = categories[indexPath.row].title
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("goToMap", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "goToMap" {
            let mapVC = segue.destinationViewController as! MapViewController
            mapVC.category = self.categories[(categoriesTableView.indexPathForSelectedRow?.row)!]
        } else if segue.identifier == "goToItem" {
            let showItemVC = segue.destinationViewController as! ShowViewController
            showItemVC.item = itemToPassOn
            itemToPassOn = nil
        }
    }
    


    

}

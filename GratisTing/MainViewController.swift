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
        case "OpenCreateItem":
            let storyboard = UIStoryboard(name: "Create", bundle: nil)
            let controller = storyboard.instantiateViewControllerWithIdentifier("Create") as! UINavigationController
            self.presentViewController(controller, animated: true, completion: nil)
        default:
            return
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        GratisTingNavItem.setupPresentation(true, vc: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // We need to set Authentication and DAO here because they are not set in AppDelegate when this class is instantiated
        auth = AppDelegate.authentication
        dao  = AppDelegate.dao

        categoriesTableView.delegate = self
        categoriesTableView.dataSource = self

        loadCategories()
        
        // Set background
        let backgroundImage = UIImageView(frame: UIScreen.mainScreen().bounds)
        backgroundImage.image = UIImage(named: "bg")
        self.view.insertSubview(backgroundImage, atIndex: 0)
        
        // Fjern linjer hvor der ikke er indohold
        categoriesTableView.tableFooterView = UIView(frame: CGRectZero)
        
        // Make navigation bar transparent.
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "transparent.png"), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage(named: "transparent.png")
        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.view.backgroundColor = UIColor.clearColor()

        // Do any additional setup after loading the view.
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
        
        cell.backgroundColor = UIColor.grayColor()
        
        cell.textLabel?.textColor = UIColor.whiteColor()
        
        switch categories[indexPath.row].title {
        case "Møbler":
            cell.imageView?.image = UIImage(named: "puzzle")
        case "Tøj & Sko":
            cell.imageView?.image = UIImage(named: "handbag")
        case "Fotoudstyr":
            cell.imageView?.image = UIImage(named: "camera")
        case "Dyr & Tilbehør":
            cell.imageView?.image = UIImage(named: "ghost")
        case "Bøger & Magasiner":
            cell.imageView?.image = UIImage(named: "graduation")
        default:
            cell.imageView?.image = nil
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        performSegueWithIdentifier("goToMap", sender: self)
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor(white: 1, alpha: 0.2)

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "goToMap" {
            let mapNav = segue.destinationViewController as! UINavigationController
            let mapVC = mapNav.viewControllers.first as! MapViewController
            mapVC.category = self.categories[(categoriesTableView.indexPathForSelectedRow?.row)!]
        } else if segue.identifier == "goToItem" {
            let showItemVC = segue.destinationViewController as! ShowViewController
            showItemVC.item = itemToPassOn
            itemToPassOn = nil
        }
    }
    


    

}

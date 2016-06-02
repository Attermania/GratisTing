//
//  MainViewController.swift
//  GratisTing
//
//  Created by Steffen on 11/05/16.
//  Copyright © 2016 SJT. All rights reserved.
//

import UIKit


class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var dao: DAOProtocol = AppDelegate.dao
    var auth: Authentication = AppDelegate.authentication
    
    var itemToPassOn: Item?
    
    var categories: [Category] = [] {
        didSet {
            categoriesTableView.reloadData()
        }
    }
        
    @IBOutlet weak var categoriesTableView: UITableView!
    
    override func viewWillAppear(animated: Bool) {
        GratisTingNavItem.currentVC = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        categoriesTableView.delegate = self
        categoriesTableView.dataSource = self

        loadCategories()
        
        // Set background
        let backgroundImage = UIImageView(frame: UIScreen.mainScreen().bounds)
        backgroundImage.image = UIImage(named: "bg")
        self.view.insertSubview(backgroundImage, atIndex: 0)
        
        let logo = UIBarButtonItem(image: UIImage(named: "logo1"), landscapeImagePhone: UIImage(named: "logo1"), style: .Plain, target: self, action:nil)
        self.navigationItem.leftBarButtonItem = logo
        
        // Fjern linjer hvor der ikke er indohold
        categoriesTableView.tableFooterView = UIView(frame: CGRectZero)
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
            let mapVC = segue.destinationViewController as! MapViewController
            mapVC.category = self.categories[(categoriesTableView.indexPathForSelectedRow?.row)!]
        } else if segue.identifier == "goToItem" {
            let showItemVC = segue.destinationViewController as! ShowViewController
            showItemVC.item = itemToPassOn
            itemToPassOn = nil
        }
    }
    


    

}

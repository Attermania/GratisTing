//
//  MainViewController.swift
//  GratisTing
//
//  Created by Steffen on 11/05/16.
//  Copyright © 2016 SJT. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let dao = AppDelegate.dao
    
    var categories: [Category] = [] {
        didSet {
            
        }
    }

    @IBAction func createItem(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Create", bundle: nil)
        let controller = storyboard.instantiateViewControllerWithIdentifier("Create") as! UINavigationController
        self.presentViewController(controller, animated: true, completion: nil)
    }
    @IBOutlet weak var categoriesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dao.initDummyData()
        categories = dao.getAllCategories()
        
        categoriesTableView.delegate = self
        categoriesTableView.dataSource = self
        // Do any additional setup after loading the view.
    }

    @IBAction func goToLogin(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Authentication", bundle: nil)
        let controller = storyboard.instantiateViewControllerWithIdentifier("Login") as! UINavigationController
        self.presentViewController(controller, animated: true, completion: nil)
        
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
        let storyboard = UIStoryboard(name: "Map", bundle: nil)
        let controller = storyboard.instantiateViewControllerWithIdentifier("Map") as! UINavigationController
        self.presentViewController(controller, animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

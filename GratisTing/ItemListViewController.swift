//
//  ItemListViewController.swift
//  GratisTing
//
//  Created by Thomas Attermann on 11/05/2016.
//  Copyright © 2016 SJT. All rights reserved.
//

import UIKit

class ItemListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var itemTableView: UITableView!
    
    @IBAction func navigateToMapButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    var items: [Item] = [] {
        didSet {
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemTableView.dataSource = self
        itemTableView.delegate = self

        initDummyData()
        // Do any additional setup after loading the view.
    }
    
    // Function for initializing dummy data
    func initDummyData() {
        let jon = User(firstName: "Jon", lastName: "Snow", email: "Jon@snow.dk", phoneNumber: 12345)
        let chair = Item(title: "Ægget", description: "Slidt men flot", imageURL: "", createdAt: NSDate(), owner: jon)
        let sword = Item(title: "Heartbreaker", description: "Perfekt stand og meget flot sværd. Det er bare rigtig godt.", imageURL: "", createdAt: NSDate(), owner: jon)
        let pony = Item(title: "Pony", description: "Flot hest", imageURL: "", createdAt: NSDate(), owner: jon)
        items.append(chair)
        items.append(sword)
        items.append(pony)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("itemcell", forIndexPath: indexPath) as! GratisTingCell
        //cell.textLabel?.text = items[indexPath.row].title
        cell.titleLabel.text = items[indexPath.row].title
        cell.descriptionLabel.text = items[indexPath.row].description
        
        return cell

    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destVC = segue.destinationViewController as! ItemViewController
        destVC.item = items[(itemTableView.indexPathForSelectedRow?.row)!]
    }
    
}

import UIKit
import MapKit

class ItemListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Dependencies
    let dao = AppDelegate.dao
    let auth = AppDelegate.authentication
    let locationManager = CLLocationManager()
    
    // MARK: Instance variables
    var hasLocation: Bool!
    var lat: Double?
    var long: Double?
    var distanceToPass = ""
    var category: Category?
    
    var items: [Item] = [] {
        didSet {
            itemTableView.reloadData()
        }
    }

    // MARK: IB Outlets
    @IBOutlet weak var itemTableView: UITableView!
    
    // MARK: IB Actions
    @IBAction func navigateToMapButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        itemTableView.dataSource = self
        itemTableView.delegate = self
        fetchItems()
        itemTableView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        fetchItems()
    }
    
    override func viewWillAppear(animated: Bool) {
        GratisTingNavItem.currentVC = self
    }
    
    func fetchItems() {
        // user has allowed to use his/her location
        if hasLocation! {
            dao.getItemsFromLocation(category?.id, latitude: lat!, longitude: long!, radius: 1000, completion: { (items: [Item]?, error: NSError?) in
                if let _ = error {
                    // An error was returned
                    return
                }
                
                self.items = items!
            })
            return
        }
        // user has not allowed to use his/her location
        dao.getItems(category) { (items: [Item]?, error: NSError?) in
            if let _ = error {
                // An error was returned
                return
            }
            
            self.items = items!
        }
    }
    
    
    
    // MARK: Delegate Methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("itemcell", forIndexPath: indexPath) as! GratisTingCell
        cell.titleLabel.text = items[indexPath.row].title
        cell.descriptionLabel.text = items[indexPath.row].description
        cell.cityLabel.text = items[indexPath.row].address!.cityName
        
        if hasLocation! {
            let distance = items[indexPath.row].getDistanceInKm(long, destLatitude: lat)!
            // format in kilometer if distance is 1 or more.
            if distance >= 1 {
                let dist = String(format:"%.1f", distance) + " km"
                cell.distanceLabel.text = dist
                distanceToPass = dist
            } else {
                // format distance in meters if less than 1 km.
                let dist = String(format:"%.0f", distance*1000) + " m"
                cell.distanceLabel.text = dist
                distanceToPass = dist
            }
        }
        
        return cell

    }    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showItem" {
            let showItemViewController = segue.destinationViewController as! ShowViewController
            showItemViewController.item = items[(itemTableView.indexPathForSelectedRow?.row)!]
            showItemViewController.distanceFromPreviousView = distanceToPass
        }
    }
}

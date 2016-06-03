import UIKit


class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Dependencies
    var dao: DAOProtocol = AppDelegate.dao
    var auth: Authentication = AppDelegate.authentication
    
    // MARK: Instance variables
    var itemToPassOn: Item?
    
    var categories: [Category] = [] {
        didSet {
            categoriesTableView.reloadData()
        }
    }
    
    // MARK: IB Outlets
    @IBOutlet weak var categoriesTableView: UITableView!
    
    
    // MARK: Methods
    override func viewWillAppear(animated: Bool) {
        GratisTingNavItem.currentVC = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set delegate
        categoriesTableView.delegate = self
        categoriesTableView.dataSource = self

        // Load the categories from the api
        loadCategories()
        
        // Set background
        let backgroundImage = UIImageView(frame: UIScreen.mainScreen().bounds)
        backgroundImage.image = UIImage(named: "bg")
        self.view.insertSubview(backgroundImage, atIndex: 0)
        
        // Show the logo in upper left corner - TODO: Should not be a UIBarButton
        let logo = UIBarButtonItem(image: UIImage(named: "logo1"), landscapeImagePhone: UIImage(named: "logo1"), style: .Plain, target: self, action:nil)
        self.navigationItem.leftBarButtonItem = logo
        
        // Remove the border in table view cells, on the empty cells
        categoriesTableView.tableFooterView = UIView(frame: CGRectZero)
    }
    
    // Get the categories from the DAO
    func loadCategories() {
        dao.getAllCategories { (categories: [Category]?, error: NSError?) in
            // If errors, we return early
            if let _ = error {
                return
            }
            
            self.categories = categories!
        }
    }
    
    // MARK: Category table view delegate methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        // Get the category
        let category = categories[indexPath.row]
        
        // Prettify the cell
        cell.textLabel?.text = category.title
        cell.backgroundColor = UIColor.grayColor()
        cell.textLabel?.textColor = UIColor.whiteColor()
        
        // For now, the images are hardcoded, since the api does not return images yet
        switch category.title {
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
        
        // Return the pretty cell
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("goToMap", sender: self)
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor(white: 1, alpha: 0.2)
    }
    
    // MARK: Prepare for segue
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
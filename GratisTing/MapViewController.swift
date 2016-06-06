import UIKit
import MapKit
import FBAnnotationClusteringSwift
import Alamofire

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UIGestureRecognizerDelegate {

    // MARK: - Instance variables
    let dao = AppDelegate.dao
    let clusteringManager = FBClusteringManager()
    let locationManager = CLLocationManager()
    var relocation = false
    
    var item: Item?
    
    var items = [Item]() {
        didSet {
            addItemsToMap(items)
        }
    }
    
    var category: Category?
    
    // MARK: - IB Outlets
    @IBOutlet weak var relocate123: GratisTingMapButton!
    @IBOutlet weak var search: UISearchBar!
    @IBOutlet weak var listViewIcon: GratisTingMapButton!
    @IBOutlet weak var itemMap: MKMapView!
    
    // MARK: - IB Actions
    @IBAction func listViewButton(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Browse", bundle: nil)
        let controller = storyboard.instantiateViewControllerWithIdentifier("BrowseNavigator") as! UINavigationController
        self.presentViewController(controller, animated: true, completion: nil)
    }
    // Relocate button action
    @IBAction func getCurrentPosition(sender: AnyObject) {
        if CLLocationManager.authorizationStatus() == .Denied {
            UIApplication.sharedApplication().openURL(NSURL(string:UIApplicationOpenSettingsURLString)!)
            return
        }
        
        if let userLocation = locationManager.location?.coordinate {
            let region = MKCoordinateRegion(center: userLocation, span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03))
            self.itemMap.setRegion(region, animated: true)
        }
        
    }
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        itemMap.delegate = self
        locationManager.delegate = self
        
        search.backgroundColor = UIColor.clearColor()
        search.barTintColor = UIColor.clearColor()
        search.backgroundImage = UIImage()
        
        // add list view and relocate button on top of map
        self.view.bringSubviewToFront(relocate123)
        self.view.bringSubviewToFront(listViewIcon)
        
        // prompt the user to use his/her location
        self.locationManager.requestAlwaysAuthorization()
    }
    
    override func viewWillAppear(animated: Bool) {
        GratisTingNavItem.currentVC = self
    }
    
    func addItemsToMap(items: [Item]) {
        var annotations: [MKPointAnnotation] = []
        
        // Create annotations from items
        for item in items {
            let itemCoordinate = CLLocationCoordinate2DMake(item.address!.latitude, item.address!.longitude)

            let itemAnnotation = GratisTingAnnotation()
            itemAnnotation.title = item.title
            itemAnnotation.subtitle = item.description
            itemAnnotation.coordinate = itemCoordinate
            itemAnnotation.item = item

            annotations.append(itemAnnotation)
        }
        
        // Add annotations to clustering manager
        clusteringManager.setAnnotations(annotations)
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let itemImageView = UIImageView(frame: CGRectMake(0, 0, 80, 50))
        var reuseId = ""
        
        // use the default blue dot for the user location
        if annotation.isKindOfClass(MKUserLocation) {
            return nil
        }
        // cluster annotation
        else if annotation.isKindOfClass(FBAnnotationCluster) {
            reuseId = "Cluster"
            var clusterView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
            clusterView = FBAnnotationClusterView(annotation: annotation, reuseIdentifier: reuseId, options: nil)
            return clusterView
            // pin annotation
        } else {
            reuseId = "Pin"
            var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
            pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.image = UIImage(named: "pin")
            itemImageView.image = UIImage(named: "piano")
            itemImageView.contentMode = .ScaleAspectFill
            itemImageView.userInteractionEnabled = true
            pinView?.leftCalloutAccessoryView = itemImageView
            pinView?.canShowCallout = true
            pinView?.tintColor = UIColor.greenColor()
            
            return pinView
        }
    }
    
    // fetch new items based on the visible map
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        NSOperationQueue().addOperationWithBlock({
            
            // Get coordinates from center of map
            let centerMap = self.itemMap.centerCoordinate
            // Get the items - TODO: Find the radius visible on the map
            self.dao.getItemsFromLocation(
                self.category?.id,
                latitude: centerMap.latitude,
                longitude: centerMap.longitude,
                radius: 1000,
                completion: { (items: [Item]?, error: NSError?) in
                    if let _ = error {
                        return
                    }
                    
                    self.items = items!
            })
            
            // display either pins or a cluster based on the zoom level
            let mapBoundsWidth = Double(self.itemMap.bounds.size.width)
            let mapRectWidth:Double = self.itemMap.visibleMapRect.size.width
            let scale:Double = mapBoundsWidth / mapRectWidth
            let annotationArray = self.clusteringManager.clusteredAnnotationsWithinMapRect(self.itemMap.visibleMapRect, withZoomScale:scale)
            self.clusteringManager.displayAnnotations(annotationArray, onMapView:self.itemMap)
        })
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        // if a clusterview is selected, zoom in on its pins
        if view is FBAnnotationClusterView {
            let itemLocation = view.annotation?.coordinate
            let region = MKCoordinateRegion(center: itemLocation!, span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03))
            self.itemMap.setRegion(region, animated: true)
        }
        // add a gesturerecognizer to the annotation so it is clickable
        // if the view has no gesturerecognizers, we add one.
        if view.gestureRecognizers == nil {
            let tapGestrue = UITapGestureRecognizer(target: self, action: #selector(MapViewController.showItem(_:)))
            tapGestrue.numberOfTapsRequired = 1
            tapGestrue.delegate = self
            view.addGestureRecognizer(tapGestrue)
        } else {
            view.gestureRecognizers?.first?.enabled = true
        }
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 55.7, longitude: 12.5), span: MKCoordinateSpan(latitudeDelta: 0.25, longitudeDelta: 0.25))
        
        // if the user has allowed to use his/her location we enter this block of code
        if status == .AuthorizedAlways {
            // Set accuracy
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            
            // Show the user on the map
            itemMap.showsUserLocation = true
            
            // Automatically update users location on the map
            locationManager.startUpdatingLocation()
            
            // Try to get the coordinates for the users location
            if let userLocation = locationManager.location?.coordinate {
                region = MKCoordinateRegion(center: userLocation, span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03))
            }

        }
        // update the visiable map based on if the user has allowed his/her location
        self.itemMap.setRegion(region, animated: true)
    }
    
    func mapView(mapView: MKMapView, didDeselectAnnotationView view: MKAnnotationView) {
        // deselect the annotationview
        self.itemMap.deselectAnnotation(view.annotation, animated: false)
        // set the annotations gesurerecognizer to disabled.
        view.gestureRecognizers?.first?.enabled = false
        
    }
    
    // show the selected annotation item
    func showItem(sender: UITapGestureRecognizer) {
        if sender.view is MKAnnotationView {
            let view = sender.view as! MKAnnotationView
            if view.annotation is GratisTingAnnotation {
                let pin = view.annotation as! GratisTingAnnotation
                item = pin.item
                performSegueWithIdentifier("showItem", sender: self)
            }
        }
        
    }
    
    // Pass along data to desired viewcontroller
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showItem" {
            let showItemViewController = segue.destinationViewController as! ShowViewController
            showItemViewController.item = item
        }
        
        if segue.identifier == "goToListView" {
            let listViewItemController = segue.destinationViewController as! ItemListViewController
            listViewItemController.category = self.category
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }

}

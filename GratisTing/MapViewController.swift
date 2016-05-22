//
//  MapViewController.swift
//  GratisTing
//
//  Created by Steffen on 11/05/16.
//  Copyright © 2016 SJT. All rights reserved.
//

import UIKit
import MapKit
import FBAnnotationClusteringSwift
import Alamofire

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UIGestureRecognizerDelegate {

    let dao = DAO.instance
    let clusteringManager = FBClusteringManager()
    let locationManager = CLLocationManager()
    var relocation = false
    var lat: Double = 10
    var long: Double = 10
    
    var item: Item?
    
    var items = [Item]() {
        didSet {
            addItemsToMap(items)
        }
    }
    
    var category: Category?
    
    @IBOutlet weak var itemMap: MKMapView!
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemMap.delegate = self
        locationManager.delegate = self
        
        self.locationManager.requestAlwaysAuthorization()
    }
    
    func addItemsToMap(items: [Item]) {
        var annotations: [MKPointAnnotation] = []
        
        // Create annotations from items
        for item in items {
            let itemCoordinate = CLLocationCoordinate2DMake(item.latitude, item.longitude)

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


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let itemImageView = UIImageView(frame: CGRectMake(0, 0, 80, 50))
        var reuseId = ""
        
        if annotation.isKindOfClass(MKUserLocation) {
            return nil
        }
        else if annotation.isKindOfClass(FBAnnotationCluster) {
            reuseId = "Cluster"
            var clusterView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
            clusterView = FBAnnotationClusterView(annotation: annotation, reuseIdentifier: reuseId, options: nil)
            return clusterView
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
    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        lat = (userLocation.location?.coordinate.latitude)!
        long = (userLocation.location?.coordinate.longitude)!
    }
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        NSOperationQueue().addOperationWithBlock({
            
            // Get coordinates from center of map
            let centerMap = self.itemMap.centerCoordinate
            // Create location from centermap coords.
            let currentLocation = CLLocation(latitude: centerMap.latitude, longitude: centerMap.longitude)
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
            
            let mapBoundsWidth = Double(self.itemMap.bounds.size.width)
            let mapRectWidth:Double = self.itemMap.visibleMapRect.size.width
            let scale:Double = mapBoundsWidth / mapRectWidth
            let annotationArray = self.clusteringManager.clusteredAnnotationsWithinMapRect(self.itemMap.visibleMapRect, withZoomScale:scale)
            self.clusteringManager.displayAnnotations(annotationArray, onMapView:self.itemMap)
        })
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        
        if view is FBAnnotationClusterView {
            let itemLocation = view.annotation?.coordinate
            let region = MKCoordinateRegion(center: itemLocation!, span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03))
            self.itemMap.setRegion(region, animated: true)
        }
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
        var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 55.7, longitude: 12.5), span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03))
        
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
                lat = userLocation.latitude
                long = userLocation.longitude
            }

        }
        
        self.itemMap.setRegion(region, animated: true)
    }
    
    func mapView(mapView: MKMapView, didDeselectAnnotationView view: MKAnnotationView) {
        self.itemMap.deselectAnnotation(view.annotation, animated: false)
        view.gestureRecognizers?.first?.enabled = false
        
    }
    
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showItem" {
            let showItemViewController = segue.destinationViewController as! ShowViewController
            showItemViewController.item = item
        }
        if segue.identifier == "goToListView" {
            let listViewItemController = segue.destinationViewController as! ItemListViewController
            listViewItemController.category = self.category
            
            if CLLocationManager.authorizationStatus() == .AuthorizedAlways {
                listViewItemController.hasLocation = true
                listViewItemController.lat = self.lat
                listViewItemController.long = self.long
                return
            }

            listViewItemController.hasLocation = false

        }
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

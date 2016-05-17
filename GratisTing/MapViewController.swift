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
    var firstLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var lastLocation: CLLocation = CLLocation(latitude: 0, longitude: 0)
    
    @IBOutlet weak var itemMap: MKMapView!
    @IBAction func listViewButton(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Browse", bundle: nil)
        let controller = storyboard.instantiateViewControllerWithIdentifier("BrowseNavigator") as! UINavigationController
        self.presentViewController(controller, animated: true, completion: nil)
    }
    @IBAction func getCurrentPosition(sender: AnyObject) {

        Alamofire.request(.GET, "https://httpbin.org/get", parameters: ["foo": "bar"])
            .validate()
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                }
        }
        relocation = true
    }
    
    @IBAction func clickButton(sender: AnyObject) {
//        print(self.itemMap.annotationsInMapRect(itemMap.visibleMapRect).count)
    }
    
    @IBAction func backButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemMap.delegate = self
        
        askUserForLocation()
    }
    
    override func viewDidAppear(animated: Bool) {
        let items = dao.getItemsByCategory(nil, latitude: 1.5, longitide: 1.6)
        
        addItemsToMap(items)
    }
    
    func askUserForLocation() {
        self.locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            //print("okay")
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            itemMap.showsUserLocation = true
            relocation = true
            locationManager.startUpdatingLocation()
        }
    }
    
    func addItemsToMap(items: [Item]) {
        for item in items {
            
            let itemCoordinate = CLLocationCoordinate2DMake(item.latitude, item.longitude)
            
//            let pin = FBAnnotation()
//            pin.coordinate = itemCoordinate
//            pin.title = item.title
//            clusteringManager.addAnnotations([pin])

            let itemAnnotation = MKPointAnnotation()
            itemAnnotation.title = item.title
            itemAnnotation.subtitle = item.description
            itemAnnotation.coordinate = itemCoordinate

            clusteringManager.addAnnotations([itemAnnotation])
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        print("update user location")
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
        
//        let itemImageView = UIImageView(frame: CGRectMake(0, 0, 80, 80))
//        if (annotation is MKUserLocation) {
//            return nil
//        }
//        
//        let reuseId = "itemPin"
//        var itemPinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
//        if itemPinView != nil {
//            itemPinView?.annotation = annotation
//            
//        } else {
//            itemPinView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
//            itemPinView?.image = UIImage(named: "pin")
//            itemPinView?.canShowCallout = true
//            itemImageView.image = UIImage(named: "piano")
//            itemImageView.contentMode = .ScaleAspectFill
//            itemPinView?.leftCalloutAccessoryView = itemImageView
//        }
//        return itemPinView
    }
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        NSOperationQueue().addOperationWithBlock({
            // Get coordinates from center of map
            let centerMap = self.itemMap.centerCoordinate
            // Create location from centermap coords.
            let currentLocation = CLLocation(latitude: centerMap.latitude, longitude: centerMap.longitude)
            
            // calculate distance between
            let distance = currentLocation.distanceFromLocation(self.lastLocation)/1609.344
            print(distance)
            // Update last location to current location (to be compared later)
            self.lastLocation = currentLocation
            let mapBoundsWidth = Double(self.itemMap.bounds.size.width)
            let mapRectWidth:Double = self.itemMap.visibleMapRect.size.width
            let scale:Double = mapBoundsWidth / mapRectWidth
            let annotationArray = self.clusteringManager.clusteredAnnotationsWithinMapRect(self.itemMap.visibleMapRect, withZoomScale:scale)
            self.clusteringManager.displayAnnotations(annotationArray, onMapView:self.itemMap)
        })
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        let itemLocation = view.annotation?.coordinate
        let region = MKCoordinateRegion(center: itemLocation!, span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03))
        self.itemMap.setRegion(region, animated: true)
        if view.gestureRecognizers == nil {
            let tapGestrue = UITapGestureRecognizer(target: self, action: #selector(MapViewController.showItem(_:)))
            tapGestrue.numberOfTapsRequired = 1
            tapGestrue.delegate = self
            view.addGestureRecognizer(tapGestrue)
        } else {
            view.gestureRecognizers?.first?.enabled = true
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = manager.location?.coordinate
        let region = MKCoordinateRegion(center: userLocation!, span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03))
        if relocation {
            self.itemMap.setRegion(region, animated: true)
            relocation = false
        }
    }
    
    func mapView(mapView: MKMapView, didDeselectAnnotationView view: MKAnnotationView) {
        self.itemMap.deselectAnnotation(view.annotation, animated: false)
        view.gestureRecognizers?.first?.enabled = false
    }
    
    func showItem(sender: UITapGestureRecognizer) {
        performSegueWithIdentifier("showItem", sender: self)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showItem" {
            let showItemViewController = segue.destinationViewController as! ShowViewController
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

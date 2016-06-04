import UIKit
import CoreLocation

class ShowViewController: UIViewController {
    
    // MARK: Dependencies
    let locationManager = CLLocationManager()
    
    // MARK: Instance variables
    var item: Item!
    var hasLocation: Bool?
    var lat: Double?
    var long: Double?
    var distanceFromPreviousView = ""

    // MARK: IB Outlets
    @IBOutlet weak var itemDescriptionText: UITextView! {
        didSet {
            itemDescriptionText.textContainer.lineFragmentPadding = 0
        }
    }
    @IBOutlet weak var itemTitleLabel: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemOwnerLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userAddressLabel: UILabel!
    @IBOutlet weak var contactButton: UIButton!
    @IBOutlet weak var labelOwnerCity: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    // MARK: Methods
    override func loadView() {
        super.loadView()
        contactButton.layer.cornerRadius = 5
    }
    
    override func viewWillAppear(animated: Bool) {
        GratisTingNavItem.currentVC = self
    }
    
    override func viewDidLoad() {
        // Setup UI
        itemTitleLabel.text = item.title
        itemDescriptionText.text = item.description
        itemTitleLabel.text = item.title
        itemDescriptionText.text = item.description
        itemOwnerLabel.text = item.owner?.name
        userAddressLabel.text = "\((item.address?.postalCode)!) \((item.address?.cityName)!)"
        
        if CLLocationManager.locationServicesEnabled() && locationManager.location != nil {
            let lat  = locationManager.location!.coordinate.latitude
            let long = locationManager.location!.coordinate.longitude
            
            let distance = item.getDistanceInKm(long, destLatitude: lat)!
            
            // format in kilometer if distance is 1 or more.
            if distance >= 1 {
                let dist = String(format:"%.1f", distance) + " km"
                distanceLabel.text = dist
            } else {
                // format distance in meters if less than 1 km.
                let dist = String(format:"%.0f", distance*1000) + " m"
                distanceLabel.text = dist
            }
        }
        
        // Setup image
        let image: UIImage = UIImage(named: "user-1")!
        userImageView.layer.borderWidth = 1.0
        userImageView.layer.masksToBounds = false
        userImageView.layer.borderColor = UIColor.whiteColor().CGColor
        userImageView.layer.cornerRadius = userImageView.frame.size.width/2
        userImageView.clipsToBounds = true
        userImageView.image = image
    }

}

import UIKit
import Alamofire
import SwiftyJSON

class RegisterViewController: UIViewController {
    
    // MARK: Dependencies
    let dao = AppDelegate.dao
    
    // MARK: Instance variables
    var userCreated = false
    
    // MARK: IB Outlets
    @IBOutlet weak var addressTextfield: AddressSearchTextField!
    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var viewTitleLabel: UILabel!

    // MARK: IB Actions
    @IBAction func createUserPressed(sender: AnyObject) {
        
        let selectedAddress = addressTextfield.address
        // check if a address has been selected
        if selectedAddress == nil || addressTextfield.text == nil || addressTextfield.text == "" {
            return
        }
        // TODO: Add validation
        let user = User(email: emailTextfield.text!, password: passwordTextfield.text!, name: nameTextfield.text!, address: selectedAddress!)
        
        // Send the user object above, dao will then send a request to our API with this object's information
        dao.createUser(user) { (user, error) in
            if error != nil {
                // Something went wrong, show an error to the user
                let alertController = UIAlertController(title: "Fejl", message: "Udfyld venligst alle felter", preferredStyle: .Alert)
                let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alertController.addAction(defaultAction)
                
                self.presentViewController(alertController, animated: true, completion: nil)
                
                return
            }
            
            // If no error was present, the user was created and we pop to the navigationcontroller's rootviewcontroller(LoginViewController)
            let navigationController = self.parentViewController as! UINavigationController
            
            let alertController = UIAlertController(title: "Tillykke", message: "Din bruger er nu oprettet", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: { (action) in
                navigationController.popToRootViewControllerAnimated(true)
            })
            
            alertController.addAction(defaultAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    // MARK: Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"keyboardWillAppear:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"keyboardWillDisappear:", name: UIKeyboardWillHideNotification, object: nil)
        configureCustomSearchTextField()
        registerButton.layer.cornerRadius = 5
        registerButton.backgroundColor = UIColor(hexString: "#FFCC26")
        
        // Set color of button in top left corner.
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor(hexString: "FFCC26")
        self.navigationItem.backBarButtonItem?.tintColor = UIColor(hexString: "FFCC26")
    }
    
    private func configureCustomSearchTextField() {
        // Set theme - Default: light
        addressTextfield.theme = SearchTextFieldTheme.lightTheme()
        
        // Modify current theme properties
        addressTextfield.theme.font = UIFont.systemFontOfSize(14)
        addressTextfield.theme.bgColor = UIColor (red: 0.9, green: 0.9, blue: 0.9, alpha: 0.3)
        addressTextfield.theme.borderColor = UIColor (red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        addressTextfield.theme.separatorColor = UIColor (red: 0.9, green: 0.9, blue: 0.9, alpha: 0.5)
        addressTextfield.theme.cellHeight = 50
        
        // Max number of results - Default: No limit
        addressTextfield.maxNumberOfResults = 5
        
        // Customize highlight attributes - Default: Bold
        addressTextfield.highlightAttributes = [NSBackgroundColorAttributeName: UIColor.yellowColor(), NSFontAttributeName:UIFont.boldSystemFontOfSize(12)]
        
        // Handle item selection - Default: title set to the text field
        addressTextfield.itemSelectionHandler = {item in
            self.addressTextfield.text = item.title
        }
        
        // Update data source when the user stops typing
        addressTextfield.userStoppedTypingHandler = {
            if let criteria = self.addressTextfield.text {
                if criteria.characters.count > 1 {
                    
                    // Show loading indicator
                    self.addressTextfield.showLoadingIndicator()
                    
                    self.getAddressSuggestion(criteria) { results in
                        // Set new items to filter
                        self.addressTextfield.filterItems(results)
                        
                        // Stop loading indicator
                        self.addressTextfield.stopLoadingIndicator()
                    }
                }
            }
        }
    }
    
    // Method to get the address suggestions, when typing into the address textfield
    func getAddressSuggestion(criteria: String, completion: [SearchTextFieldItem] -> Void) {

        // Array of type SearchTextFieldItem, holds items that we present for the address suggestion
        var results = [SearchTextFieldItem]()
        
        // Here we create a HTTP request to get address suggestions based on what the user has typed into the textfield
        // We set the parameter (q) to what the user has typed into the textfield
        Alamofire.request(.GET, "https://dawa.aws.dk/adresser", parameters: ["q" : criteria, "per_side" : "5"], encoding: .URL).responseJSON { (response) in
            switch response.result {
                
            case .Success:
                let jsonData = JSON(data: response.data!)
                
                if jsonData.isEmpty {
                    // TODO: handle empty results
                    completion([SearchTextFieldItem(title: "Could not find that address")])
                }
            
                // For each address returned by the aws API - http://dawa.aws.dk
                // we loop over the different addresses and take what we need (city, postalcode, lat, long)
                // then we create a Address object with that information and finally we use that Address object to create
                // a SearchTextFieldItem object that uses that Address object
                // last but not least we append that SearchTextFieldItem into our results array that we declare in the beginning of this method
                for (_, subJson) in jsonData {
                    if let formattedAddress = subJson["adressebetegnelse"].string {
                        
                        let etage = subJson["etage"].string
                        let houseNumber = subJson["adgangsadresse"]["husnr"].string!
                        let street = subJson["adgangsadresse"]["vejstykke"]["adresseringsnavn"].string!
                        var address = ""
                        
                        if etage != nil {
                            address = street + " " + houseNumber + ", \(etage!)"
                        } else {
                            address = street + " " + houseNumber
                        }
                        
                        let city = subJson["adgangsadresse"]["postnummer"]["navn"].string!
                        let postalCode = Int(subJson["adgangsadresse"]["postnummer"]["nr"].string!)!
                        let latitude = subJson["adgangsadresse"]["adgangspunkt"]["koordinater"][1].double!
                        let longitude = subJson["adgangsadresse"]["adgangspunkt"]["koordinater"][0].double!
                        
                        let userAddress = Address(address: address, cityName: city, postalCode: postalCode, latitude: latitude, longitude: longitude)
                        
                        results.append(SearchTextFieldItem(title: formattedAddress, address: userAddress))
                    }
                }
                
                // All address suggetions has now been added to the results array, we can then return the results
                completion(results)
                
            case .Failure(let error):
                print(error)
            }
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // handle the dismission of the current displayed view when clicked outside
        self.view.endEditing(true)
    }
    
    func keyboardWillAppear(notification: NSNotification){
        if addressTextfield.highlighted {
            let space = viewTitleLabel.frame.size.height + nameTextfield.frame.size.height + emailTextfield.frame.size.height + passwordTextfield.frame.size.height + 40
            UIView.animateWithDuration(0.2, animations: {
                self.view.frame.origin.y -= space
            })
        }
    }
    
    func keyboardWillDisappear(notification: NSNotification){
        if addressTextfield.highlighted {
            UIView.animateWithDuration(0.2, animations: {
                self.view.frame.origin.y = 0
            })
        }
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let destVC = segue.destinationViewController as! LoginViewController
        destVC.userCreatedInRegistration = userCreated
    }


}

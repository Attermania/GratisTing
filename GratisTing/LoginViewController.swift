import UIKit

class LoginViewController: UIViewController {
    
    // MARK: Dependencies
    let auth = AppDelegate.authentication
    
    // MARK: Instance variables
    var presenter: UIViewController?
    var userCreatedInRegistration = false
    var action: String?
    
    // MARK: IB Outlets
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var createUserButton: UIButton!
    
    // MARK: IB Actions
    @IBAction func loginButton(sender: AnyObject) {
        
        auth.authenticate(emailTextfield.text!, password: passwordTextfield.text!) { (jwt, user, error) in
            if let _ = error {
                
                // Error, wrong credentials, show error and abort mission
                let alertController = UIAlertController(title: "Fejl", message: "Brugernavn eller adgangskode forkert", preferredStyle: .Alert)
                let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alertController.addAction(defaultAction)
                
                self.presentViewController(alertController, animated: true, completion: nil)
                
                return
            }
            
            self.dismissViewControllerAnimated(true, completion: {
                
                // If user was trying to create an item, and was redirected here, to log in first, we redirect them to the create item view
                if self.action == "LoginCreateItem" {
                    let storyboard = UIStoryboard(name: "Create", bundle: nil)
                    let controller = storyboard.instantiateViewControllerWithIdentifier("CreateView") as! CreateViewController
                    controller.presenter = self.presenter
                    
                    self.presenter?.presentViewController(controller, animated: true, completion: nil)
                    
                    return
                }
                
                // Show user a welome alert
                let alertController = UIAlertController(title: "Velkommen", message: "Du er nu logget ind", preferredStyle: .Alert)
                let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alertController.addAction(defaultAction)
                
                self.presenter?.presentViewController(alertController, animated: true, completion: nil)
            })
        }
    }
    
    @IBAction func backButtonNavigation(sender: AnyObject) {
        // reset the action when returning
        action = nil

        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    // MARK: Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.layer.cornerRadius = 5
        loginButton.backgroundColor = UIColor(hexString: "#FFCC26")
        
        createUserButton.layer.cornerRadius = 5
        createUserButton.backgroundColor = UIColor(hexString: "#FFCC26")
    }
    
    override func viewDidAppear(animated: Bool) {
        if userCreatedInRegistration {
            let alertController = UIAlertController(title: "Bruger oprettet", message: "Du kan nu logge ind", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // handle the dismission of the current displayed view when clicked outside
        self.view.endEditing(true)
    }

}

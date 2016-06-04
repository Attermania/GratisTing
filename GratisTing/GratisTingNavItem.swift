import UIKit

class GratisTingNavItem: UINavigationItem {
    
    // MARK: Dependencies
    var dao: DAOProtocol = AppDelegate.dao
    var auth: Authentication = AppDelegate.authentication
    
    // MARK: Instance variables
    var buttons: [UIBarButtonItem] = []
    
    // MARK: Static variables
    static var currentVC: UIViewController?
    
    // MARK: methods
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Buttons & logo
        let userButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "user"), landscapeImagePhone: UIImage(named: "user"), style: .Plain, target: self, action: #selector(GratisTingNavItem.goToUserScreen))
        let createButton = UIBarButtonItem(image: UIImage(named: "plus"), landscapeImagePhone: UIImage(named: "plus"), style: .Plain, target: self, action: #selector(GratisTingNavItem.createItem))
        
        // Set colors
        userButton.tintColor = UIColor(hexString: "#FFCC26")
        createButton.tintColor = UIColor(hexString: "#FFCC26")
        self.backBarButtonItem?.tintColor = UIColor(hexString: "#FFCC26")
        

        // Add right buttons to array
        buttons.append(userButton)
        buttons.append(createButton)
        
        // Add logo and buttons
        self.setRightBarButtonItems(buttons, animated: true)
        self.setLeftBarButtonItem(self.backBarButtonItem, animated: true)
        
    }

    // Method for instantiating viewController and displaying UIAlert if needed
    func createItem() {
        
        // Variable to reference what VC is launching the createItem screen.
        let currentVC = GratisTingNavItem.currentVC
        
        // If token is set, present create view controller
        if auth.token != nil {
            let storyboard = UIStoryboard(name: "Create", bundle: nil)
            let controller = storyboard.instantiateViewControllerWithIdentifier("CreateView") as! CreateViewController
            controller.presenter = currentVC
            
            currentVC?.presentViewController(controller, animated: true, completion: nil)
            
            return
        }
        
        // If token is not set - show alert instructring user to login and present login view
        let alertController = UIAlertController(title: "Bruger påkrævet", message: "Du skal være logget ind for at oprette en gratis ting.", preferredStyle: .Alert)
        
        // Add action to OK button
        let defaultAction = UIAlertAction(title: "OK", style: .Default) { (action) in

            let storyboard = UIStoryboard(name: "Authentication", bundle: nil)
            let navController = storyboard.instantiateViewControllerWithIdentifier("Login") as! UINavigationController
            let loginController = navController.topViewController as! LoginViewController
            
            // Set action and VCreference to LoginViewController
            loginController.action = "LoginCreateItem"
            loginController.presenter = currentVC
            
            currentVC?.presentViewController(navController, animated: true, completion: nil)
            
            return
        }
        
        alertController.addAction(defaultAction)
        currentVC?.presentViewController(alertController, animated: true, completion: nil)
    }
    
    // Method for launching user screen if user is logged in - else show login screen.
    func goToUserScreen() {
        
        // Variable to reference what VC is launching the createItem screen.
        let currentVC = GratisTingNavItem.currentVC
        
        // If user is not logged in, go to login screen
        if auth.user == nil {
            let storyboard = UIStoryboard(name: "Authentication", bundle: nil)
            let controller = storyboard.instantiateViewControllerWithIdentifier("Login") as! UINavigationController
            let loginController = controller.topViewController as! LoginViewController
            
            // Set VCreference to LoginViewController
            loginController.presenter = currentVC
            
            currentVC?.presentViewController(controller, animated: true, completion: nil)
            return
        }
        
        // Else go to user screen
        let storyboard = UIStoryboard(name: "User", bundle: nil)
        let controller = storyboard.instantiateViewControllerWithIdentifier("UserView") as! UserViewController
        controller.presenter = currentVC
        
        
        currentVC?.presentViewController(controller, animated: true, completion: nil)
    }
    
    
}

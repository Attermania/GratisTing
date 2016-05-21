//
//  LoginViewController.swift
//  GratisTing
//
//  Created by Thomas Attermann on 10/05/2016.
//  Copyright © 2016 SJT. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    let auth = AppDelegate.authentication
    
    var userCreatedInRegistration = false
    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    // Define authentication logic
    @IBAction func loginButton(sender: AnyObject) {
        auth.authenticate(emailTextfield.text!, password: passwordTextfield.text!) { (error, jwt) in
            if jwt != nil {
                self.auth.setToken(jwt!)
                let mainVC = self.presentingViewController?.childViewControllers[0] as! MainViewController
                self.dismissViewControllerAnimated(true, completion: {
                    mainVC.returnedWithAction("LoggedIn", object: nil)
                })

            }
            if (error != nil) {
                print(error?.localizedDescription)
            }
        }
    }
    
    // Define logic when returned from Registration.
    @IBAction func returnedFromRegistration(sender: UIStoryboardSegue) {
        
    }
    
    @IBAction func backButtonNavigation(sender: AnyObject) {

        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        if userCreatedInRegistration {
            let alertController = UIAlertController(title: "Bruger oprettet", message: "Du kan nu logge ind", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            presentViewController(alertController, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Pass the selected object to the new view controller.
    }

}

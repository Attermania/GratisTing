//
//  LoginViewController.swift
//  GratisTing
//
//  Created by Thomas Attermann on 10/05/2016.
//  Copyright © 2016 SJT. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: Dependencies
    let auth = AppDelegate.authentication
    
    // MARK: Instance variables
    var userCreatedInRegistration = false
    var action: String?
    
    // MARK: IB Outlets
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    // MARK: IB Actions
    @IBAction func loginButton(sender: AnyObject) {
        
        auth.authenticate(emailTextfield.text!, password: passwordTextfield.text!) { (jwt, user, error) in
            if let _ = error {
                // Error, abort the ship - TODO: Show a message to user
                return
            }
            
            let mainVC = self.presentingViewController?.childViewControllers[0] as! MainViewController
            
            self.dismissViewControllerAnimated(true, completion: {
                
                if self.action == "LoginCreateItem" {
                    mainVC.returnedWithAction("OpenCreateItem", object: nil)
                    return
                }
                
                mainVC.returnedWithAction("LoggedIn", object: nil)
            })
        }
    }
    
    // Define logic when returned from Registration.
    @IBAction func returnedFromRegistration(sender: UIStoryboardSegue) {
        
    }
    
    @IBAction func backButtonNavigation(sender: AnyObject) {
        // reset the action when returning
        action = nil

        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    // MARK: Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        GratisTingNavItem.presenter = self
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
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }


    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Pass the selected object to the new view controller.
    }

}

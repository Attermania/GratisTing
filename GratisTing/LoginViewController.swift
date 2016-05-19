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
    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    // Define authentication logic
    @IBAction func loginButton(sender: AnyObject) {
        auth.authenticate(emailTextfield.text!, password: passwordTextfield.text!) { (error, jwt) in
            if jwt != nil {
                self.auth.setToken(jwt!)
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

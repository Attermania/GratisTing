//
//  UserViewController.swift
//  GratisTing
//
//  Created by Thomas Attermann on 21/05/2016.
//  Copyright © 2016 SJT. All rights reserved.
//

import UIKit

class UserViewController: UIViewController {
    
    let auth = AppDelegate.authentication

    @IBOutlet weak var userNameLabel: UILabel!
    
    
    
    @IBAction func navigateBackButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Logout button
    @IBAction func logoutButton(sender: AnyObject) {
        auth.logout()
        let mainVC = self.presentingViewController?.childViewControllers[0] as! MainViewController
        self.dismissViewControllerAnimated(true, completion: {
            mainVC.returnedWithAction("LoggedOut", object: nil)
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameLabel.text = (auth.user?.name)!
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

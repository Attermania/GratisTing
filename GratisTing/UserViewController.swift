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
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var userAvatarImageview: UIImageView!
    @IBOutlet weak var userAddressLabel: UILabel!
    @IBOutlet weak var postalCodeLabel: UILabel!
    
    
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
    
    override func viewDidAppear(animated: Bool) {
        GratisTingNavItem.setupPresentation(true, vc: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        logoutButton.layer.cornerRadius = 5
        logoutButton.backgroundColor = UIColor(hexString: "#d9534f")
        
        let image: UIImage = UIImage(named: "user-1")!
        userAvatarImageview.layer.borderWidth = 1.0
        userAvatarImageview.layer.masksToBounds = false
        userAvatarImageview.layer.borderColor = UIColor.whiteColor().CGColor
        userAvatarImageview.layer.cornerRadius = userAvatarImageview.frame.size.width/2
        userAvatarImageview.clipsToBounds = true
        userAvatarImageview.image = image
        
        userNameLabel.text = (auth.user?.name)!
        userAddressLabel.text = auth.user?.address.address
        postalCodeLabel.text = "\(String((auth.user?.address.postalCode)!)) \(String((auth.user?.address.cityName)!))"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        GratisTingNavItem.setupPresentation(false, vc: self)
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

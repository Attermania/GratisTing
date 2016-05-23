//
//  UserViewController.swift
//  GratisTing
//
//  Created by Thomas Attermann on 21/05/2016.
//  Copyright © 2016 SJT. All rights reserved.
//

import UIKit

class UserViewController: UIViewController {
    
    // MARK: Dependencies
    let auth = AppDelegate.authentication

    // MARK: Ib outlets
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var userAvatarImageview: UIImageView!
    @IBOutlet weak var userAddressLabel: UILabel!
    @IBOutlet weak var postalCodeLabel: UILabel!
    
    // MARK: Ib actions
    @IBAction func navigateBackButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func logoutButton(sender: AnyObject) {
        auth.logout()
        let mainVC = self.presentingViewController?.childViewControllers[0] as! MainViewController
        self.dismissViewControllerAnimated(true, completion: {
            mainVC.returnedWithAction("LoggedOut", object: nil)
        })
    }
    
    // MARK: Methods
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
        GratisTingNavItem.presenter = self
    }

}

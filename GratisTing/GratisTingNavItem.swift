//
//  GratisTingNavItem.swift
//  GratisTing
//
//  Created by Thomas Attermann on 22/05/2016.
//  Copyright © 2016 SJT. All rights reserved.
//

import UIKit

class GratisTingNavItem: UINavigationItem {
    
    // MARK: Dependencies
    var dao: DAOProtocol!
    var auth: Authentication!
    
    // MARK: Instance variables
    var buttons: [UIBarButtonItem] = []
    
    // MARK: Static variables
    static var presenter: UIViewController? {
        didSet {

            switch presenter {
                
            case is UserViewController:
                let userVC = presenter as! UserViewController
                userVC.navigationItem.rightBarButtonItems![0].enabled = false
                
            case is MainViewController:
                let mainVC = presenter as! MainViewController
                let logo = UIBarButtonItem(image: UIImage(named: "logo1"), landscapeImagePhone: UIImage(named: "logo1"), style: .Plain, target: self, action: nil)
                logo.tintColor = UIColor(hexString: "#FFCC26")
                mainVC.navigationItem.leftBarButtonItem = logo
            
            case is LoginViewController:
                let loginVC = presenter as! LoginViewController
                loginVC.navigationItem.rightBarButtonItems![0].enabled = false
                
            case is RegisterViewController:
                let regVC = presenter as! RegisterViewController
                regVC.navigationItem.rightBarButtonItems![0].enabled = false
                
            case is CreateViewController:
                let createVC = presenter as! CreateViewController
                createVC.navigationItem.rightBarButtonItems![1].enabled = false
                
            default:
                return
            }
        }
    }
    
    // MARK: methods
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Buttons & logo
        let userButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "user"), landscapeImagePhone: UIImage(named: "user"), style: .Plain, target: self, action: #selector(GratisTingNavItem.goToUserScreen))
        let createButton = UIBarButtonItem(image: UIImage(named: "plus"), landscapeImagePhone: UIImage(named: "plus"), style: .Plain, target: self, action: #selector(GratisTingNavItem.createItem) )
        let backButton = UIBarButtonItem(image: UIImage(named: "back"), landscapeImagePhone: UIImage(named: "back"), style: .Plain, target: self, action: #selector(GratisTingNavItem.backButtonPressed))
        
        // Set colors
        userButton.tintColor = UIColor(hexString: "#FFCC26")
        createButton.tintColor = UIColor(hexString: "#FFCC26")
        backButton.tintColor = UIColor(hexString: "#FFCC26")

        // Add right buttons to array
        buttons.append(userButton)
        buttons.append(createButton)
        
        // Add logo and buttons
        self.setRightBarButtonItems(buttons, animated: true)
        self.setLeftBarButtonItem(backButton, animated: true)

        

    }

    
    func createItem() {
        includeDaoAndAuth()
        
        // If there is no presenter, abort the ship
        guard let presenter = GratisTingNavItem.presenter else {
            return
        }
        
        // If token is set, present create view controller
        if auth.token != nil {
            let storyboard = UIStoryboard(name: "Create", bundle: nil)
            let controller = storyboard.instantiateViewControllerWithIdentifier("Create") as! UINavigationController
            presenter.presentViewController(controller, animated: true, completion: nil)
            return
        }
        
        // If token is not set - show alert instructring user to login and present login view
        let alertController = UIAlertController(title: "Bruger påkrævet", message: "Du skal være logget ind for at oprette en gratis ting.", preferredStyle: .Alert)
        
        // Add action to OK button
        let defaultAction = UIAlertAction(title: "OK", style: .Default) { (action) in

            let storyboard = UIStoryboard(name: "Authentication", bundle: nil)
            let controller = storyboard.instantiateViewControllerWithIdentifier("Login") as! UINavigationController
            let loginController = controller.childViewControllers[0] as! LoginViewController
            
            loginController.action = "LoginCreateItem"
            presenter.presentViewController(controller, animated: true, completion: nil)
            return
            
        }
        alertController.addAction(defaultAction)
        presenter.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    func goToUserScreen() {
        includeDaoAndAuth()
        
        guard let presenter = GratisTingNavItem.presenter else {
            return
        }
        
        // If user is not logged in, go to login screen
        if auth.user == nil {
            let storyboard = UIStoryboard(name: "Authentication", bundle: nil)
            let controller = storyboard.instantiateViewControllerWithIdentifier("Login") as! UINavigationController
            
            presenter.presentViewController(controller, animated: true, completion: nil)
            return
        }
        
        // Else go to user screen
        let storyboard = UIStoryboard(name: "User", bundle: nil)
        let controller = storyboard.instantiateViewControllerWithIdentifier("User") as! UINavigationController
        
        presenter.presentViewController(controller, animated: true, completion: nil)
        
    }
    
    func backButtonPressed () {
        let vcs = GratisTingNavItem.presenter?.navigationController?.viewControllers
        if vcs?.count <= 1 {
            GratisTingNavItem.presenter?.navigationController?.dismissViewControllerAnimated(true, completion: nil)
            return
        }
        let prev = (vcs?.count)! - 2
        let previousVC = vcs![ prev >= 0 ? prev : 0]
        GratisTingNavItem.presenter?.navigationController?.popToViewController(previousVC, animated: true)
    }
    
    private func includeDaoAndAuth () {
        if auth == nil || dao == nil {
            auth = AppDelegate.authentication
            dao = AppDelegate.dao
        }
    }
    
    
}

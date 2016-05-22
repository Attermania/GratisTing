//
//  GratisTingNavItem.swift
//  GratisTing
//
//  Created by Thomas Attermann on 22/05/2016.
//  Copyright © 2016 SJT. All rights reserved.
//

import UIKit

class GratisTingNavItem: UINavigationItem {
    
    var dao: DAOProtocol!
    var auth: Authentication!
    
    static var presenter: UIViewController?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Buttons & logo
        let userButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "user"), landscapeImagePhone: UIImage(named: "user"), style: .Plain, target: self, action: #selector(GratisTingNavItem.goToUserScreen))
        let createButton = UIBarButtonItem(image: UIImage(named: "plus"), landscapeImagePhone: UIImage(named: "plus"), style: .Plain, target: self, action: #selector(GratisTingNavItem.createItem) )
        let logo = UIBarButtonItem(image: UIImage(named: "logo1"), landscapeImagePhone: UIImage(named: "logo1"), style: .Plain, target: self, action: nil)
        
        // Set colors
        userButton.tintColor = UIColor(hexString: "#FFCC26")
        createButton.tintColor = UIColor(hexString: "#FFCC26")
        logo.tintColor = UIColor(hexString: "#FFCC26")

        // Add right buttons to array
        var buttons: [UIBarButtonItem] = []
        buttons.append(userButton)
        buttons.append(createButton)
        
        // Add logo and buttons
        self.setLeftBarButtonItem(logo, animated: true)
        self.setRightBarButtonItems(buttons, animated: true)
        

    }
    
    func createItem() {
        includeDaoAndAuth()
        
        if GratisTingNavItem.presenter == nil {
            return
        }
        
        let presenter = GratisTingNavItem.presenter!
        
        // Check if token is set - present create view controler
        if auth.getToken() != nil {
            let storyboard = UIStoryboard(name: "Create", bundle: nil)
            let controller = storyboard.instantiateViewControllerWithIdentifier("Create") as! UINavigationController
            presenter.presentViewController(controller, animated: true, completion: nil)
            return
        }
        
        
        // If token is not set - show alert instructring user to create error.
        let alertController = UIAlertController(title: "Bruger påkrævet", message: "Du skal være logget ind for at oprette en gratis ting.", preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            print("ok")
            let storyboard = UIStoryboard(name: "Authentication", bundle: nil)
            let controller = storyboard.instantiateViewControllerWithIdentifier("Login") as! UINavigationController
            let loginController = controller.childViewControllers[0] as! LoginViewController
            loginController.action = "LoginCreateItem"
            presenter.presentViewController(controller, animated: true, completion: nil)
            return
            //self.performSegueWithIdentifier("goToLogin", sender: self)
        }
        alertController.addAction(defaultAction)
        presenter.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    func goToUserScreen() {
        includeDaoAndAuth()
        if GratisTingNavItem.presenter == nil {
            return
        }
        let presenter = GratisTingNavItem.presenter!
        
        if auth.user == nil {
            let storyboard = UIStoryboard(name: "Authentication", bundle: nil)
            let controller = storyboard.instantiateViewControllerWithIdentifier("Login") as! UINavigationController
            presenter.presentViewController(controller, animated: true, completion: nil)
            return
        }
        let storyboard = UIStoryboard(name: "User", bundle: nil)
        let controller = storyboard.instantiateViewControllerWithIdentifier("User") as! UINavigationController
        presenter.presentViewController(controller, animated: true, completion: nil)
        
    }
    
    private func includeDaoAndAuth () {
        if auth == nil || dao == nil {
            auth = AppDelegate.authentication
            dao = AppDelegate.dao
        }
    }
    
    
}

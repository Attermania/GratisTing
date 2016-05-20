//
//  CreateViewController.swift
//  GratisTing
//
//  Created by Steffen on 11/05/16.
//  Copyright © 2016 SJT. All rights reserved.
//

import UIKit

class CreateViewController: UIViewController {
    
    let dao = AppDelegate.dao
    let auth = AppDelegate.authentication
    
    // NYT
    //let auth = AppDelegate.authentication


    @IBOutlet weak var titleTextfield: UITextField!
    @IBOutlet weak var descriptionTextfield: UITextField!
    
    @IBAction func createItemButton(sender: AnyObject) {
        
        print(auth.user?.name)
        
        let cate = Category(id: "573c7e982831ba44719236bb", title: "Sko")
        
        let title = titleTextfield.text!
        let description = descriptionTextfield.text!
        
        let item = Item(title: title, description: description, imageURL: "", owner: auth.user!, address: auth.user!.address, category: cate)
        
        self.dao.createItem(item, token: auth.getToken()!)
    }
    
    @IBAction func backButton(sender: AnyObject) {
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

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

    @IBOutlet weak var titleTextfield: UITextField!
    @IBOutlet weak var descriptionTextfield: UITextField!
    
    @IBAction func createItemButton(sender: AnyObject) {
        
        
        
        let user = User(email: "man@example.com", password: "secret", name: "Ellen", address: Address(address: "Street", cityName: "City", postalCode: 2400, latitude: 12.51, longitude: 12.52))
        let cate = Category(id: "573c7e982831ba44719236bb", title: "Sko")
        let address = Address(address: "Street", cityName: "City", postalCode: 2400, latitude: 12.51, longitude: 12.52)
        
        let title = titleTextfield.text!
        let description = descriptionTextfield.text!
        
        let item = Item(title: title, description: description, imageURL: "", owner: user, address: address, category: cate)
        print(item)
        
        self.dao.createItem(item)
        print("Create")


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

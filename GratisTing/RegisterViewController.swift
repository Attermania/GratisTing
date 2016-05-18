//
//  RegisterViewController.swift
//  GratisTing
//
//  Created by Thomas Attermann on 10/05/2016.
//  Copyright © 2016 SJT. All rights reserved.
//

import UIKit
import SearchTextField
import Alamofire
import SwiftyJSON

class RegisterViewController: UIViewController {

    @IBOutlet weak var addressTextfield: SearchTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCustomSearchTextField()
        
        // Do any additional setup after loading the view.
    }
    
    // 2 - Configure a custom search text view
    private func configureCustomSearchTextField() {
        // Set theme - Default: light
        addressTextfield.theme = SearchTextFieldTheme.lightTheme()
        
        // Modify current theme properties
        addressTextfield.theme.font = UIFont.systemFontOfSize(14)
        addressTextfield.theme.bgColor = UIColor (red: 0.9, green: 0.9, blue: 0.9, alpha: 0.3)
        addressTextfield.theme.borderColor = UIColor (red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        addressTextfield.theme.separatorColor = UIColor (red: 0.9, green: 0.9, blue: 0.9, alpha: 0.5)
        addressTextfield.theme.cellHeight = 50
        
        // Max number of results - Default: No limit
        addressTextfield.maxNumberOfResults = 5
        
        // Customize highlight attributes - Default: Bold
        addressTextfield.highlightAttributes = [NSBackgroundColorAttributeName: UIColor.yellowColor(), NSFontAttributeName:UIFont.boldSystemFontOfSize(12)]
        
        // Handle item selection - Default: title set to the text field
        addressTextfield.itemSelectionHandler = {item in
            self.addressTextfield.text = item.title
        }
        
        // Update data source when the user stops typing
        addressTextfield.userStoppedTypingHandler = {
            if let criteria = self.addressTextfield.text {
                if criteria.characters.count > 1 {
                    
                    // Show loading indicator
                    self.addressTextfield.showLoadingIndicator()
                    
                    self.getAddressSuggestion(criteria) { results in
                        // Set new items to filter
                        self.addressTextfield.filterItems(results)
                        
                        // Stop loading indicator
                        self.addressTextfield.stopLoadingIndicator()
                    }
                }
            }
        }
    }
    
    func getAddressSuggestion(criteria: String, completion: [SearchTextFieldItem] -> Void) {

        var results = [SearchTextFieldItem]()
        
        Alamofire.request(.GET, "https://dawa.aws.dk/adresser", parameters: ["q" : criteria, "per_side" : "5"], encoding: .URL).responseJSON { (response) in
            switch response.result {
                
            case .Success:
                let jsonData = JSON(data: response.data!)
                
                if jsonData.isEmpty {
                    self.addressTextfield.placeholder = "Ingen resultater fundet for, \(self.addressTextfield.text!)"
                    self.addressTextfield.text = ""
                    completion([])
                }
                for (_, subJson) in jsonData {
                    if let address = subJson["adressebetegnelse"].string {
                        results.append(SearchTextFieldItem(title: address))
                    }
                }
                
                completion(results)
                
            case .Failure(let error):
                print(error)
            }
        }
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

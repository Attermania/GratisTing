//
//  CreateViewController.swift
//  GratisTing
//
//  Created by Steffen on 11/05/16.
//  Copyright © 2016 SJT. All rights reserved.
//

import UIKit
import MobileCoreServices

class CreateViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - Dependencies
    let dao = AppDelegate.dao
    let auth = AppDelegate.authentication
    let imagePicker = UIImagePickerController()
    
    // NYT
    //let auth = AppDelegate.authentication

    // MARK: - Components
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var titleTextfield: UITextField!
    @IBOutlet weak var descriptionTextfield: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    var categoryPicker: UIPickerView!
    
    // MARK: - Actions
    @IBAction func selectImagePressed(sender: AnyObject) {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .Camera
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    @IBAction func createItemButton(sender: AnyObject) {
        
        let title = titleTextfield.text!
        let description = descriptionTextfield.text!
        let category    = categories[categoryPicker.selectedRowInComponent(0)]
        
        let item = Item(
            title: title,
            description: description,
            imageURL: "",
            owner: auth.user!,
            address: auth.user!.address,
            category: category
        )
        
        self.dao.createItem(item, token: auth.getToken()!) { (item, error) in
            if let error = error {
                print(error)
                // An error was returned
                return
            }
            
            let mainVC = self.presentingViewController?.childViewControllers[0] as! MainViewController
            self.dismissViewControllerAnimated(true, completion: {
                mainVC.returnedWithAction("ItemCreated", object: item)
            })
        }

    }
    
    @IBAction func backButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Instance variables
    var categories: [Category] = []
    
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setup image picker
        imagePicker.delegate = self
        itemImageView.hidden = true
        // Setup category picker
        categoryPicker = UIPickerView()
        categoryPicker.delegate = self
        
        // Setup category text field
        categoryTextField.delegate = self
        categoryTextField.inputView = categoryPicker
        categoryTextField.tintColor = UIColor.clearColor()
        
        // Load categories
        dao.getAllCategories({ (categories: [Category]?, error: NSError?) in
            if let categories = categories {
                self.categories = categories
            }
        })
    }

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: categories[row].title)
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoryTextField.text = categories[row].title
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        return false
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            itemImageView.image = pickedImage
            itemImageView.hidden = false
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func didMediaFromSource(sourceType: UIImagePickerControllerSourceType) {
        
        let mediaTypes = UIImagePickerController.availableMediaTypesForSourceType(sourceType)
        imagePicker.mediaTypes = mediaTypes!
        imagePicker.sourceType = sourceType
        imagePicker.allowsEditing = true
        presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
}

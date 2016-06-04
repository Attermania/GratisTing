import UIKit
import MobileCoreServices

class CreateViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: Dependencies
    let dao = AppDelegate.dao
    let auth = AppDelegate.authentication
    
    // MARK: Instance variables
    var categories: [Category] = []
    let imagePicker = UIImagePickerController()
    var categoryPicker: UIPickerView!
    var presenter: UIViewController!

    // MARK: Components
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var titleTextfield: UITextField!
    @IBOutlet weak var descriptionTextfield: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var createItemButton: UIButton!
    
    // MARK: IB Actions
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
        
        self.dao.createItem(item, token: auth.token!, user: auth.user!) { (item, error) in
            if let error = error {
                print(error)
                return
            }
            
            self.dismissViewControllerAnimated(true, completion: {
                let storyboard = UIStoryboard(name: "Show", bundle: nil)
                let controller = storyboard.instantiateViewControllerWithIdentifier("ShowItem") as! ShowViewController
                controller.item = item
                self.presenter.navigationController?.pushViewController(controller, animated: true)
            })
        }

    }
    
    @IBAction func dismissViewButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup image picker
        imagePicker.delegate = self
        
        // Setup category picker
        categoryPicker = UIPickerView()
        categoryPicker.delegate = self
        
        // Setup category text field
        categoryTextField.delegate = self
        categoryTextField.inputView = categoryPicker
        categoryTextField.tintColor = UIColor.clearColor()
        
        // Set color of button in top left corner
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor(hexString: "FFCC26")
        
        // Set button rounded corners
        createItemButton.layer.cornerRadius = 5
        
        // Load categories
        dao.getAllCategories({ (categories: [Category]?, error: NSError?) in
            if let categories = categories {
                self.categories = categories
            }
        })
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // Handle the dismission of the current displayed view, when clicked outside
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(animated: Bool) {
        GratisTingNavItem.currentVC = self
    }

    // MARK: Picker view delegate methods
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
    
    // MARK: Text field delegate methods
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        return false
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        // If first time the category picker is showed, we explicitly select the first row
        if textField == categoryTextField && self.categoryPicker.selectedRowInComponent(0) == 0 {
            self.pickerView(self.categoryPicker, didSelectRow: 0, inComponent: 0)
        }
        
        return true
        
    }
    
    // MARK: Image picker delegate methods
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
    
}

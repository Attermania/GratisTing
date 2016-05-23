//
//  ShowViewController.swift
//  GratisTing
//
//  Created by Steffen on 13/05/16.
//  Copyright © 2016 SJT. All rights reserved.
//

import UIKit

class ShowViewController: UIViewController {
    
    var item: Item?

    @IBOutlet weak var itemDescriptionText: UITextView! {
        didSet {
            itemDescriptionText.textContainer.lineFragmentPadding = 0
        }
    }
    @IBOutlet weak var itemTitleLabel: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemOwnerLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var sendRequestButton: UIButton!
    
    override func viewDidLoad() {
//        self.title = item?.title
        super.viewDidLoad()
//        print("view did load")
//        self.title = item?.title
//        itemTitleLabel.text = item?.title
//        itemDescriptionText.text = item?.description
//        // Do any additional setup after loading the view.
//        item = nil
        //self.navigationController?.navigationBar.backgroundColor = UIColor(hexString: "#37383A")
        
    }
    
    override func viewWillAppear(animated: Bool) {
        itemTitleLabel.text = item?.title
        itemDescriptionText.text = item?.description
        // Do any additional setup after loading the view.
        itemTitleLabel.text = item?.title
        itemDescriptionText.text = item?.description
        itemOwnerLabel.text = item?.owner?.name
        
        GratisTingNavItem.setupPresentation(false, vc: self)
        
        let image: UIImage = UIImage(named: "user-1")!
        userImageView.layer.borderWidth = 1.0
        userImageView.layer.masksToBounds = false
        userImageView.layer.borderColor = UIColor.whiteColor().CGColor
        userImageView.layer.cornerRadius = userImageView.frame.size.width/2
        userImageView.clipsToBounds = true
        userImageView.image = image
        
        item = nil
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        itemTitleLabel.text = ""
        itemDescriptionText.text = ""
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

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
    
    var distanceFromPreviousView = ""

    @IBOutlet weak var itemDescriptionText: UITextView! {
        didSet {
            itemDescriptionText.textContainer.lineFragmentPadding = 0
        }
    }
    @IBOutlet weak var itemTitleLabel: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemOwnerLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userAddressLabel: UILabel!
    @IBOutlet weak var contactButton: UIButton!
    @IBOutlet weak var labelOwnerCity: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    override func loadView() {
        super.loadView()
        
        contactButton.layer.cornerRadius = 5
    }
    
    override func viewWillAppear(animated: Bool) {
        GratisTingNavItem.currentVC = self
        
        itemTitleLabel.text = item?.title
        itemDescriptionText.text = item?.description
        itemTitleLabel.text = item?.title
        itemDescriptionText.text = item?.description
        itemOwnerLabel.text = item?.owner?.name
        userAddressLabel.text = "\((item?.address?.postalCode)!) \((item?.address?.cityName)!)"
        distanceLabel.text = "\(distanceFromPreviousView) væk"
        
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

}

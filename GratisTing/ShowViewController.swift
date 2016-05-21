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
    
    override func viewDidLoad() {
//        self.title = item?.title
        super.viewDidLoad()
//        print("view did load")
//        self.title = item?.title
//        itemTitleLabel.text = item?.title
//        itemDescriptionText.text = item?.description
//        // Do any additional setup after loading the view.
//        item = nil
    }
    
    override func viewWillAppear(animated: Bool) {
        self.title = item?.title
        self.title = item?.title
        itemTitleLabel.text = item?.title
        itemDescriptionText.text = item?.description
        // Do any additional setup after loading the view.
        itemTitleLabel.text = item?.title
        itemDescriptionText.text = item?.description
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

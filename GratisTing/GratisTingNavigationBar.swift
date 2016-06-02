//
//  GratisTingNavigationBar.swift
//  GratisTing
//
//  Created by Steffen on 02/06/16.
//  Copyright © 2016 SJT. All rights reserved.
//

import UIKit

class GratisTingNavigationBar: UINavigationBar {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Make navigation bar transparent.
        self.setBackgroundImage(UIImage(named: "transparent.png"), forBarMetrics: UIBarMetrics.Default)
        self.shadowImage = UIImage(named: "transparent.png")
        self.translucent = true
        
        self.tintColor = UIColor(hexString: "#FFCC26")
    }


}

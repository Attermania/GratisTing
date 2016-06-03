import Foundation
import UIKit

class GratisTingNavigationController: UINavigationController, UINavigationControllerDelegate {
    
    override func awakeFromNib() {
        self.delegate = self
        
        // UI
        self.navigationBar.tintColor = UIColor(hexString: "#FFCC26")
        self.navigationBar.translucent = true
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        if viewController is MainViewController {
            // Make navigation bar transparent.
            self.navigationBar.setBackgroundImage(UIImage(named: "transparent.png"), forBarMetrics: .Default)
            self.navigationBar.shadowImage = UIImage(named: "transparent.png")
        } else {
            self.navigationBar.setBackgroundImage(nil, forBarMetrics: .Default)
            self.navigationBar.shadowImage = nil
            self.navigationBar.barTintColor = UIColor(hexString: "37393A")
        }
    }
    
}
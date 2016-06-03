import Foundation
import UIKit

// Custom UINavigationController for setting up UI specific features
class GratisTingNavigationController: UINavigationController, UINavigationControllerDelegate {
    
    // MARK: Methods
    override func awakeFromNib() {
        self.delegate = self
        
        // UI
        self.navigationBar.tintColor = UIColor(hexString: "#FFCC26")
        self.navigationBar.translucent = true
    }
    
    // Set color of status bar text at top of screen
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    // Delegate method for setting up navigationBar UI
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
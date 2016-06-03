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

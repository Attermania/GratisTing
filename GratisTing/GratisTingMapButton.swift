import UIKit

class GratisTingMapButton: UIButton {

    var buttonLayer: CAShapeLayer!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Here we add a shadow layer to the layer
        if buttonLayer == nil {
            // instantiate a new empty shadow layer
            buttonLayer = CAShapeLayer()
            // Here we specify the UIButton's frame path using a constructor with cornerradius parameter
            buttonLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: CGFloat(self.bounds.width/2.0)).CGPath
            // Now that we have specified the path of the frame, we fill the frame with the hex color #FCCD37
            buttonLayer.fillColor = UIColor(hexString: "#FCCD37").CGColor
            
            // Here we specific the shadowlayer of the frame
            // first we set the shadow color a dark gray color
            buttonLayer.shadowColor = UIColor.darkGrayColor().CGColor
            // Here we set the shadowpath to the same path as the UIButton's frame
            buttonLayer.shadowPath = buttonLayer.path
            // Here we change the default values for the shadowlayer's offset, opacity and radius
            buttonLayer.shadowOffset = CGSize(width: 2.0, height: 2.0)
            buttonLayer.shadowOpacity = 0.3
            buttonLayer.shadowRadius = 5
            
            // last we add this newly created layer to the UIbutton's layer
            layer.insertSublayer(buttonLayer, atIndex: 0)
        }
    }
    

}

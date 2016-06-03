import UIKit

class GratisTingMapButton: UIButton {

    var shadowLayer: CAShapeLayer!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //self.frame = CGRectMake(0, 0, 56, 56)
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: CGFloat(self.bounds.width/2.0)).CGPath
            shadowLayer.fillColor = UIColor(hexString: "#FCCD37").CGColor
            
            shadowLayer.shadowColor = UIColor.darkGrayColor().CGColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 2.0, height: 2.0)
            shadowLayer.shadowOpacity = 0.3
            shadowLayer.shadowRadius = 5
            
            layer.insertSublayer(shadowLayer, atIndex: 0)
        }
    }
    

}

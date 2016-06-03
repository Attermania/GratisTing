import UIKit

class GratisTingCell: UITableViewCell {
    
    // MARK: Ib outlets
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!

    // MARK: Methods
    override func awakeFromNib() {
        
        // Adds padding to image in cell
        self.itemImage.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9)
        
        // Line for splitting up cell visually
        let topLine = CGRectMake(0, 0, self.frame.size.width, 1)
        let topBorder = UIView(frame: topLine)
        topBorder.backgroundColor = UIColor(hexString: "#eeeeee")
        self.cityLabel.addSubview(topBorder)
        super.awakeFromNib()
    }

    // Set selected cell when user selects a cell
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

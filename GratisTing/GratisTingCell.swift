import UIKit

class GratisTingCell: UITableViewCell {
    
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!

    override func awakeFromNib() {
        self.itemImage.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9)
        let topLine = CGRectMake(0, 0, self.frame.size.width, 1)
        let topBorder = UIView(frame: topLine)
        topBorder.backgroundColor = UIColor(hexString: "#eeeeee")
        self.cityLabel.addSubview(topBorder)
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

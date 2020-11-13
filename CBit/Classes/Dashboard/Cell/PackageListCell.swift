import UIKit
import M13Checkbox

class PackageListCell: UITableViewCell {

    @IBOutlet weak var labelPercentage: UILabel!
    @IBOutlet weak var labelPackagePrice: UILabel!
    @IBOutlet weak var buttonBuy: UIButton!
    @IBOutlet weak var labelValidity: UILabel!
    @IBOutlet var chkcell: M13Checkbox!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        DispatchQueue.main.async {
           // MyModel().roundCorners(corners: [.topRight, .bottomRight], radius: 3, view: self.labelPercentage)
           // MyModel().roundCorners(corners: [.topRight, .topLeft,.bottomLeft, .bottomRight], radius: 5, view: self.buttonBuy)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}

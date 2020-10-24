

import UIKit

class ViewAcitvityIndicator: UIView {
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "ViewAcitvityIndicator",
                     bundle: nil).instantiate(withOwner: self,
                                              options: nil).first as! ViewAcitvityIndicator
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 10
        layer.masksToBounds = true
    }
}

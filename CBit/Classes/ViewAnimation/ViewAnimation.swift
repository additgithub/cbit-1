import UIKit
import SwiftGifOrigin

class ViewAnimation: UIView {
    
    @IBOutlet weak var imageAnimation: UIImageView!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       imageAnimation.loadGif(name: "cbit_briefcase_animation")
        //  imageAnimation.loadGif(name:"lock")
        //  imageAnimation1.loadGif(name: "lock")
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "ViewAnimation",
                     bundle: nil).instantiate(withOwner: self,
                                              options: nil).first as! ViewAnimation
    }
}


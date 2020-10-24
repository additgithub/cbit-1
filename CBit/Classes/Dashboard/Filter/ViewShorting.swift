import UIKit

class ViewShorting: UIView {
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "ViewShorting", bundle: nil).instantiate(withOwner: self, options: nil).first as! UIView
    }
    
    //MARK: - Properties
    @IBOutlet weak var buttonRemoveView: UIButton!
    
    //MARK: - Button Method
    @IBAction func buttonRemoveView(_ sender: Any) {
        self.removeFromSuperview()
    }
    
    
}

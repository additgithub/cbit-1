

import UIKit

class ViewTicketInfo: UIView {

    @IBOutlet weak var viewInfo: UIView!
    @IBOutlet weak var buttonGotIt: UIButton!
    @IBOutlet weak var labelInfo: UILabel!
    @IBOutlet weak var labelNote: UILabel!
    
    var isDashboardInfo = Bool()
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "ViewTicketInfo",
                     bundle: nil).instantiate(withOwner: self,
                                              options: nil).first as! ViewTicketInfo
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setView()
    }
    
    func setView() {
        viewInfo.layer.cornerRadius = 5
        viewInfo.layer.masksToBounds = true
        buttonGotIt.layer.cornerRadius = 5
        buttonGotIt.layer.borderColor = #colorLiteral(red: 0.1221796647, green: 0.3820681274, blue: 0.4405243397, alpha: 1)
        buttonGotIt.layer.borderWidth = 1
        buttonGotIt.layer.masksToBounds = true
    }
    
    func setTest() {
        if isDashboardInfo {
            labelInfo.text = "Checkmark the box and click on pay at the bottom of the screen to proceed. Join contest now and wait for the game time to play the game."
        } else {
            labelInfo.text = ""
        }
    }
    
    @IBAction func buttonHotIt(_ sender: Any) {
        self.removeFromSuperview()
    }
}

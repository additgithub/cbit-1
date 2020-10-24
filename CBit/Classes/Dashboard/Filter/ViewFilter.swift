
import UIKit
import RangeSeekSlider

class ViewFilter: UIView {

    @IBOutlet weak var viewRagePicker: RangeSeekSlider!
    @IBOutlet weak var viewFilterRange: UIView!
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "ViewFilter", bundle: nil).instantiate(withOwner: self, options: nil).first as! UIView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print("---Filter---")
        viewRagePicker.delegate = self
        viewRagePicker.selectedMaxValue = 20
    }
    
    @IBAction func buttonCancel(_ sender: Any) {
        self.removeFromSuperview()
    }
    
    @IBAction func buttonApply(_ sender: Any) {
        //self.removeFromSuperview()
        viewRagePicker.selectedMinValue = 50
    }
    
}

extension ViewFilter: RangeSeekSliderDelegate {
    
}

import UIKit

class TextFieldwithBorder: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setTextField()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setTextField()
    }
    func setTextField() {
        
        textColor = UIColor.white
        
    }
}


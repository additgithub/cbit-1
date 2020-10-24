import UIKit

class LabelComman: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setLabel()
    }
    
    func setLabel() {
        textColor = Define.MAINVIEWCOLOR
    }
}

class LabelTimer: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setLabel()
    }
    
    func setLabel() {
        textColor = Define.BUTTONCOLOR
        layer.borderColor = Define.BUTTONCOLOR.cgColor
        layer.borderWidth = 1
    }
}

class LabelTime: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setLabel()
    }
    
    func setLabel() {
        textColor = Define.MAINVIEWCOLOR
        layer.borderColor = Define.MAINVIEWCOLOR.cgColor
        layer.borderWidth = 1
    }
}


class LableWithLightBG: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setLabel()
    }
    
    func setLabel() {
        
        textColor = Define.MAINVIEWCOLOR
        layer.cornerRadius = 5
        backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        layer.masksToBounds = true
    }
}

class LabelWithRadius: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setLabel()
    }
    
    func setLabel() {
        layer.borderColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
        layer.borderWidth =  2
        layer.cornerRadius = frame.height / 2
        layer.masksToBounds = true
    }
}

import UIKit

class ButtonFill: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setButton()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setButton()
    }


    func setButton() {
        backgroundColor = Define.BUTTONCOLOR
        layer.cornerRadius = frame.height / 2
        layer.masksToBounds = true
    }
}

class ButtonEmpty: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setButton()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setButton()
    }
    
    func setButton() {
        backgroundColor = UIColor.clear
        layer.borderColor = Define.BUTTONCOLOR.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = frame.height / 2
        layer.masksToBounds = true
    }
}

class ButtonWithRadius: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setButton()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setButton()
    }
    
    func setButton() {
        layer.cornerRadius = 5
        layer.masksToBounds = true
    }
}

class ButtonWithBlueColor: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setButton()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setButton()
    }
    
    func setButton()
    {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 2
        layer.cornerRadius = 5
        layer.cornerRadius = 5
        layer.masksToBounds = true
        backgroundColor = #colorLiteral(red: 0.1221796647, green: 0.3820681274, blue: 0.4405243397, alpha: 1)
        setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
    }
    
}

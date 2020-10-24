import UIKit

class ImageViewForTextField:  UIImageView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setImageView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setImageView()
    }
    
    func setImageView() {
        backgroundColor = UIColor.clear
        layer.borderWidth = 1
        layer.borderColor = UIColor.white.cgColor
        layer.cornerRadius = frame.height / 2
        layer.masksToBounds = true
    }
}

class ImageViewForTextFieldWight: UIImageView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setImageView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setImageView()
    }
    
    func setImageView() {
        backgroundColor = UIColor.clear
        layer.borderWidth = 1
        layer.borderColor = Define.MAINVIEWCOLOR.cgColor
        layer.cornerRadius = frame.height / 2
        layer.masksToBounds = true
    }
}

class ImageViewProfile: UIImageView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setImageView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setImageView()
    }
    func setImageView() {
        backgroundColor = UIColor.white
        layer.cornerRadius = frame.height / 2
        layer.masksToBounds = true
    }
}

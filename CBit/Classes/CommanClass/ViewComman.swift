import UIKit

class ViewWithRadius: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setView()
    }
    private func setView() {
        layer.cornerRadius = 5
        layer.masksToBounds = true
    }
}

class ViewWithShadow: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setView()
    }
    
    private func setView() {
        backgroundColor = UIColor.white
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 2
        layer.cornerRadius = 5
        layer.masksToBounds = false
    }
}

class ViewWithShadowAndBorder: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setView()
    }
    
    private func setView() {
        backgroundColor = UIColor.white
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 2
        layer.cornerRadius = 5
        clipsToBounds = true
        layer.masksToBounds = false
    }
}

class ViewWithGradient: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setView()
    }
    
    private func setView() {
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = bounds
        gradientLayer.colors = [#colorLiteral(red: 1, green: 0.831372549, blue: 0.3215686275, alpha: 1).cgColor, #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1).cgColor]
        gradientLayer.type = .radial
        gradientLayer.locations = [90]
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
}

class ViewWithYellowBG: UIView {
    //FDC619
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setView()
    }
    
    private func setView() {
        backgroundColor = #colorLiteral(red: 0.9921568627, green: 0.7764705882, blue: 0.09803921569, alpha: 1)
    }
}

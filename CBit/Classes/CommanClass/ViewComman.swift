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
        backgroundColor = #colorLiteral(red: 0, green: 0.2535769343, blue: 0, alpha: 1)
        //backgroundColor = UIColor.white
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
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.frame = bounds
//        gradientLayer.colors = [#colorLiteral(red: 0.2176683843, green: 0.8194433451, blue: 0.2584097683, alpha: 1).cgColor, #colorLiteral(red: 0, green: 0.2535815537, blue: 0, alpha: 1).cgColor]
//        gradientLayer.type = .radial
//        gradientLayer.locations = [90]
//        layer.insertSublayer(gradientLayer, at: 0)
        
        let gradientLayer = CAGradientLayer()
         gradientLayer.colors = [#colorLiteral(red: 0, green: 0.2535815537, blue: 0, alpha: 1).cgColor, #colorLiteral(red: 0.2176683843, green: 0.8194433451, blue: 0.2584097683, alpha: 1).cgColor]
         gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
         gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
         gradientLayer.locations = [0, 1]
         gradientLayer.frame = bounds

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
       // backgroundColor = #colorLiteral(red: 0.9921568627, green: 0.7764705882, blue: 0.09803921569, alpha: 1)
        backgroundColor = #colorLiteral(red: 0, green: 0.2549019608, blue: 0, alpha: 1)
    }
}


@IBDesignable
public class Gradient: UIView {
    @IBInspectable var startColor:   UIColor = #colorLiteral(red: 0.2176683843, green: 0.8194433451, blue: 0.2584097683, alpha: 1) { didSet { updateColors() }}
    @IBInspectable var endColor:     UIColor = #colorLiteral(red: 0, green: 0.2535815537, blue: 0, alpha: 1) { didSet { updateColors() }}
    @IBInspectable var startLocation: Double =   0 { didSet { updateLocations() }}
    @IBInspectable var endLocation:   Double =   1 { didSet { updateLocations() }}
    @IBInspectable var horizontalMode:  Bool =  false { didSet { updatePoints() }}
    @IBInspectable var diagonalMode:    Bool =  false { didSet { updatePoints() }}

    override public class var layerClass: AnyClass { CAGradientLayer.self }

    var gradientLayer: CAGradientLayer { layer as! CAGradientLayer }

    func updatePoints() {
        if horizontalMode {
            gradientLayer.startPoint = diagonalMode ? .init(x: 1, y: 0) : .init(x: 0, y: 0.5)
            gradientLayer.endPoint   = diagonalMode ? .init(x: 0, y: 1) : .init(x: 1, y: 0.5)
        } else {
            gradientLayer.startPoint = diagonalMode ? .init(x: 0, y: 0) : .init(x: 0.5, y: 0)
            gradientLayer.endPoint   = diagonalMode ? .init(x: 1, y: 1) : .init(x: 0.5, y: 1)
        }
    }
    func updateLocations() {
        gradientLayer.locations = [startLocation as NSNumber, endLocation as NSNumber]
    }
    func updateColors() {
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
    }
    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updatePoints()
        updateLocations()
        updateColors()
    }

}



@IBDesignable
class LDGradientView: UIView {

    // the gradient start colour
    @IBInspectable var startColor: UIColor? {
        didSet {
            updateGradient()
        }
    }
    
    // the gradient end colour
    @IBInspectable var endColor: UIColor? {
        didSet {
            updateGradient()
        }
    }

    // the gradient angle, in degrees anticlockwise from 0 (east/right)
    @IBInspectable var angle: CGFloat = 270 {
        didSet {
            updateGradient()
        }
    }

    // the gradient layer
    private var gradient: CAGradientLayer?

    // initializers
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        installGradient()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        installGradient()
    }

    // Create a gradient and install it on the layer
    private func installGradient() {
        // if there's already a gradient installed on the layer, remove it
        if let gradient = self.gradient {
            gradient.removeFromSuperlayer()
        }
        let gradient = createGradient()
        self.layer.addSublayer(gradient)
        self.gradient = gradient
    }

    // Update an existing gradient
    private func updateGradient() {
        if let gradient = self.gradient {
            let startColor = self.startColor ?? UIColor.clear
            let endColor = self.endColor ?? UIColor.clear
            gradient.colors = [startColor.cgColor, endColor.cgColor]
            let (start, end) = gradientPointsForAngle(self.angle)
            gradient.startPoint = start
            gradient.endPoint = end
        }
    }

    // create gradient layer
    private func createGradient() -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        return gradient
    }
    
    // create vector pointing in direction of angle
    private func gradientPointsForAngle(_ angle: CGFloat) -> (CGPoint, CGPoint) {
        // get vector start and end points
        let end = pointForAngle(angle)
        //let start = pointForAngle(angle+180.0)
        let start = oppositePoint(end)
        // convert to gradient space
        let p0 = transformToGradientSpace(start)
        let p1 = transformToGradientSpace(end)
        return (p0, p1)
    }
    
    // get a point corresponding to the angle
    private func pointForAngle(_ angle: CGFloat) -> CGPoint {
        // convert degrees to radians
        let radians = angle * .pi / 180.0
        var x = cos(radians)
        var y = sin(radians)
        // (x,y) is in terms unit circle. Extrapolate to unit square to get full vector length
        if (abs(x) > abs(y)) {
            // extrapolate x to unit length
            x = x > 0 ? 1 : -1
            y = x * tan(radians)
        } else {
            // extrapolate y to unit length
            y = y > 0 ? 1 : -1
            x = y / tan(radians)
        }
        return CGPoint(x: x, y: y)
    }

    // transform point in unit space to gradient space
    private func transformToGradientSpace(_ point: CGPoint) -> CGPoint {
        // input point is in signed unit space: (-1,-1) to (1,1)
        // convert to gradient space: (0,0) to (1,1), with flipped Y axis
        return CGPoint(x: (point.x + 1) * 0.5, y: 1.0 - (point.y + 1) * 0.5)
    }

    // return the opposite point in the signed unit square
    private func oppositePoint(_ point: CGPoint) -> CGPoint {
        return CGPoint(x: -point.x, y: -point.y)
    }
    
    // ensure the gradient gets initialized when the view is created in IB
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        installGradient()
        updateGradient()
    }
}

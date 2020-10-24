import UIKit

class GamePlayInfo: UIView {
    
    lazy var tapper: UITapGestureRecognizer = {
        let tapper = UITapGestureRecognizer()
        tapper.addTarget(self, action: #selector(handleTapper(_:)))
        return tapper
    }()
    

    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "GamePlayInfo",
                     bundle: nil).instantiate(withOwner: self,
                                              options: nil).first as! GamePlayInfo
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addGestureRecognizer(tapper)
    }
    
    @objc func handleTapper(_ gesture: UITapGestureRecognizer) {
        self.removeFromSuperview()
    }
    @IBAction func buttonClose(_ sender: Any) {
        self.removeFromSuperview()
    }
}

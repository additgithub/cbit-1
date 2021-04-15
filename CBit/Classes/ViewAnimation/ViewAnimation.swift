import UIKit
import SwiftGifOrigin
import AVFoundation

class ViewAnimation: UIView {
    
    @IBOutlet weak var imageAnimation: UIImageView!
    @IBOutlet weak var btnaudio: UIButton!
    
    
    var isclicked = true
    var avaudio: AVAudioPlayer?

    
    override func awakeFromNib() {
        super.awakeFromNib()
       imageAnimation.loadGif(name: "cbit_briefcase_animation")
        //  imageAnimation.loadGif(name:"lock")
        //  imageAnimation1.loadGif(name: "lock")
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "ViewAnimation",
                     bundle: nil).instantiate(withOwner: self,
                                              options: nil).first as! ViewAnimation
    }
    @objc func pressed(sender: AVAudioPlayer!) {
      
      
    }
    @IBAction func audio_click(_ sender: UIButton) {
        
        if isclicked {
            isclicked = false
            btnaudio.setImage(UIImage(named: "mute"), for: .normal)
            avaudio?.pause()
        }
        else
        {
            isclicked = true
            btnaudio.setImage(UIImage(named: "audio-speaker-on"), for: .normal)
            avaudio?.play()
        }
    }
}



extension UIButton {
    private func actionHandler(action:(() -> Void)? = nil) {
        struct __ { static var action :(() -> Void)? }
        if action != nil { __.action = action }
        else { __.action?() }
    }
    @objc private func triggerActionHandler() {
        self.actionHandler()
    }
    func actionHandler(controlEvents control :UIControl.Event, ForAction action:@escaping () -> Void) {
        self.actionHandler(action: action)
        self.addTarget(self, action: #selector(triggerActionHandler), for: control)
    }
}



class ClosureSleeve {
    let closure: () -> ()

    init(attachTo: AnyObject, closure: @escaping () -> ()) {
        self.closure = closure
        objc_setAssociatedObject(attachTo, "[\(arc4random())]", self, .OBJC_ASSOCIATION_RETAIN)
    }

    @objc func invoke() {
        closure()
    }
}

extension UIControl {
    func addAction(for controlEvents: UIControl.Event = .primaryActionTriggered, action: @escaping () -> ()) {
        let sleeve = ClosureSleeve(attachTo: self, closure: action)
        addTarget(sleeve, action: #selector(ClosureSleeve.invoke), for: controlEvents)
    }
}

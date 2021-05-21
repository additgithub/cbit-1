import UIKit
import SwiftGifOrigin
import AVFoundation

class ViewAnimation: UIView,UICollectionViewDelegate , UICollectionViewDataSource {
    
    @IBOutlet weak var imageAnimation: UIImageView!
    @IBOutlet weak var btnaudio: UIButton!
    
    @IBOutlet weak var viewAdvertise: UIView!
    @IBOutlet weak var collectionAdvertise: UICollectionView!
    @IBOutlet weak var labelNoAds: UILabel!
  //  @IBOutlet weak var constraintAdsHeight: NSLayoutConstraint!
    
    var isclicked = true
    var avaudio: AVAudioPlayer?
    var arrAdvertise = [[String: Any]]()
    var adsTimer: Timer?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    //   imageAnimation.loadGif(name: "cbit_briefcase_animation")
          imageAnimation.loadGif(name:"Bag")
        //  imageAnimation1.loadGif(name: "lock")
       // self.collectionAdvertise.register(advertiseCVC.self, forCellWithReuseIdentifier: "advertiseCVC")
        self.collectionAdvertise.dataSource = self
        self.collectionAdvertise.delegate = self
//        collectionAdvertise?.layer.cornerRadius = 10
//        collectionAdvertise?.layer.borderColor = UIColor.black.cgColor
//        collectionAdvertise?.layer.borderWidth = 3
        
        let layout = collectionAdvertise?.collectionViewLayout as! UICollectionViewFlowLayout
        let width = collectionAdvertise.frame.width
        let height = collectionAdvertise.frame.height
        layout.itemSize = CGSize(width: width-40, height: height)
        let nibName = UINib(nibName: "ADVCollectionViewCell", bundle:nil)
        collectionAdvertise.register(nibName, forCellWithReuseIdentifier: "ADVCollectionViewCell")
        getAdvertise()
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
            UserDefaults.standard.set(false, forKey: "isaudio")
        }
        else
        {
            isclicked = true
            btnaudio.setImage(UIImage(named: "audio-speaker-on"), for: .normal)
            avaudio?.play()
            UserDefaults.standard.set(true, forKey: "isaudio")
        }
    }
    
    func setTimer() {
        adsTimer = Timer.scheduledTimer(timeInterval: 5,
                                        target: self,
                                        selector: #selector(ViewAnimation.handleTimer),
                                        userInfo: nil,
                                        repeats: true)
    }
    @objc func handleTimer() {
        setAdsRotation()
    }

    func setAdsRotation() {
        print("Start")
        let cellSize = collectionAdvertise.frame.size

            //get current content Offset of the Collection view
            let contentOffset = collectionAdvertise.contentOffset

            if collectionAdvertise.contentSize.width <= collectionAdvertise.contentOffset.x + cellSize.width
            {
                let r = CGRect(x: 0, y: contentOffset.y, width: cellSize.width, height: cellSize.height)
                collectionAdvertise.scrollRectToVisible(r, animated: true)

            } else {
                let r = CGRect(x: contentOffset.x + cellSize.width, y: contentOffset.y, width: cellSize.width, height: cellSize.height)
                collectionAdvertise.scrollRectToVisible(r, animated: true);
            }
        
  
        

    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return arrAdvertise.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print(collectionView)


        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ADVCollectionViewCell", for: indexPath) as! ADVCollectionViewCell

            print(self.arrAdvertise)


        let imageURL = URL(string:arrAdvertise[indexPath.row]["image"] as? String ?? "")
        cell.imageAdvertise.sd_setImage(with: imageURL) { (image, error, type, url) in

            }
           return cell
    }


    func getAdvertise() {
        let strURL = Define.APP_URL + Define.API_GET_ADS
        print("URL: \(strURL)")

        SwiftAPI().postMethodSecure(stringURL: strURL,
                                    parameters: nil,
                                    header: Define.USERDEFAULT.value(forKey: "AccessToken") as? String,
                                    auther: Define.USERDEFAULT.value(forKey: "UserID") as? String)
        { (result, error) in
            if error != nil {
                print("Error: \(error!.localizedDescription)")
                self.labelNoAds.isHidden = false
            } else {
                print("Result: \(result!)")
                let status = result!["statusCode"] as? Int ?? 0
                if status == 200 {
                    self.labelNoAds.isHidden = true
                    self.arrAdvertise = result!["content"] as! [[String: Any]]
                    self.collectionAdvertise.reloadData()
                    if self.arrAdvertise.count > 1 {
                        self.setTimer()
                    }
                    self.collectionAdvertise.reloadData()
                } else {
                    self.labelNoAds.isHidden = false
                }
            }
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

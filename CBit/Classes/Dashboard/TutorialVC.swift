import UIKit
import AVFoundation
import SDWebImage
import AVFoundation
import AVKit

class TutorialVC: UIViewController {
    //MARK: - Properties
    @IBOutlet weak var collectionViewTutorial: UICollectionView!
    @IBOutlet weak var buttonGotIt: ButtonWithBlueColor!
    @IBOutlet weak var buttonSkip: UIButton!
    
    var isFromeDashboard = Bool()
    let avPlayerViewController = AVPlayerViewController()
    var playerView: AVPlayer?
//    var arrTutorialImages = [
//
//        UIImage(named: "1.png"),
//        UIImage(named: "2.png"),
//        UIImage(named: "3.png"),
//        UIImage(named: "4.png"),
//        UIImage(named: "5.png"),
//        UIImage(named: "6.png"),
//        UIImage(named: "7.png"),
//        UIImage(named: "8.png"),
//        UIImage(named: "9.png"),
//        UIImage(named: "10.png"),
//        UIImage(named: "11.png"),
//        UIImage(named: "12.png"),
//        UIImage(named: "13.png"),
//        UIImage(named: "14.png"),
//        UIImage(named: "15.png"),
//     //   UIImage(named: "16.png")
//
//
//    ]
    var imgarr = [[String:Any]]()
    var currentIndex = Int()
    
    
    //MARK: - Default Method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonSkip.isHidden = false
        getDemoScreen()
    }
    
    //MARK: - Button Method
    @IBAction func buttonSkip(_ sender: UIButton) {
        let cells = collectionViewTutorial.visibleCells.compactMap({ $0 as? TutorialCVC })
        cells.forEach { videoCell in

            if videoCell.isPlaying {
                videoCell.stopPlaying()
            }
        }
        if isFromeDashboard {
            self.dismiss(animated: true, completion: nil)
        } else {
            let storyBoard = UIStoryboard(name: "Dashboard", bundle: nil)
            let menuVC = storyBoard.instantiateViewController(withIdentifier: "MenuNC")
            menuVC.modalPresentationStyle = .fullScreen
            self.present(menuVC,
                         animated: true, completion:
                {
                    self.navigationController?.popToRootViewController(animated: true)
            })
        }
    }
    
    @IBAction func buttonGotIt(_ sender: UIButton) {
        let cells = collectionViewTutorial.visibleCells.compactMap({ $0 as? TutorialCVC })
        cells.forEach { videoCell in

            if videoCell.isPlaying {
                videoCell.stopPlaying()
            }
        }
        if isFromeDashboard {
            self.dismiss(animated: true, completion: nil)
        } else {
            let storyBoard = UIStoryboard(name: "Dashboard", bundle: nil)
            let menuVC = storyBoard.instantiateViewController(withIdentifier: "MenuNC")
            menuVC.modalPresentationStyle = .fullScreen
            self.present(menuVC,
                         animated: true, completion:
                {
                    self.navigationController?.popToRootViewController(animated: true)
            })
        }
    }
    
    func getDemoScreen() {
        
        Loading().showLoading(viewController: self)
        
        let parameters:[String: Any] = [:]
        let strURL = Define.APP_URL + Define.getDemoScreen
                print("Parameter: \(parameters)\nURL: \(strURL)")
                
                let jsonString = MyModel().getJSONString(object: parameters)
                let encriptString = MyModel().encrypting(strData: jsonString!, strKey: Define.KEY)
                let strBase64 = encriptString.toBase64()
                
                SwiftAPI().postMethodSecure(stringURL: strURL,
                                            parameters: ["data": strBase64!],
                                            header: nil,
                                            auther: nil)
                { (result, error) in
                    if error != nil {
                        Loading().hideLoading(viewController: self)
                        print("Error: \(error!)")
   
                        
                    } else {
                        Loading().hideLoading(viewController: self)
                        print("Result: \(result!)")
                        let status = result!["statusCode"] as? Int ?? 0
                        if status == 200 {
                            let dictData = result!["content"] as! [String: Any]
                            
                            let contest = dictData["contest"] as? [[String:Any]]
                            
                            self.imgarr = contest ?? []
                            self.collectionViewTutorial.reloadData()
                           // self.parameter["otp"] = dictData["otp"]!
                           // self.parameter["otpId"] = dictData["otpId"]!
                            
                           // self.textOTP.text = "\(dictData["otp"]!)";
                            
                        }
              
                        else {
                            Alert().showAlert(title: "Error",
                                              message: result!["message"] as! String,
                                              viewController: self)
                        }
                    }
                }
        
}
}
//MARK: - Collection View Delegate Method
extension TutorialVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgarr.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionViewTutorial.frame.width, height: self.collectionViewTutorial.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionViewTutorial.dequeueReusableCell(withReuseIdentifier: "TutorialCVC", for: indexPath) as! TutorialCVC
      //  cell.imageTutorial.sd_setImage(with: URL(string: imgarr[indexPath.row]["image"] as! String),placeholderImage:Define.PLACEHOLDER_PROFILE_IMAGE)
        let remoteurl = imgarr[indexPath.row]["image"] as! String
        if remoteurl.isImage()
        {
            Loading().showLoading(viewController: self)
            SDWebImageManager.shared().loadImage(
                    with: URL(string: imgarr[indexPath.row]["image"] as! String),
                    options: .highPriority,
                    progress: nil) { (image, data, error, cacheType, isFinished, imageUrl) in
                        print(isFinished)
                        Loading().hideLoading(viewController: self)
            //    self.myGroup.leave()
                if image != nil {
                    cell.imageTutorial.image = image
                     }
                  }
        }
        else
        {
            cell.videolink = URL(string: remoteurl)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let videoCell = cell as? TutorialCVC else { return }
        videoCell.startPlaying()
    }
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let videoCell = cell as? TutorialCVC else { return }
        videoCell.stopPlaying()
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
       let cells = collectionViewTutorial.visibleCells.compactMap({ $0 as? TutorialCVC })
       cells.forEach { videoCell in

           if videoCell.isPlaying {
               videoCell.stopPlaying()
           }
       }
    }

    // TODO: write logic to start the video after it ends scrolling
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
       guard !decelerate else { return }
       let cells = collectionViewTutorial.visibleCells.compactMap({ $0 as? TutorialCVC })
       cells.forEach  { videoCell in

           if !videoCell.isPlaying  {
               videoCell.startPlaying()
           }
       }
    }

    // TODO: write logic to start the video after it ends scrolling (programmatically)

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let cells = collectionViewTutorial.visibleCells.compactMap({ $0 as? TutorialCVC })
        cells.forEach { videoCell in
           // TODO: write logic to start the video after it ends scrolling
           if !videoCell.isPlaying  {
               videoCell.startPlaying()
           }
       }
        let pageWidth = collectionViewTutorial.frame.width
        let currentPage = collectionViewTutorial.contentOffset.x / pageWidth
        
        if (0.0 != fmodf(Float(currentPage), 1.0))
        {
            currentIndex = Int(currentPage + 1);
        }
        else
        {
            currentIndex = Int(currentPage);
        }
        
        if currentIndex == (imgarr.count - 1) {
            self.buttonGotIt.isHidden = false
            self.buttonSkip.isHidden = true
        } else {
            self.buttonGotIt.isHidden = true
            self.buttonSkip.isHidden = false
        }
    }
}

//MARK: - Collection View Cell Class
class TutorialCVC: UICollectionViewCell {
    
    @IBOutlet weak var imageTutorial: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    public var isPlaying: Bool = false
        public var videolink: URL? = nil {
            didSet {
                guard let link = videolink, oldValue != link else { return }
                loadVideoUsingURL(link)
            }
        }
        private var queuePlayer = AVQueuePlayer()
        private var playerLayer = AVPlayerLayer()
        private var looperPlayer: AVPlayerLooper?
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            commonInit()
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            
            commonInit()
        }
        
        private func commonInit() {
            
          //  queuePlayer.volume = 0.0
            queuePlayer.actionAtItemEnd = .none
            
            playerLayer.videoGravity = .resizeAspect
            playerLayer.name = "videoLoopLayer"
            playerLayer.cornerRadius = 5.0
            playerLayer.masksToBounds = true
            contentView.layer.addSublayer(playerLayer)
            playerLayer.player = queuePlayer
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            
            /// Resize video layer based on new frame
            playerLayer.frame = imageTutorial.frame //CGRect(origin: .zero, size: CGSize(width: frame.width, height: frame.width))
        }
        
        private func loadVideoUsingURL(_ url: URL) {
            /// Load asset in background thread to avoid lagging
            DispatchQueue.global(qos: .background).async {
                let asset = AVURLAsset(url: url)
                /// Load needed values asynchronously
                asset.loadValuesAsynchronously(forKeys: ["duration", "playable"]) {
                    /// UI actions should executed on the main thread
                    DispatchQueue.main.async { [weak self] in
                        guard let `self` = self else { return }
                        let item = AVPlayerItem(asset: asset)
                        if self.queuePlayer.currentItem != item {
                            self.queuePlayer.replaceCurrentItem(with: item)
                            self.looperPlayer = AVPlayerLooper(player: self.queuePlayer, templateItem: item)
                        }
                    }
                }
            }
        }
        
        public func startPlaying() {
            queuePlayer.play()
            isPlaying = true
        }
        
        public func stopPlaying() {
            queuePlayer.pause()
            isPlaying = false
        }
    
}
extension String {

       public func isImage() -> Bool {
           // Add here your image formats.
           let imageFormats = ["jpg", "jpeg", "png", "gif"]

           if let ext = self.getExtension() {
               return imageFormats.contains(ext)
           }

           return false
       }

       public func getExtension() -> String? {
          let ext = (self as NSString).pathExtension

          if ext.isEmpty {
              return nil
          }

          return ext
       }

       public func isURL() -> Bool {
          return URL(string: self) != nil
       }

   }

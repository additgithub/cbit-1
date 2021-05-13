import UIKit
import SDWebImage
class TutorialVC: UIViewController {
    //MARK: - Properties
    @IBOutlet weak var collectionViewTutorial: UICollectionView!
    @IBOutlet weak var buttonGotIt: ButtonWithBlueColor!
    @IBOutlet weak var buttonSkip: UIButton!
    
    var isFromeDashboard = Bool()
    
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
        
        Loading().showLoading(viewController: self)
        SDWebImageManager.shared().loadImage(
                with: URL(string: imgarr[indexPath.row]["image"] as! String),
                options: .highPriority,
                progress: nil) { (image, data, error, cacheType, isFinished, imageUrl) in
                  print(isFinished)
        //    self.myGroup.leave()
            if image != nil {
                cell.imageTutorial.image = image
                Loading().hideLoading(viewController: self)
                 }
            
              }
        
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
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
}

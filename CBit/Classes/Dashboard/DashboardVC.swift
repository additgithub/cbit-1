import UIKit
import Parchment
import UserNotifications
import AVFoundation
import AVKit
import SocketIO
import SDWebImage

class DashboardVC: UIViewController {

  
    @IBOutlet weak var HeightSpecial: NSLayoutConstraint!
    @IBOutlet weak var veSpecialNoContest: UIView!
    
  
    @IBOutlet weak var collectionSpecialcontest: UICollectionView!
    @IBOutlet weak var viewNavigation: UIView!
    @IBOutlet weak var viewAdvertise: UIView!
    @IBOutlet weak var collectionAdvertise: UICollectionView!
    @IBOutlet weak var labelNoAds: UILabel!
    @IBOutlet weak var labelTitle: UILabel!
    
    @IBOutlet weak var constraintAdsHeight: NSLayoutConstraint!
    @IBOutlet weak var pagingvw: UIView!
    @IBOutlet weak var vwpopupreward: UIView!
    @IBOutlet weak var imgreward: UIImageView!
    
    private var arrSpecialContest = [[String: Any]]()
    var arrAdvertise = [[String: Any]]()
    var storeimage = [[String: Any]]()
    
    var currentIndex = 0
    
    var adsTimer: Timer?
    
    
   var pagingViewController = FixedPagingViewController(viewControllers: [])
            
          
    
    private var isRefresh = Bool()
    private var isSpecialContest = Bool()
    private var isShowLoading = Bool()
    private var isVisible = Bool()
    private var currentData = Date()
//      lazy  var refreshControl: UIRefreshControl = {
//          let refreshControl = UIRefreshControl()
//          refreshControl.addTarget(self, action: #selector(self.handleRefresh(_:)), for: .valueChanged)
//          refreshControl.tintColor = Define.APPCOLOR
//          return refreshControl
//      }()
    var socket: SocketIOClient!
    var myGroup = DispatchGroup()
    override func viewDidLoad() {
        super.viewDidLoad()
       // UNUserNotificationCenter.current().delegate = self
       // constraintAdsHeight.constant = self.view.frame.width / 3
       
          //   socket.off("onContestLive")
        
         if UserDefaults.standard.bool(forKey: "isfromregister")
         {
            vwpopupreward.isHidden = false
            self.view.bringSubviewToFront(vwpopupreward)
            let imageURL = UserDefaults.standard.string(forKey: "ImageDownload") ?? ""
            imgreward.sd_setImage(with: URL(string: imageURL), placeholderImage: Define.PLACEHOLDER_PROFILE_IMAGE)
         }
        else
         {
            vwpopupreward.isHidden = true
         }
      
        let playVC = self.storyboard?.instantiateViewController(withIdentifier: "PlayVC") as! PlayVC
            let myContentVC = self.storyboard?.instantiateViewController(withIdentifier: "MyContestVC") as! MyContestVC
                                      
        pagingViewController = FixedPagingViewController(viewControllers: [playVC,myContentVC]
                                      )
               
              addChild(pagingViewController)
                            view.addSubview(pagingViewController.view)
                            pagingViewController.didMove(toParent: self)
        
        
        setPageMenu()
        getAdvertise()
        getAllSpecialContest()
        getSpinningMachine()
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotitication(_:)),name:.getAllspecialContest,object: nil)
              
        if !MyModel().isLogedIn() {
                   Alert().showTost(message: Define.ERROR_INTERNET, viewController: self)
            
               } else {
            
                   isShowLoading = true
                   getAllSpecialContest()
            
               }
    
        getReferalCriteriaChart()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getUserInfo()
        getUserData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { // Change `2.0` to the desired number of seconds.
           // Code you want to be delayed
            self.getUserJoinDateTime()
        }
       
        NotificationCenter.default.addObserver(
             self,
             selector: #selector(applicationWillEnterForeground(_:)),
             name: UIApplication.willEnterForegroundNotification,
             object: nil)
    }
    
    @objc func applicationWillEnterForeground(_ notification: NSNotification) {
        print("App moved to foreground!")
        }
    
    @objc func handleNotitication(_ notification: Notification) {
           isShowLoading = false
           self.getAllSpecialContest()
           
       }
    
    override func viewDidLayoutSubviews() {
        self.pagingViewController.view.frame = self.pagingvw.frame
        self.pagingViewController.view.layoutIfNeeded()
        self.view.layoutSubviews()
        self.view.bringSubviewToFront(vwpopupreward)
    }
    
    
    
    
    func setPageMenu() {
        
        

        
        print("Font Name: \(labelTitle!.font.fontName)")
        //Ubuntu-Medium
        pagingViewController.textColor = #colorLiteral(red: 0.6470588235, green: 0.6470588235, blue: 0.6470588235, alpha: 1)
        pagingViewController.selectedTextColor = #colorLiteral(red: 0, green: 0.2535815537, blue: 0, alpha: 1)
        pagingViewController.indicatorColor = #colorLiteral(red: 1, green: 0.831372549, blue: 0.3215686275, alpha: 1)
        pagingViewController.font = UIFont(name: labelTitle!.font.fontName, size: 13)!
        pagingViewController.selectedFont = UIFont(name: labelTitle.font.fontName, size: 13)!
        pagingViewController.menuItemSize = .fixed(width: view.frame.width / 2, height: 50)
        pagingViewController.menuBackgroundColor = UIColor.white
//        pagingViewController.indicatorOptions = .visible(height: 3,
//                                                         zIndex: Int.max,
//                                                         spacing: UIEdgeInsets.zero,
//                                                         insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        
        pagingViewController.borderOptions = .visible(height: 0,
                                                      zIndex: 0,
                                                      insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        
        
     
        
        
       
        
       // DispatchQueue.main.async {
            self.pagingViewController.view.frame = self.pagingvw.frame
            self.pagingViewController.view.layoutIfNeeded()
//            self.pagingViewController.viewDidLayoutSubviews()
//            self.pagingViewController.loadViewIfNeeded()
     //   }
  
            
//        pagingViewController.view.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//
//            pagingViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: (self.view.frame.width / 3) + 50),
//            pagingViewController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
//            pagingViewController.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
//            pagingViewController.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
//
//
//            ])
//
//
//
//        if isSpecialContest {
//
//            pagingViewController.view.translatesAutoresizingMaskIntoConstraints = false
//            pagingViewController.view.updateConstraint(attribute: NSLayoutConstraint.Attribute.top,constant:255)
//
//        }
//
//
//        else
//        {
//
//        pagingViewController.view.translatesAutoresizingMaskIntoConstraints = false
//        pagingViewController.view.updateConstraint(attribute:NSLayoutConstraint.Attribute.top, constant:100)
//
//        }
//                   NSLayoutConstraint.activate([
//                       pagingViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: (self.view.frame.width / 3) + 50),
//                       pagingViewController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
//                       pagingViewController.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
//                       pagingViewController.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
//                       ])
            
            
        
        
    }
  

    func setTimer() {
        adsTimer = Timer.scheduledTimer(timeInterval: 5,
                                        target: self,
                                        selector: #selector(handleTimer),
                                        userInfo: nil,
                                        repeats: true)
    }
    @objc func handleTimer() {
        setAdsRotation()
    }
    
    func setAdsRotation() {
        //print("Start")
       
             if currentIndex == (arrAdvertise.count - 1) {
                       currentIndex = 0
                       let indexPath = IndexPath(item: currentIndex, section: 0)
                       self.collectionAdvertise.scrollToItem(at: indexPath, at: [.centeredHorizontally], animated: false)
                   } else {
                       currentIndex = currentIndex + 1
                       let indexPath = IndexPath(item: currentIndex, section: 0)
                       self.collectionAdvertise.scrollToItem(at: indexPath, at: [.centeredHorizontally], animated: true)
                   }
        
        
       if let coll  = collectionSpecialcontest {
                   for cell in coll.visibleCells {
                       let indexPath: IndexPath? = coll.indexPath(for: cell)
                       if ((indexPath?.row)! < arrSpecialContest.count - 1){
                           let indexPath1: IndexPath?
                           indexPath1 = IndexPath.init(row: (indexPath?.row)! + 1, section: (indexPath?.section)!)

                           coll.scrollToItem(at: indexPath1!, at: .right, animated: true)
                       }
                       else{
                           let indexPath1: IndexPath?
                           indexPath1 = IndexPath.init(row: 0, section: (indexPath?.section)!)
                           coll.scrollToItem(at: indexPath1!, at: .left, animated: true)
                       }

                   }
               }
       
    }
    
    //MARK: - Button Method
    @IBAction func buttonMenu(_ sender: Any) {
        sideMenuController?.revealMenu()
    }
    @IBAction func closepopup_click(_ sender: UIButton) {
        vwpopupreward.isHidden = true
        UserDefaults.standard.set(false, forKey: "isfromregister")
    }
    
    @IBAction func buttonHowToPLay(_ sender: Any) {
        
       let videoURL = URL(string:"https://www.cbitoriginal.com/howtoplayvideo.MP4")
        let player = AVPlayer(url: videoURL!)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
        playerViewController.player!.play()
    }
}
    @IBAction func classicgrid_click(_ sender: UIButton) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "ATG", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "NewCGTicketVC") as! NewCGTicketVC
        if sender.tag == 1 {
            nextViewController.gametype  = "rdb"
        }
        else
        {
            nextViewController.gametype  = "0-9"
        }
        self.navigationController?.pushViewController(nextViewController, animated: true)
        
    }
    @IBAction func spinningmachine_click(_ sender: UIButton) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "ATG", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "NewAGSMTicketVC") as! NewAGSMTicketVC
        self.navigationController?.pushViewController(nextViewController, animated: true)
        
//        let SpinningMachineVC = self.storyboard?.instantiateViewController(withIdentifier: "SpinningMachineVC") as! SpinningMachineVC
//        SpinningMachineVC.storeimage = storeimage
//        self.navigationController?.pushViewController(SpinningMachineVC, animated: true)
    }
}
//MARK: - Notifcation Delegate Method
//extension DashboardVC: UNUserNotificationCenterDelegate {
//    func userNotificationCenter(_ center: UNUserNotificationCenter,
//                                willPresent notification: UNNotification,
//                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        completionHandler([.alert, .sound])
//    }
//    func userNotificationCenter(_ center: UNUserNotificationCenter,
//                                didReceive response: UNNotificationResponse,
//                                withCompletionHandler completionHandler: @escaping () -> Void) {
//        switch response.actionIdentifier {
//        case Define.PLAYGAME:
//            print("Play Game")
//            let dictData = response.notification.request.content.userInfo as! [String: Any]
//            print(dictData)
//            let gamePlayVC = self.storyboard?.instantiateViewController(withIdentifier: "GamePlayVC") as! GamePlayVC
//            gamePlayVC.isFromNotification = true
//            gamePlayVC.dictContest = dictData
//            self.navigationController?.pushViewController(gamePlayVC, animated: true)
//        default:
//            break
//        }
//        
//    }
//}

//MARK: - Collection View Delegate Method
extension DashboardVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        if collectionView == self.collectionSpecialcontest
        {
            return arrSpecialContest.count
            
        }
        if collectionView == self.collectionAdvertise
        {
            return arrAdvertise.count
            
        }
        fatalError()
       // return arrAdvertise.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print(collectionView)
        
        
        if collectionView == self.collectionSpecialcontest {
        
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SpecialContestTVC", for: indexPath) as! SpecialContestTVC

            let game_type = arrSpecialContest[indexPath.row]["game_type"] as! String
            if game_type == "spinning-machine" {
                cell.imageLevel.image = #imageLiteral(resourceName: "slot_machine")
            }
            else
            {
                cell.imageLevel.image = #imageLiteral(resourceName: "classic_grid")
            }
            //Set Data
                 cell.labelContestName.text = arrSpecialContest[indexPath.row]["name"] as? String ?? "No Name"
                 
                 cell.currentDate = currentData
                 //let currentDate = MyModel().convertDateToString(date: Date(),
                 //                                                returnFormate: "yyyy-MM-dd HH:mm:ss")
                 let startDate = arrSpecialContest[indexPath.row]["startDate"] as! String
                 cell.startDate = nil
                 //cell.timer = nil
                 cell.startDate = MyModel().converStringToDate(strDate: startDate, getFormate: "yyyy-MM-dd HH:mm:ss")
                 
                 let closeTime = arrSpecialContest[indexPath.row]["closeDate"] as! String
                 cell.closeDate = nil
                 //cell.closeTimer = nil
                 cell.closeDate = MyModel().converStringToDate(strDate: closeTime, getFormate: "yyyy-MM-dd HH:mm:ss")
                 
                 cell.labelContestDate.text = "Date: \( MyModel().convertStringDateToString(strDate: startDate, getFormate: "yyyy-MM-dd HH:mm:ss", returnFormat: "dd-MM-yyyy"))"
                 cell.labelContestTime.text = MyModel().convertStringDateToString(strDate: startDate,
                                                                                  getFormate: "yyyy-MM-dd HH:mm:ss",
                                                                                  returnFormat: "hh:mm a")
            
          
            
            
//                 let gameLevel = arrSpecialContest[indexPath.row]["level"] as? Int ?? 1
//
//                 if gameLevel == 1 {
//                     //Easy
//                     cell.imageLevel.image = #imageLiteral(resourceName: "ic_e")
//                 } else if gameLevel == 2 {
//                     //Modred
//                     cell.imageLevel.image = #imageLiteral(resourceName: "ic_m")
//                 } else if gameLevel == 3 {
//                     //Pro
//                     cell.imageLevel.image = #imageLiteral(resourceName: "ic_p")
//                 }
                 
//                 let gameMode = arrSpecialContest[indexPath.row]["type"] as? Int ?? 0
//
//                 if gameMode == 0 {
//                     //Flexi Bar
//                     cell.imageMode.image = #imageLiteral(resourceName: "ic_flexi_new")
//                 } else if gameMode == 1 {
//                     //Fix Bar
//                     cell.imageMode.image = #imageLiteral(resourceName: "ic_fix_new")
//                 }
                 
                 //Set Button
                 cell.buttonPlayNow.addTarget(self, action: #selector(buttonPlayNow(_:)), for: .touchUpInside)
                 cell.buttonPlayNow.tag = indexPath.row
                 
               
               
        

          
        DispatchQueue.main.async {
           
            MyModel().roundCorners(corners: [.topLeft, .bottomLeft], radius: 5, view: cell.buttonPlayNow)
            MyModel().roundCorners(corners: [.topLeft,.bottomLeft,.bottomRight,.topRight], radius:15, view: cell.ViewStar)
            cell.viewSpecialContest.layer.borderColor = #colorLiteral(red: 0.1019607843, green: 0.3137254902, blue: 0.3647058824, alpha: 1)
            cell.viewSpecialContest.layer.borderWidth = 2.0
//            cell.ViewStar.layer.borderColor = #colorLiteral(red: 0.1019607843, green: 0.3137254902, blue: 0.3647058824, alpha: 1)
//            cell.ViewStar.layer.borderWidth = 2.0
//            cell.viewSpecialContest.layer.shadowColor = #colorLiteral(red: 0.1019607843, green: 0.3137254902, blue: 0.3647058824, alpha: 1)
            cell.viewSpecialContest.layer.shadowOpacity = 0.5
            cell.viewSpecialContest.layer.shadowOffset = CGSize(width: 0, height: 0)
            cell.viewSpecialContest.layer.shadowRadius = 3
            cell.viewSpecialContest.layer.cornerRadius = 5
            cell.viewSpecialContest.layer.masksToBounds = false
              }
            return cell
              
        }
    
        if collectionView == self.collectionAdvertise
        {
            
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "advertiseCVC", for: indexPath) as! advertiseCVC

            print(self.arrAdvertise)
            
            
        let imageURL = URL(string:arrAdvertise[indexPath.row]["image"] as? String ?? "")
        cell.imageAdvertise.sd_setImage(with: imageURL) { (image, error, type, url) in

            }
           return cell
            
            }
        
         fatalError("Unexpected element kind")
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == collectionSpecialcontest{

       return CGSize(width:self.collectionSpecialcontest.frame.width, height:self.collectionSpecialcontest.frame.height)
        }
        if collectionView == collectionAdvertise {
             return CGSize(width:self.collectionAdvertise.frame.width, height:100)
        }
       fatalError()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {


             return 0


    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {



                    return 0

    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let game_type = arrSpecialContest[indexPath.row]["game_type"] as! String
        if game_type == "spinning-machine" {
            let SpinningMachineTicketVC = self.storyboard?.instantiateViewController(withIdentifier: "SpinningMachineTicketVC") as! SpinningMachineTicketVC
            SpinningMachineTicketVC.dictContest = arrSpecialContest[indexPath.row]
           // SpinningMachineTicketVC.storeimage = storeimage
            self.navigationController?.pushViewController(SpinningMachineTicketVC, animated: true)
        }
        else
        {
            let ticketVC = self.storyboard?.instantiateViewController(withIdentifier: "TicketVC") as! TicketVC
            ticketVC.dictContest = arrSpecialContest[indexPath.row]
            self.navigationController?.pushViewController(ticketVC, animated: true)
        }
        
//        let ticketVC = self.storyboard?.instantiateViewController(withIdentifier: "TicketVC") as! TicketVC
//        ticketVC.dictContest = arrSpecialContest[indexPath.row]
//        self.navigationController?.pushViewController(ticketVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

         
     if collectionView == collectionAdvertise
     {

        let cellWidth: CGFloat = self.viewAdvertise.frame.size.width// Your cell width

        let numberOfCells = floor(view.frame.size.width / cellWidth)
        let edgeInsets = (view.frame.size.width - (numberOfCells * cellWidth)) / (numberOfCells + 1)

        return UIEdgeInsets(top: 0, left: edgeInsets, bottom: 0, right: edgeInsets)
        }
        
        
        if collectionView == collectionSpecialcontest
        {
         

                   return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    fatalError()

    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = collectionAdvertise.frame.width
        let currentPage = collectionAdvertise.contentOffset.x / pageWidth
        
        if (0.0 != fmodf(Float(currentPage), 1.0))
        {
            currentIndex = Int(currentPage + 1);
        }
        else
        {
            currentIndex = Int(currentPage);
        }
    }
    
    @objc func buttonPlayNow(_ sender: UIButton) {
        isVisible = false
        let index = sender.tag
        
        let game_type = arrSpecialContest[index]["game_type"] as! String
        if game_type == "spinning-machine" {
            let SpinningMachineTicketVC = self.storyboard?.instantiateViewController(withIdentifier: "SpinningMachineTicketVC") as! SpinningMachineTicketVC
            SpinningMachineTicketVC.dictContest = arrSpecialContest[index]
           // SpinningMachineTicketVC.storeimage = storeimage
            self.navigationController?.pushViewController(SpinningMachineTicketVC, animated: true)
        }
        else
        {
            let ticketVC = self.storyboard?.instantiateViewController(withIdentifier: "TicketVC") as! TicketVC
            ticketVC.dictContest = arrSpecialContest[index]
            self.navigationController?.pushViewController(ticketVC, animated: true)
        }
        
//                  isVisible = false
//                  let index = sender.tag
//                  let ticketVC = self.storyboard?.instantiateViewController(withIdentifier: "TicketVC") as! TicketVC
//                  ticketVC.dictContest = arrSpecialContest[index]
//                  ticketVC.isFromMyTickets = false
//                  self.navigationController?.pushViewController(ticketVC, animated: true)
              }
}

//MARK: - API {
extension DashboardVC {
    func getUserInfo() {
        let strURL = Define.APP_URL + Define.getUserInfo
        print("URL: \(strURL)")
        let parameter: [String: Any] = ["plateform": "ios","version": Define.APP_VERSION,"device":UIDevice.modelName,"device_version":UIDevice.current.systemVersion]
        SwiftAPI().postMethodSecure(stringURL: strURL,
                                    parameters: parameter,
                                    header: Define.USERDEFAULT.value(forKey: "AccessToken") as? String,
                                    auther: Define.USERDEFAULT.value(forKey: "UserID") as? String)
        { (result, error) in
            if error != nil {
                print("Error: \(error!.localizedDescription)")
            } else {
                print("Result: \(result!)")
                let status = result!["statusCode"] as? Int ?? 0
                if status == 200 {
                } else {
                }
            }
        }
    }
    
    func getUserData() {
        let strURL = Define.APP_URL + Define.getUserData
        print("URL: \(strURL)")
        let parameter: [String: Any] = [:]
        SwiftAPI().postMethodSecure(stringURL: strURL,
                                    parameters: parameter,
                                    header: Define.USERDEFAULT.value(forKey: "AccessToken") as? String,
                                    auther: Define.USERDEFAULT.value(forKey: "UserID") as? String)
        { (result, error) in
            if error != nil {
                print("Error: \(error!.localizedDescription)")
            } else {
                print("Result: \(result!)")
                let status = result!["statusCode"] as? Int ?? 0
                if status == 200 {
                    let userData = result!["contest"] as! [String: Any]
                    Define.USERDEFAULT.set("\(userData["id"]!)", forKey: "UserID")
                    Define.USERDEFAULT.set(userData["firstName"]!, forKey: "FirstName")
                    Define.USERDEFAULT.set(userData["middelName"]!, forKey: "MiddelName")
                    Define.USERDEFAULT.set(userData["lastName"]!, forKey: "LastName")
                    Define.USERDEFAULT.set(userData["userName"]!, forKey: "UserName")
                    Define.USERDEFAULT.set(userData["email"]!, forKey: "Email")
                    Define.USERDEFAULT.set(userData["myCode"]!, forKey: "UserCode")
                    Define.USERDEFAULT.set(userData["mobile_no"]!, forKey: "UserMobile")
                    Define.USERDEFAULT.set(userData["profile_image"], forKey: "ProfileImage")
                    
                     Define.USERDEFAULT.set(userData["AutoPilot"], forKey: "AutoPilot")
                     Define.USERDEFAULT.set(userData["isRedeem"], forKey: "isRedeem")
                    
                    
                    let setNotification = userData["setNotification"] as? Bool ?? false
                    Define.USERDEFAULT.set(setNotification, forKey: "SetNotification")
                    
                    let dictAmount = userData["wallateDetails"] as! [String: Any]
                    
                    Define.USERDEFAULT.set(dictAmount["pbAmount"] as? Double ?? 0.0, forKey: "PBAmount")
                    Define.USERDEFAULT.set(dictAmount["sbAmount"] as? Double ?? 0.0, forKey: "SBAmount")
                    Define.USERDEFAULT.set(dictAmount["tbAmount"] as? Double ?? 0.0, forKey: "TBAmount")
                    Define.USERDEFAULT.set(dictAmount["ccAmount"] as? Double ?? 0.0, forKey: "ccAmount")
                    
                    let walletAuth = dictAmount["WalletAuth"] as! Int
                                        UserDefaults.standard.set(walletAuth, forKey: "WalletAuth")
                    
                    let isBankVerify = userData["verify_bank"] as? Bool ?? false
                    
                    Define.USERDEFAULT.set(userData["verify_pan"] as? Int ?? 0, forKey: "IsPanVerify")
                    Define.USERDEFAULT.set(isBankVerify, forKey: "IsBankVerify")
                    
                    let isEmailVerify = userData["verify_email"] as? Bool ?? false
                    Define.USERDEFAULT.set(isEmailVerify, forKey: "IsEmailVerify")
                   
                } else {
                }
            }
        }
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
    
    func getSpinningMachine() {
        let strURL = Define.APP_URL + Define.getSpinningMachine
        print("URL: \(strURL)")
        let parameter: [String: Any] = ["test": ""]
        
        SwiftAPI().postMethodSecure(stringURL: strURL,
                                    parameters: parameter,
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
                   let dict = result!["content"] as! [String: Any]
                    self.storeimage = dict["contest"] as? [[String: Any]] ?? []
                    Define.Globalimagearr = self.storeimage
                    self.SavedImageToLocal()
                    
                } else {
                   
                }
            }
        }
    }
   
    
    func SavedImageToLocal()  {
        Loading().showLoading(viewController: self)
        for dict in storeimage {
            myGroup.enter()
            SDWebImageManager.shared().loadImage(
                    with: URL(string: dict["image"] as! String),
                    options: .highPriority,
                    progress: nil) { (image, data, error, cacheType, isFinished, imageUrl) in
                      print(isFinished)
                self.myGroup.leave()
                if image != nil {
                    self.saveImageToDocumentDirectory(image: image!, name: dict["name"] as! String)
                   
                     }
                
                  }
            
//            SDWebImageManager.shared().loadImage(
//                with: URL(string: dict["image"] as! String),
//                options: .continueInBackground, // or .highPriority
//                progress: nil,
//                completed: { [weak self] (image, data, error, cacheType, finished, url) in
//                    guard let sself = self else { return }
//
//                    if let err = error {
//                        // Do something with the error
//                        return
//                    }
//
//                    guard let img = image else {
//                        // No image handle this error
//                        return
//                    }
//                    self?.saveImageToDocumentDirectory(image: image!, name: dict["name"] as! String)
//                    // Do something with image
//                }
//            )
            
           // downloadImage(from: URL(string: dict["image"] as! String)!, name: dict["name"] as! String)
            
         //   PlaygroundPage.current.needsIndefiniteExecution = true

//            let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

//            if let url = URL(string: "https://i.stack.imgur.com/xnZXF.jpg") {
//                URLSession.shared.downloadTask(with: url) { location, response, error in
//                    guard let location = location else {
//                        print("download error:", error ?? "")
//                        return
//                    }
//                    saveImageToDocumentDirectory(image: UIImage(data: location))
//
//                    // move the downloaded file from the temporary location url to your app documents directory
//                    do {
//                        try FileManager.default.moveItem(at: location, to: documents.appendingPathComponent(response?.suggestedFilename ?? url.lastPathComponent))
//                    } catch {
//                        print(error)
//                    }
//                }.resume()
//            }
            
            
        }
        myGroup.notify(queue: .main) {
                print("Finished all requests.")
            Loading().hideLoading(viewController: self)
            }
       
    }
    
    func downloadImage(from url: URL,name:String) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() { [weak self] in
                self?.saveImageToDocumentDirectory(image: UIImage(data: data)!, name: name)
            }
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func saveImageToDocumentDirectory(image: UIImage,name:String ) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileName = name // name of the image to be saved
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        if let data = image.pngData(),!FileManager.default.fileExists(atPath: fileURL.path){
            do {
                try data.write(to: fileURL)
                print("file saved")
            } catch {
                print("error saving file:", error)
            }
        }
    }


    func loadImageFromDocumentDirectory(nameOfImage : String) -> UIImage {
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        if let dirPath = paths.first{
            let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent(nameOfImage)
            let image    = UIImage(contentsOfFile: imageURL.path)
            return image!
        }
        return UIImage.init(named: "default.png")!
    }
    
    //Get User Type :- VIP , Master , Super Master etc.
    func getReferalCriteriaChart() {
        Loading().showLoading(viewController: self)
        let parameter: [String: Any] = [:
        ]
        let strURL = Define.APP_URL + Define.referal_criteria_chart
        print("Parameter: \(parameter)\nURL: \(strURL)")
        
        let jsonString = MyModel().getJSONString(object: parameter)
        let encriptString = MyModel().encrypting(strData: jsonString!, strKey: Define.KEY)
        let strbase64 = encriptString.toBase64()
        
        SwiftAPI().postMethodSecure(stringURL: strURL,
                                    parameters: ["data":strbase64!],
                                    header: Define.USERDEFAULT.value(forKey: "AccessToken") as? String,
                                    auther: Define.USERDEFAULT.value(forKey: "UserID") as? String)
        { (result, error) in
            if error != nil {
                Loading().hideLoading(viewController: self)
                print("Error: \(error!)")
                //                Alert().showAlert(title: "Error",
                //                                  message: Define.ERROR_SERVER,
                //                                  viewController: self)
                self.getReferalCriteriaChart()
            } else {
                Loading().hideLoading(viewController: self)
                print("Result: \(result!)")
                let status = result!["statusCode"] as? Int ?? 0
                if status == 200 {
                    let content = result!["content"] as! [String: Any]
                    //self.referallistarr = content["ReferralList"] as? [[String : Any]] ?? []
                    //self.setdata(dict: content)
                    
                    let userType = "\(content["UserCriteriaID"]!)"
                    Define.USERDEFAULT.setValue(userType, forKey: "UserCriteriaID")
                    
                    
                } else if status == 401 {
                    Define.APPDELEGATE.handleLogout()
                } else {
                    Alert().showAlert(title: "Error",
                                      message: result!["message"] as! String,
                                      viewController: self)
                }
            }
        }
    }
    
    func getUserJoinDateTime() {
      //  Loading().showLoading(viewController: self)
        let parameter: [String: Any] = [:]
        let strURL = Define.APP_URL + Define.getUserJoinDateTime
        print("Parameter: \(parameter)\nURL: \(strURL)")
        
        let jsonString = MyModel().getJSONString(object: parameter)
        let encriptString = MyModel().encrypting(strData: jsonString!, strKey: Define.KEY)
        let strbase64 = encriptString.toBase64()
        
        SwiftAPI().postMethodSecure(stringURL: strURL,
                                    parameters: ["data":strbase64!],
                                    header: Define.USERDEFAULT.value(forKey: "AccessToken") as? String,
                                    auther: Define.USERDEFAULT.value(forKey: "UserID") as? String)
        { (result, error) in
            if error != nil {
             //   Loading().hideLoading(viewController: self)
                
             //   self.getUserJoinDateTime()
            } else {
           //     Loading().hideLoading(viewController: self)
                print("Result: \(result!)")
                let status = result!["statusCode"] as? Int ?? 0
                if status == 200 {
                    let dict =  result!["content"] as! [String : Any]
                    let arr = dict["contest"] as? [[String:Any]] ?? []
                    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
              //      let selectedarr = self.selecteddata.compactMap {"\($0["contest_id"] as? Int ?? 0)"}
                    for dic in arr {
//                        if selectedarr.contains(String(dic["id"] as? Int ?? 0)) {
//                            self.createReminderbeforethirtysecond(strTitle: dic["name"] as? String ?? "No Name",strDate: dic["startDate"] as! String, identifier: (String(dic["id"] as? Int ?? 0)))
//                        }
                        self.createReminderbeforethirtysecond(strTitle: dic["name"] as? String ?? "No Name",strDate: dic["startDate"] as! String, identifier: (String(dic["id"] as? Int ?? 0)), info: dic)
                    }
                    
                  //  self.dismiss(animated: true, completion: nil)
                } else if status == 401 {
                    Define.APPDELEGATE.handleLogout()
                } else {
                    Alert().showAlert(title: "Error",
                                      message: result!["message"] as?  String ?? "No Message.",
                                      viewController: self)
                }
            }
        }
    }
    
    func createReminderbeforethirtysecond(strTitle: String, strDate: String,identifier:String,info:[String:Any]) {
        
       
      
            let center = UNUserNotificationCenter.current()

            let content = UNMutableNotificationContent()
               content.title = strTitle
               content.body = "Your game starts soon, Hurry!!!!"
             //  content.categoryIdentifier = "alarm"
            content.categoryIdentifier = "CategoryID\(identifier)" //Define.PLAYGAME
               content.userInfo = info
          //     content.sound = UNNotificationSound.default
            content.sound = UNNotificationSound.init(named:UNNotificationSoundName(rawValue: "message_tone_lg_no.mp3"))
            
               let reminderDate = MyModel().getDateForRemiderbeforethirtysecond(contestDate: strDate)
                let timeInterval = reminderDate.timeIntervalSinceNow
      
           guard timeInterval > 0 else {
               return
           }
        
               let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        

               let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
             //  center.add(request)
        
//        print("ContestDate:",strDate)
//        print("EasyJoin Notification Registered.")

        
        let curret = UNUserNotificationCenter.current()
        curret.add(request) { (error) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                print("ContestDate:",strDate)
                print("EasyJoin Notification Registered.")
            }
        }
            
        
    }
    
    
}

//MARK: - Collection View Cell Class
class advertiseCVC: UICollectionViewCell {
    
    @IBOutlet weak var imageAdvertise: UIImageView!
    
    override func awakeFromNib() {
        MyModel().setShadow(view: imageAdvertise)
       
    }
}
class SpecialContestTVC: UICollectionViewCell {
    
    @IBOutlet weak var ViewStar: UIView!
    
   
    @IBOutlet weak var vwnospecialcontest: UIView!
    @IBOutlet weak var viewSpecialContest: UIView!
    @IBOutlet weak var labelContestDate: UILabel!
    @IBOutlet weak var imageLevel: UIImageView!
    @IBOutlet weak var imageMode: UIImageView!
    @IBOutlet weak var labelContestName: UILabel!
    @IBOutlet weak var labelContestTime: UILabel!
    @IBOutlet weak var labelRemainingTime: UILabel!
    @IBOutlet weak var labelEntryCloseTime: UILabel!
    @IBOutlet weak var buttonPlayNow: UIButton!
    
    var seconds = Int()
    var timer:Timer?
    var currentDate = Date()
    
    var startDate: Date? {
        didSet {
            guard let date = startDate else {
                return
            }
            
            print("Date :\(date)")
            let calender = Calendar.current
            let unitFlags = Set<Calendar.Component>([ .second])
            let dateComponent = calender.dateComponents(unitFlags, from: Date(), to: date)
            seconds = dateComponent.second!
            print("Seconds: \(seconds)")
            
            if timer == nil {
                timer = Timer.scheduledTimer(timeInterval: 1,
                                             target: self,
                                             selector: #selector(handleTimer),
                                             userInfo: nil,
                                             repeats: true)
            }
        }
    }
    
    var closeSecond = Int()
    var closeTimer: Timer?
    var closeDate: Date? {
        didSet {
            guard let date = closeDate else {
                return
            }
            
            print("Date :\(date)")
            let calender = Calendar.current
            let unitFlags = Set<Calendar.Component>([ .second])
            let dateComponent = calender.dateComponents(unitFlags, from: Date(), to: date)
            closeSecond = dateComponent.second!
            print("Seconds: \(closeSecond)")
            
            if closeTimer == nil {
                closeTimer = Timer.scheduledTimer(timeInterval: 1,
                                             target: self,
                                             selector: #selector(handleCloseTimer),
                                             userInfo: nil,
                                             repeats: true)
                buttonPlayNow.isHidden = true
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        labelEntryCloseTime.textColor = UIColor.white
        
    }
  
    
    
    @objc func handleTimer() {
        if  seconds > 0{
            
            seconds -= 1
            
            labelRemainingTime.text = timeString(time: TimeInterval(seconds))
        } else {
            
            if timer != nil {
                
                timer!.invalidate()
                timer = nil
                
            }
            
            labelRemainingTime.text = "00:00:00"
        }
    }
    
    @objc func handleCloseTimer() {
        if closeSecond > 0 {
            
            if buttonPlayNow.isHidden {
                
                buttonPlayNow.isHidden = false
            }
            closeSecond = closeSecond - 1
            labelEntryCloseTime.text = timeString(time: TimeInterval(closeSecond))
            
        } else {
            if closeTimer != nil {
                
                closeTimer!.invalidate()
                closeTimer = nil
                
            }
            
            labelEntryCloseTime.text = "00:00:00"
            buttonPlayNow.isHidden = true
        }
    }
    
    func timeString(time: TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let secounds = Int(time) % 60
        
        let strTime = String(format: "%02i:%02i:%02i", hours, minutes, secounds)
        return strTime
    }
}

extension DashboardVC {
    func getAllSpecialContest() {
        print("IsVisible: \(self.isVisible)")
        if isShowLoading {
            Loading().showLoading(viewController: self)
        }
        let strURL = Define.APP_URL + Define.API_GETSPECIALCONTEST
        print("URL: \(strURL)")
        
        SwiftAPI().postMethodSecure(stringURL: strURL,
                                    parameters: nil,
                                    header: Define.USERDEFAULT.value(forKey: "AccessToken") as? String,
                                    auther: Define.USERDEFAULT.value(forKey: "UserID") as? String)
        { (result, error) in
            if error != nil {
                if self.isRefresh {
                    self.isRefresh = true
                   // self.refreshControl.endRefreshing()
                }
                
                self.isShowLoading = true
                Loading().hideLoading(viewController: self)
                
                
                print("Error: \(error!)")
//                if self.isVisible {
//                    self.retry()
//                } else {
//                    self.getAllContest()
//                }
                self.getAllSpecialContest()
            } else {
                if self.isRefresh {
                    self.isRefresh = true
                //    self.refreshControl.endRefreshing()
                }
                
                self.isShowLoading = true
                Loading().hideLoading(viewController: self)
                
                
                print("Special: \(result!)")
                let status = result!["statusCode"] as? Int ?? 0
                if status == 200 {
                    
                      
                    
//                    self.arrContest.removeAll()
                   let dictData = result!["content"] as! [String: Any]
                   self.arrSpecialContest = dictData["contest"] as? [[String : Any]] ?? []
                    if self.arrSpecialContest.count <= 0 {
                      //  self.veSpecialNoContest.isHidden = false
                        
                        self.isSpecialContest = false
                     //  self.setPageMenu()
                        DispatchQueue.main.async {
                            self.collectionSpecialcontest.reloadData()
                            self.HeightSpecial.constant = 0
                        }
                     
                                      }
                    else {
                                          //self.veSpecialNoContest.isHidden = true
                        
                        self.isSpecialContest = true
                        DispatchQueue.main.async {
                            self.collectionSpecialcontest.reloadData()
                            self.HeightSpecial.constant = 173
                        }
                    
                  //      self.setPageMenu()
                                      }
                   
//                    let serverDate = dictData["currentTime"] as? String ?? "\(MyModel().convertDateToString(date: Date(), returnFormate: "yyyy-MM-dd HH:mm:ss"))"
//                    self.currentData = MyModel().converStringToDate(strDate: serverDate, getFormate: "yyyy-MM-dd HH:mm:ss")
//                    if self.arrContest.count <= 0 {
//                        self.viewNoData.isHidden = false
//                    } else {
//                        self.viewNoData.isHidden = true
//                    }
//                    self.tablePlay.reloadData()
                    DispatchQueue.main.async {
                        self.collectionSpecialcontest.reloadData()
                    }
                    
                    

                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        
                        self.viewDidLayoutSubviews()
                    }
                   
                } else if status == 401 {
                    Define.APPDELEGATE.handleLogout()
                } else {
//                    self.arrContest.removeAll()
//                    self.viewNoData.isHidden = false
//                    self.tablePlay.reloadData()
                    if self.isVisible {
                        Alert().showAlert(title: "Alert",
                                          message: result!["message"] as? String  ?? Define.ERROR_SERVER,
                                          viewController: self)
                    } else {
                        self.getAllSpecialContest()
                    }
                }

            }
        }
    }
}
extension UIView {

    func updateConstraint(attribute: NSLayoutConstraint.Attribute, constant: CGFloat) -> Void {
        if let constraint = (self.constraints.filter{$0.firstAttribute == attribute}.first) {
            constraint.constant = constant
            self.layoutIfNeeded()
        }
    }
}

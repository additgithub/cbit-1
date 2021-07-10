import UIKit
import UserNotifications

class MyPackageVC: UIViewController {
    @IBOutlet weak var tableMyPackage: UITableView!
    @IBOutlet weak var viewNoData: UIView!
    
    var arrPackageList = [[String: Any]]()
    var isFirstTime = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableMyPackage.rowHeight = UITableView.automaticDimension
        tableMyPackage.tableFooterView = UIView()
       // UNUserNotificationCenter.current().delegate = self
        
        isFirstTime = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getMyPackageAPI()
    }
    
    func shareCode(strCode: String) {
        let strShareLink = "Join By Code"
        let strJoinCode = "Contest Code: \(strCode)"
        let arrShareItem = [strShareLink, strJoinCode]
        let activityViewController = UIActivityViewController(activityItems: arrShareItem,
                                                              applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        present(activityViewController, animated: true, completion: nil)
    }
}

//MARK: - TableView Delegate Method
extension MyPackageVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrPackageList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyPackageListCell") as! MyPackageListCell
        
//        cell.labelPercentage.text = "\(arrPackageList[indexPath.row]["commission"]!)% Commission on Winning Amount"
//        cell.labelPackagePrice.text = "₹\(arrPackageList[indexPath.row]["amount"] as? Double ?? 0.0)"
//        let strPurchaseData = MyModel().convertStringDateToString(strDate: arrPackageList[indexPath.row]["purchaseDate"] as! String,
//                                                                  getFormate: "yyyy-MM-dd HH:mm:ss",
//                                                                  returnFormat: "dd-MM-yyyy hh:mm a")
//        let expireDate = MyModel().converStringToDate(strDate: arrPackageList[indexPath.row]["expirationDate"] as! String,
//                                                      getFormate: "yyyy-MM-dd HH:mm:ss")
//        cell.expireDate = nil
//        cell.expireDate = expireDate
//
//        cell.labelPurachaseData.text = strPurchaseData
        
                let expireDate = MyModel().converStringToDate(strDate: arrPackageList[indexPath.row]["expirationDate"] as! String,
                                                              getFormate: "yyyy-MM-dd HH:mm:ss")
                cell.expireDate = nil
                cell.expireDate = expireDate
        
        //        cell.labelPurachaseData.text = strPurchaseData
        
               let strPurchaseData = MyModel().convertStringDateToString(strDate: arrPackageList[indexPath.row]["expirationDate"] as! String,
                                                                          getFormate: "yyyy-MM-dd HH:mm:ss",
                                                                          returnFormat: "dd-MM-yyyy hh:mm a")
       
        cell.labelexpity.text = strPurchaseData
         cell.labelPurachaseData.text = "₹\(arrPackageList[indexPath.row]["TicketPrice"] as? Double ?? 0.0) @ ₹\(arrPackageList[indexPath.row]["amount"] as? Double ?? 0.0),\(arrPackageList[indexPath.row]["validity"] as? Int ?? 0)days"
        
        cell.swtch.tag = indexPath.row
        cell.swtch.addTarget(self, action: #selector(self.switchChanged(_:)), for: .valueChanged)
        
        return cell
    }
    
    @objc func switchChanged(_ sender : UISwitch!){

          print("table row switch Changed \(sender.tag)")
          print("The switch is \(sender.isOn ? "ON" : "OFF")")
    }
}

//MARK: - Notifcation Delegate Method
//extension MyPackageVC: UNUserNotificationCenterDelegate {
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
//    }
//}

//MARK: - API
extension MyPackageVC {
    func getMyPackageAPI() {
        if isFirstTime {
            Loading().showLoading(viewController: self)
        }
        let strURL = Define.APP_URL + Define.API_MY_PACKAGE
        print("URL: \(strURL)")
        
        SwiftAPI().postMethodSecure(stringURL: strURL,
                                    parameters: nil,
                                    header: Define.USERDEFAULT.value(forKey: "AccessToken") as? String,
                                    auther: Define.USERDEFAULT.value(forKey: "UserID") as? String)
        { (result, error) in
            if error != nil {
                if self.isFirstTime {
                    self.isFirstTime = false
                    Loading().hideLoading(viewController: self)
                }
                print("Error: \(error!.localizedDescription)")
                //self.retry()
                self.getMyPackageAPI()
            } else {
                if self.isFirstTime {
                    self.isFirstTime = false
                    Loading().hideLoading(viewController: self)
                }
                print("Result: \(result!)")
                let status = result!["statusCode"] as? Int ?? 0
                if status == 200 {
                    self.arrPackageList = result!["content"] as! [[String: Any]]
                    if self.arrPackageList.count == 0 {
                        self.viewNoData.isHidden = false
                        self.tableMyPackage.reloadData()
                    } else {
                        self.viewNoData.isHidden = true
                        self.tableMyPackage.reloadData()
                    }
                }else  if status == 401 {
                    Define.APPDELEGATE.handleLogout()
                } else {
                    Alert().showAlert(title: "Error",
                                      message: result!["message"] as? String ?? Define.ERROR_SERVER,
                                      viewController: self)
                }
            }
        }
    }
}
//MARK: - Alert Contollert
extension MyPackageVC {
    func retry() {
        
        let alertController = UIAlertController(title: Define.ERROR_TITLE,
                                                message: Define.ERROR_SERVER,
                                                preferredStyle: .alert)
        let buttonRetry = UIAlertAction(title: "Retry",
                                        style: .default)
        { _ in
            self.getMyPackageAPI()
        }
        let cancel = UIAlertAction(title: "Cancel",
                                   style: .cancel,
                                   handler: nil)
        alertController.addAction(cancel)
        alertController.addAction(buttonRetry)
        self.present(alertController,
                     animated: true,
                     completion: nil)
    }
}

//MARK: - Cell Class
class MyPackageListCell: UITableViewCell {
    
   // @IBOutlet weak var labelPercentage: UILabel!
    @IBOutlet weak var labelexpity: UILabel!
    @IBOutlet weak var labelExpireTimer: UILabel!
    @IBOutlet weak var labelPurachaseData: UILabel!
    @IBOutlet var swtch: UISwitch!
    
    var expireTimer: Timer?
    var expireSecond = Int()
    
    var expireDate: Date? {
        didSet{
            guard let date = expireDate else {
                return
            }
            
            print("Date :\(date)")
            let calender = Calendar.current
            let unitFlags = Set<Calendar.Component>([ .second])
            let dateComponent = calender.dateComponents(unitFlags, from: Date(), to: date)
            expireSecond = dateComponent.second!
            print("Second: \(expireSecond)")
            if expireTimer == nil {
                expireTimer = Timer.scheduledTimer(timeInterval: 1,
                                                   target: self,
                                                   selector: #selector(self.handleTimer),
                                                   userInfo: nil,
                                                   repeats: true)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
       // MyModel().roundCorners(corners: [.topRight, .bottomRight], radius: 3, view: labelPercentage)
    }
    
    @objc func handleTimer() {
        if expireSecond > 0 {
            labelExpireTimer.text = MyModel().timeString(time: TimeInterval(expireSecond))
            expireSecond = expireSecond - 1
        } else {
            expireTimer!.invalidate()
            expireTimer = nil
            labelExpireTimer.text = "Expired"
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
    
}


import UIKit
import UserNotifications

class PackegaListVC: UIViewController {
    //MARK: - Properties.
    @IBOutlet weak var tablePackageList: UITableView!
    @IBOutlet weak var viewNoData: UIView!
    
    var arrPackageList = [[String: Any]]()
    
    private var isGetPackageList = Bool()
    private var isBuyPackage = Bool()
    //MARK: - Default Method
    override func viewDidLoad() {
        super.viewDidLoad()
        tablePackageList.rowHeight = UITableView.automaticDimension
        tablePackageList.tableFooterView = UIView()
        UNUserNotificationCenter.current().delegate = self
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getPackageList()
    }
    
    
    @IBAction func buttonMenu(_ sender: Any) {
        sideMenuController?.revealMenu()
        //self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonHowToPLay(_ sender: Any) {
        let gameInfo = GamePlayInfo.instanceFromNib() as! GamePlayInfo
        gameInfo.frame = view.bounds
        view.addSubview(gameInfo)
    }
}

//MARK: - TableView Delegate Method
extension PackegaListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrPackageList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PackageListCell") as! PackageListCell
        
        cell.labelPercentage.text = "\(arrPackageList[indexPath.row]["commission"]!)%  commission on winning amount"
        cell.labelPackagePrice.text = "₹\(arrPackageList[indexPath.row]["amount"]!)"
        cell.labelValidity.text = "\(arrPackageList[indexPath.row]["validity"]!) Days"
        
        cell.buttonBuy.addTarget(self,
                                 action: #selector(buttonBuy(_:)),
                                 for: .touchUpInside)
        cell.buttonBuy.tag = indexPath.row
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK: - Table Button Method
    @objc func buttonBuy(_ sender: UIButton) {
        let index = sender.tag
        print("=> \(arrPackageList[index])")
        let strID = "\(arrPackageList[index]["id"]!)"
        showConformationDialog(strPackageID: strID, index: index)
    }
}

//MARK: - Notifcation Delegate Method
extension PackegaListVC: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        switch response.actionIdentifier {
        case Define.PLAYGAME:
            print("Play Game")
            let dictData = response.notification.request.content.userInfo as! [String: Any]
            print(dictData)
            let gamePlayVC = self.storyboard?.instantiateViewController(withIdentifier: "GamePlayVC") as! GamePlayVC
            gamePlayVC.isFromNotification = true
            gamePlayVC.dictContest = dictData
            self.navigationController?.pushViewController(gamePlayVC, animated: true)
        default:
            break
        }
        
    }
}

//MARK: - API
extension PackegaListVC {
    func getPackageList() {
        Loading().showLoading(viewController: self)
        let strURL = Define.APP_URL + Define.API_GET_PACKAGE
        print("URL: \(strURL)")
        SwiftAPI().postMethodSecure(stringURL: strURL,
                                    parameters: nil,
                                    header: Define.USERDEFAULT.value(forKey: "AccessToken") as? String,
                                    auther: Define.USERDEFAULT.value(forKey: "UserID") as? String)
        { (result, error) in
            if error != nil {
                Loading().hideLoading(viewController: self)
                print("Error: \(error!.localizedDescription)")
                self.isBuyPackage = false
                self.isGetPackageList = true
                //self.retry(strId: nil)
                self.getPackageList()
            } else {
                Loading().hideLoading(viewController: self)
                print("Result: \(result!)")
                let status = result!["statusCode"] as? Int ?? 0
                if status == 200 {
                    self.arrPackageList = result!["content"] as! [[String: Any]]
                    if self.arrPackageList.count == 0 {
                        self.viewNoData.isHidden = false
                        self.tablePackageList.reloadData()
                    } else {
                        self.viewNoData.isHidden = true
                        self.tablePackageList.reloadData()
                    }
                    
                } else if status == 401 {
                    Define.APPDELEGATE.handleLogout()
                } else {
                    Alert().showAlert(title: "Alert",
                                      message: result!["message"] as? String  ?? Define.ERROR_SERVER,
                                      viewController: self)
                }
            }
        }
    }
    
    func buyPackage(strPackageID: String) {
        Loading().showLoading(viewController: self)
        let parameter: [String: Any] = ["packageId": strPackageID]
        let strURL = Define.APP_URL + Define.API_BUY_PACKAGE
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
                print("Error: \(error!.localizedDescription)")
                self.isBuyPackage = true
                self.isGetPackageList = false
                self.buyPackage(strPackageID: strPackageID)
            } else {
                Loading().hideLoading(viewController: self)
                print("Result: \(result!)")
                let status = result!["statusCode"] as? Int ?? 0
                if status == 200 {
                    
                    Alert().showTost(message: "Congratulations, Commission is now active under your account.", viewController: self)
                    let dictData = result!["content"] as! [String: Any]
                    
                    Define.USERDEFAULT.set(dictData["pbAmount"]!, forKey: "PBAmount")
                    Define.USERDEFAULT.set(dictData["sbAmount"]!, forKey: "SBAmount")
                    Define.USERDEFAULT.set(dictData["tbAmount"]!, forKey: "TBAmount")
                    
                    self.getPackageList()
                    
                } else if status == 401 {
                    Define.APPDELEGATE.handleLogout()
                } else {
                    Alert().showAlert(title: "Alert",
                                      message: result!["message"] as? String  ?? Define.ERROR_SERVER,
                                      viewController: self)
                }
            }
        }
    }
}

//MARK: - Alert Contollert
extension PackegaListVC {
    func retry(strId: String?) {
        let alertController = UIAlertController(title: Define.ERROR_TITLE,
                                                message: Define.ERROR_SERVER,
                                                preferredStyle: .alert)
        let buttonRetry = UIAlertAction(title: "Retry",
                                        style: .default)
        { _ in
            if self.isGetPackageList {
                self.getPackageList()
            } else if self.isBuyPackage {
                self.buyPackage(strPackageID: strId!)
            }
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
    
    func showConformationDialog(strPackageID: String, index: Int) {
        let alertContoller = UIAlertController(title: "Purchase Package",
                                               message: "Are you sure to want purchase this package?",
                                               preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel)
        let buyAction = UIAlertAction(title: "Buy",
                                      style: .default)
        { _ in
            self.checkBalance(strPackageID: strPackageID, index: index)
        }
        
        alertContoller.addAction(cancelAction)
        alertContoller.addAction(buyAction)
        
        self.present(alertContoller, animated: true, completion: nil)
    }
    
    func checkBalance(strPackageID: String, index: Int) {
        let amount = arrPackageList[index]["amount"] as? Double ?? 0.0
        if !MyModel().checkAmount(amount: amount) {
            let pbAmount = Define.USERDEFAULT.value(forKey: "PBAmount") as? Double ?? 0.0
            let sbAmount = Define.USERDEFAULT.value(forKey: "SBAmount") as? Double ?? 0.0
            
            let cutUtilized = amount - (pbAmount + sbAmount)
            
            let paymentVC = self.storyboard?.instantiateViewController(withIdentifier: "AddPaymentVC") as! AddPaymentVC
            paymentVC.isFromTicket = true
            paymentVC.addAmount = cutUtilized
            paymentVC.isFromLink = false
            self.navigationController?.pushViewController(paymentVC, animated: true)
        } else {
            buyPackage(strPackageID: strPackageID)
        }
    }
}


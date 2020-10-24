import UIKit
import UserNotifications






class PassBookVC: UIViewController {
    //MARK: - Properties
  
    
   
    
    @IBOutlet weak var tablePassBook: UITableView!
    @IBOutlet weak var labelbalance: LabelComman!
    @IBOutlet weak var labelWinning: LabelComman!
    @IBOutlet weak var viewNoData: UIView!
    
    private var arrPassbook = [[String: Any]]()
    
    lazy  var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.handleRefresh(_:)), for: .valueChanged)
        refreshControl.tintColor = Define.APPCOLOR
        return refreshControl
    }()
    
    private var isRefresh = Bool()
    private var isShowLoading = Bool()
    
    //MARK: - Default Method
    override func viewDidLoad() {
        super.viewDidLoad()
        tablePassBook.rowHeight = UITableView.automaticDimension
        tablePassBook.tableFooterView = UIView()
        tablePassBook.addSubview(refreshControl)
        
        UNUserNotificationCenter.current().delegate = self
        if !MyModel().isConnectedToInternet() {
            Alert().showTost(message: Define.ERROR_INTERNET,
                             viewController: self)
        } else {
            isShowLoading = true
            getPassbookData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setWalletDetail()
    }
    
    func setWalletDetail() {
        
        let pbAmount = "\(Define.USERDEFAULT.value(forKey: "PBAmount")!)"
        guard let amountPB = Double(pbAmount) else {
            return
        }
        labelbalance.text = MyModel().getCurrncy(value: amountPB)
        
        let sbAmount = "\(Define.USERDEFAULT.value(forKey: "SBAmount")!)"
        guard let amountSB = Double(sbAmount) else {
            return
        }
        labelWinning.text = MyModel().getCurrncy(value: amountSB)
    }
    
    @objc func handleRefresh(_ refresh: UIRefreshControl) {
        setWalletDetail()
        if !MyModel().isLogedIn() {
            Alert().showTost(message: Define.ERROR_INTERNET, viewController: self)
        } else {
            isRefresh = true
            isShowLoading = false
            refreshControl.beginRefreshing()
            self.getPassbookData()
        }
    }
    
    //MARK: - Button Method
    @IBAction func buttonBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
//MARK: - TableView Delegate
extension PassBookVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrPassbook.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
   
        let passBookCell = tableView.dequeueReusableCell(withIdentifier: "PassBookTVC") as! PassBookTVC
        
        passBookCell.labelTransactionName.text = arrPassbook[indexPath.row]["title"] as? String ?? "No Name"
        passBookCell.labelData.text = "\(arrPassbook[indexPath.row]["date"] as? String ?? "00-00-0000")"
        passBookCell.labelTime.text = "\(arrPassbook[indexPath.row]["time"] as? String ?? "00:00")"
        passBookCell.labelAmount.text = arrPassbook[indexPath.row]["amount"] as? String ?? "0"

        passBookCell.beforebalance.text =  arrPassbook[indexPath.row]["beforebalance"] as? String ?? "0"
        
        
        
        let strType = arrPassbook[indexPath.row]["type"] as? String ?? "subtract"
        if strType == "subtract" {
            passBookCell.imageTransaction.image = #imageLiteral(resourceName: "ic_recive")
            passBookCell.viewbefore.backgroundColor  = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        } else {
            passBookCell.imageTransaction.image = #imageLiteral(resourceName: "ic_send")
            passBookCell.viewbefore.backgroundColor  = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        }
        
        let strTDS = "\(arrPassbook[indexPath.row]["tds"]!)"
        if strTDS == "0" {
            passBookCell.labelTDS.isHidden = true
            passBookCell.labelTDS.text = nil
        } else {
            passBookCell.labelTDS.isHidden = false
            MyModel().setGradient(view: passBookCell.labelTDS, startColor: #colorLiteral(red: 1, green: 0.3215686275, blue: 0.3215686275, alpha: 1), endColor: #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1))
            
//            if let amountTDS = Double(strTDS)  {
//               passBookCell.labelTDS.text = "TDS " + MyModel().getCurrncy(value: amountTDS)
//            } else {
                passBookCell.labelTDS.text = "TDS " + strTDS
            //}
            
        }
        
        return passBookCell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}

//MARK: - API
extension PassBookVC {
    func getPassbookData() {
        if isShowLoading {
            Loading().showLoading(viewController: self)
        }
        let strURL = Define.APP_URL + Define.API_PASSBOOK
        
        print("URL: \(strURL)")
        
        SwiftAPI().postMethodSecure(stringURL: strURL,
                                    parameters: nil,
                                    header: Define.USERDEFAULT.value(forKey: "AccessToken") as? String,
                                    auther: Define.USERDEFAULT.value(forKey: "UserID") as? String)
        { (result, error) in
            if error != nil {
                if self.isRefresh {
                    self.isRefresh = false
                    self.refreshControl.endRefreshing()
                }
                
                Loading().hideLoading(viewController: self)
                print("Error: \(error!)")
                //self.retry()
                self.getPassbookData()
            } else {
                if self.isRefresh {
                    self.isRefresh = false
                    self.refreshControl.endRefreshing()
                }
                
                Loading().hideLoading(viewController: self)
                print("Result: \(result!)")
                let status = result!["statusCode"] as? Int ?? 0
                if status == 200 {
                    self.arrPassbook = result!["content"] as! [[String: Any]]
                    if self.arrPassbook.count == 0 {
                        self.viewNoData.isHidden = false
                    } else {
                        self.viewNoData.isHidden = true
                    }
                    self.tablePassBook.reloadData()
                    
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
}

//MARK: - Notifcation Delegate Method
extension PassBookVC: UNUserNotificationCenterDelegate {
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

//MARK: - Alert Contollert
extension PassBookVC {
    func retry() {
        let alertController = UIAlertController(title: Define.ERROR_TITLE,
                                                message: Define.ERROR_SERVER,
                                                preferredStyle: .alert)
        let buttonRetry = UIAlertAction(title: "Retry",
                                        style: .default)
        { _ in
            self.getPassbookData()
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

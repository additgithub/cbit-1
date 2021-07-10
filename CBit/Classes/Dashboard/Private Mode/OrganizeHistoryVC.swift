import UIKit
import UserNotifications

class OrganizeHistoryVC: UIViewController {
    @IBOutlet weak var tableHistory: UITableView!
    @IBOutlet weak var buttonAddContest: UIButton!
    @IBOutlet weak var viewNoData: UIView!
    
    var arrContest = [[String: Any]]()
    
    var isFirstTime = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableHistory.rowHeight = 120
        tableHistory.tableFooterView = UIView()
       // UNUserNotificationCenter.current().delegate = self
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleNotification),
                                               name: .hostContest,
                                               object: nil)
        isFirstTime = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getHostedContes()
    }
    
    override func viewWillLayoutSubviews() {
        MyModel().roundCorners(corners: [.allCorners], radius: 25, view: buttonAddContest)
    }
    
    @objc func handleNotification() {
        getHostedContes()
    }
    
    func shareCode(strCode: String) {
        let strShareLink = "\(Define.USERDEFAULT.value(forKey: "UserName") as? String ?? "") invited you to join the private room"
        let strJoinCode = "\(Define.SHARE_URL)\(strCode)"
        let arrShareItem = [strShareLink, strJoinCode]		
        let activityViewController = UIActivityViewController(activityItems: arrShareItem,
                                                              applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        present(activityViewController, animated: true, completion: nil)
    }
    
    //MARK: - Button Method
    @IBAction func buttonAddContest(_ sender: Any) {
        let createVC = self.storyboard?.instantiateViewController(withIdentifier: "CreateNC")
        createVC!.modalPresentationStyle = .fullScreen
        self.present(createVC!, animated: true, completion: nil)
    }
}

//MARK: - TableView Delegate Method
extension OrganizeHistoryVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrContest.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContestTVC") as! ContestTVC
        
        cell.labelContestName.text = arrContest[indexPath.row]["name"] as? String ?? "No Name"
        cell.labelContestTime.text = arrContest[indexPath.row]["startTime"] as? String ?? "00:00"
        cell.labelContestDate.text = arrContest[indexPath.row]["startDate"] as? String ?? "00-00-0000"
        
        cell.buttonShareCode.addTarget(self,
                                       action: #selector(buttonShare(_:)),
                                       for: .touchUpInside)
        cell.buttonShareCode.tag = indexPath.row
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        var dictData = arrContest[indexPath.row]
        let strID = "\(dictData["id"]!)"
        
        getPrivateContestDetail(strContestID: strID, dictContest: dictData)
        
    }
    
    //MARK: - Table Button Method
    @objc func buttonShare(_ sender: UIButton) {
        let index = sender.tag
        shareCode(strCode: arrContest[index]["contestCode"] as? String ?? "")
    }
}

//MARK: - Notifcation Delegate Method
//extension OrganizeHistoryVC: UNUserNotificationCenterDelegate {
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

//MARK: - API
extension OrganizeHistoryVC {
    func getHostedContes() {
        if isFirstTime {
            Loading().showLoading(viewController: self)
        }
        let strURL = Define.APP_URL + Define.API_GET_PRIVATE_CONTEST
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
//                Alert().showAlert(title: "Error",
//                                  message: Define.ERROR_SERVER,
//                                  viewController: self)
                self.getHostedContes()
            } else {
                if self.isFirstTime {
                    self.isFirstTime = false
                    Loading().hideLoading(viewController: self)
                }
                print("Result: \(result!)")
                let status = result!["statusCode"] as? Int ?? 0
                if status == 200 {
                    self.arrContest = result!["content"] as! [[String: Any]]
                    if self.arrContest.count == 0 {
                        self.viewNoData.isHidden = false
                    } else {
                        self.viewNoData.isHidden = true
                    }
                    self.tableHistory.reloadData()
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
    
    func getPrivateContestDetail(strContestID: String, dictContest: [String: Any]) {
        Loading().showLoading(viewController: self)
        let parameter:[String: Any] = ["contestId": strContestID]
        let strURL = Define.APP_URL + Define.API_GET_PRIVATE_CONTEST_DETAIL
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
                self.retry()
            } else {
                Loading().hideLoading(viewController: self)
                print("Result: \(result!)")
                let status = result!["statusCode"] as? Int ?? 0
                if status == 200 {
                    let dictData = result!["content"] as! [String: Any]
                    
                    let strGameStatus = dictData["gameStatus"] as? String ?? "end"
                    
                    if strGameStatus == "end" {
                        let resultVC = self.storyboard?.instantiateViewController(withIdentifier: "PrivateContestResultVC") as! PrivateContestResultVC
                        resultVC.dictContest = dictContest
                        resultVC.dictContestDetail = dictData
                        self.navigationController?.pushViewController(resultVC, animated: true)
                    } else {
                        let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "PrivateContestDetailVC") as! PrivateContestDetailVC
                        detailVC.dictContest = dictContest
                        detailVC.arrTickets = dictData["ticket"] as! [[String: Any]]
                        self.navigationController?.pushViewController(detailVC, animated: true)
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
}

//MARK: - Alert Contollert
extension OrganizeHistoryVC {
    func retry() {
        let alertController = UIAlertController(title: Define.ERROR_TITLE,
                                                message: Define.ERROR_SERVER,
                                                preferredStyle: .alert)
        let buttonRetry = UIAlertAction(title: "Retry",
                                        style: .default)
        { _ in
            self.getHostedContes()
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
class ContestTVC: UITableViewCell {
    @IBOutlet weak var labelContestName: UILabel!
    @IBOutlet weak var labelContestTime: UILabel!
    @IBOutlet weak var labelContestDate: UILabel!
    @IBOutlet weak var buttonShareCode: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
    }
}

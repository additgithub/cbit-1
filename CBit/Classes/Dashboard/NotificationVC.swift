import UIKit
import UserNotifications

class NotificationVC: UIViewController {
    //MARK: - Properties.
    @IBOutlet weak var tableNotification: UITableView!
    @IBOutlet weak var viewNoData: UIView!
    
    var arrNotification = [[String: Any]]()
    
    //MARK: - Default Value.
    override func viewDidLoad() {
        super.viewDidLoad()
        tableNotification.rowHeight = UITableView.automaticDimension
        tableNotification.tableFooterView = UIView()
       // UNUserNotificationCenter.current().delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getNotifidationAPI()
    }
    
    //MARK: - Button Method
    @IBAction func buttonBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func buttonSearch(_ sender: Any) {
        
    }
    
}

//MARK: - TableView Delegate Method
extension NotificationVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrNotification.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let notificationCell = tableView.dequeueReusableCell(withIdentifier: "NotificationTVC") as! NotificationTVC
        notificationCell.labelNotification.text = arrNotification[indexPath.row]["message"] as? String ?? "No Message"
        let notificationData = MyModel().convertStringDateToString(strDate: arrNotification[indexPath.row]["created_at"] as! String,getFormate: "yyyy-MM-dd hh:mm:ss a",returnFormat: "dd-MM-yyyy hh:mm:ss a")
        notificationCell.labelNotificaionData.text = notificationData
        return notificationCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}

//MARK: - Notifcation Delegate Method
//extension NotificationVC: UNUserNotificationCenterDelegate {
//    func userNotificationCenter(_ center: UNUserNotificationCenter,
//                                willPresent notification: UNNotification,
//                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        completionHandler([.alert, .sound])
//    }
//    func userNotificationCenter(_ center: UNUserNotificationCenter,
//                                didReceive response: UNNotificationResponse,
//                                withCompletionHandler completionHandler: @escaping () -> Void)
//    {
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
extension NotificationVC {
    func getNotifidationAPI() {
        Loading().showLoading(viewController: self)
        let strURL = Define.APP_URL + Define.API_NOTIFICATION
        print("URL: \(strURL)")
        
        SwiftAPI().postMethodSecure(stringURL: strURL,
                                    parameters: nil,
                                    header: Define.USERDEFAULT.value(forKey: "AccessToken") as? String,
                                    auther: Define.USERDEFAULT.value(forKey: "UserID") as? String)
        { (result, error) in
            if error != nil {
                Loading().hideLoading(viewController: self)
                print("Error: \(error!.localizedDescription)")
                //self.retry()
                self.getNotifidationAPI()
            } else {
                Loading().hideLoading(viewController: self)
                print("Result: \(result!)")
                let status = result!["statusCode"] as? Int ?? 0
                if status == 200 {
                    self.arrNotification = result!["content"] as! [[String: Any]]
                    if self.arrNotification.count == 0 {
                        self.viewNoData.isHidden = false
                    } else {
                        self.viewNoData.isHidden = true
                    }
                    self.tableNotification.reloadData()
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

//MARK: - Alert Contollert
extension NotificationVC {
    func retry() {
        let alertController = UIAlertController(title: Define.ERROR_TITLE,
                                                message: Define.ERROR_SERVER,
                                                preferredStyle: .alert)
        let buttonRetry = UIAlertAction(title: "Retry",
                                        style: .default)
        { _ in
            self.getNotifidationAPI()
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

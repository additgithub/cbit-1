import UIKit
import UserNotifications


class HistoryVC: UIViewController {

    @IBOutlet weak var tableHistory: UITableView!
    @IBOutlet weak var viewNoData: UIView!
    
    private var arrHistory = [[String: Any]]()
    
    private var isFirstTime = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableHistory.rowHeight = UITableView.automaticDimension
        isFirstTime = true
        UNUserNotificationCenter.current().delegate = self
        //Set Notification
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleNotification),
                                               name: .updateHistory,
                                               object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !MyModel().isConnectedToInternet() {
            Alert().showTost(message: Define.ERROR_INTERNET,
                             viewController: self)
        } else {
            getHistoryListAPI()
        }
    }
    
    @objc func handleNotification() {
        if !MyModel().isConnectedToInternet() {
            Alert().showTost(message: Define.ERROR_INTERNET,
                             viewController: self)
        } else {
            getHistoryListAPI()
        }
    }
    
    //MARK: -Button Method
    @IBAction func buttonBack(_ sender: Any) {
        
        sideMenuController?.revealMenu()
    }
}

//MARK: - TableView Delegate Method
extension HistoryVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTVC") as! HistoryTVC
        
        cell.labelContestName.text = arrHistory[indexPath.row]["name"] as? String ?? "No Name"
        cell.labelContestTime.text = arrHistory[indexPath.row]["contest_time"] as? String ?? "00:00"
        cell.labelContestDate.text = arrHistory[indexPath.row]["contest_date"] as? String ?? "00:00:00"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let gametype  = arrHistory[indexPath.row]["game_type"] as! String
        if gametype == "spinning-machine" {
            let SMResultVC = self.storyboard?.instantiateViewController(withIdentifier: "SMResultVC") as! SMResultVC
            SMResultVC.dictContest = arrHistory[indexPath.row]
            self.navigationController?.pushViewController(SMResultVC, animated: true)

        }
        else
        {
            let resultVC = self.storyboard?.instantiateViewController(withIdentifier: "GameResultVC") as! GameResultVC
            resultVC.dictContest = arrHistory[indexPath.row]
            self.navigationController?.pushViewController(resultVC, animated: true)
        }
        
    }
    
}

//MARK: - API
extension HistoryVC {
    func getHistoryListAPI()  {
        if isFirstTime {
            Loading().showLoading(viewController: self)
        }
        let strURL = Define.APP_URL + Define.API_CONTEST_HISTORY
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
                print("Error: \(error!)")
                self.getHistoryListAPI()
            } else {
                if self.isFirstTime {
                    self.isFirstTime = false
                    Loading().hideLoading(viewController: self)
                }
                print("Result: \(result!)")
                let status = result!["statusCode"] as? Int ?? 0
                if status == 200 {
                    self.arrHistory = result!["content"] as! [[String: Any]]
                    if self.arrHistory.count == 0 {
                        
                        self.viewNoData.isHidden = false
                        self.tableHistory.reloadData()
                        
                    } else {
                        
                        self.viewNoData.isHidden = true
                        self.tableHistory.reloadData()
                    }
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
extension HistoryVC: UNUserNotificationCenterDelegate {
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
extension HistoryVC {
    func retry() {
        let alertController = UIAlertController(title: Define.ERROR_TITLE,
                                                message: Define.ERROR_SERVER,
                                                preferredStyle: .alert)
        let buttonRetry = UIAlertAction(title: "Retry",
                                        style: .default)
        { _ in
            self.getHistoryListAPI()
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

//MARK: - TableView Cell Class
class HistoryTVC: UITableViewCell {
    
    @IBOutlet weak var labelContestName: UILabel!
    @IBOutlet weak var labelContestTime: UILabel!
    @IBOutlet weak var labelContestDate: UILabel!
    
    override func awakeFromNib() {
         super.awakeFromNib()
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
    }
}

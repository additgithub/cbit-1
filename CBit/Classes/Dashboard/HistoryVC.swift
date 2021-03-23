import UIKit
import UserNotifications


class HistoryVC: UIViewController {

    @IBOutlet weak var tableHistory: UITableView!
    @IBOutlet weak var viewNoData: UIView!
    @IBOutlet weak var segment: UISegmentedControl!
    
    private var arrHistory = [[String: Any]]()
    private var MainarrHistory = [[String: Any]]()
    
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
        
        if !MyModel().isConnectedToInternet() {
            Alert().showTost(message: Define.ERROR_INTERNET,
                             viewController: self)
        } else {
            getHistoryListAPI()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        if !MyModel().isConnectedToInternet() {
//            Alert().showTost(message: Define.ERROR_INTERNET,
//                             viewController: self)
//        } else {
//            getHistoryListAPI()
//        }
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
    
    @IBAction func segmentchanged(_ sender: UISegmentedControl) {
    
        
        if segment.selectedSegmentIndex == 0 {
                        self.arrHistory = self.MainarrHistory.filter{($0["game"] as! String) == "Anytime Game"}
                        tableHistory.reloadData()
          //  status = "0"
        }
        else if segment.selectedSegmentIndex == 1 {
                        self.arrHistory = self.MainarrHistory.filter{($0["game"] as! String) == "Basic"}
                        tableHistory.reloadData()
          //  status = "1"
        }
      
        
    }
}

//MARK: - TableView Delegate Method
extension HistoryVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTVC") as! HistoryTVC
        
        cell.labelContestName.text = "\(arrHistory[indexPath.row]["name"] as? String ?? "No Name")"
        
        
        cell.lblresultdate.text = "Result Date: \(arrHistory[indexPath.row]["game_date"] as? String ?? "00:00:00")"
        cell.lblresulttime.text = "Result Time: \(arrHistory[indexPath.row]["game_time"] as? String ?? "00:00")"
        
        cell.lblplaydate.text = "Play Date: \(arrHistory[indexPath.row]["contest_date"] as? String ?? "00:00:00")"
        cell.lblplaytime.text = "Play Time: \(arrHistory[indexPath.row]["contest_time"] as? String ?? "00:00")"
        
        let game  = arrHistory[indexPath.row]["game"] as! String
        if game == "Anytime Game"
        {
            cell.lblatggameno.text = "ATG Game No.: \(arrHistory[indexPath.row]["game_no"] as? Int ?? 0)"
            cell.lblatggameno.textColor = #colorLiteral(red: 0.1221796647, green: 0.3820681274, blue: 0.4405243397, alpha: 1)
        }
        else
        {
            cell.lblatggameno.text = "Live Game"
            cell.lblatggameno.textColor = UIColor.red
        }

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let game  = arrHistory[indexPath.row]["game"] as! String
        let gametype  = arrHistory[indexPath.row]["game_type"] as! String
        
        if game == "Anytime Game" {
            if gametype == "spinning-machine" {
                let AGSMResultVC = self.storyboard?.instantiateViewController(withIdentifier: "AGSMResultVC") as! AGSMResultVC
                AGSMResultVC.dictContest = arrHistory[indexPath.row]
                AGSMResultVC.isfromhistory = true
                self.navigationController?.pushViewController(AGSMResultVC, animated: true)

            }
            else
            {
                let CGGameResultVC = self.storyboard?.instantiateViewController(withIdentifier: "CGGameResultVC") as! CGGameResultVC
                CGGameResultVC.dictContest = arrHistory[indexPath.row]
                CGGameResultVC.isfromhistory = true
                self.navigationController?.pushViewController(CGGameResultVC, animated: true)
            }
        }
        else
        {
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
                    self.MainarrHistory = result!["content"] as! [[String: Any]]
                    if self.arrHistory.count == 0 {
                        
                        self.viewNoData.isHidden = false
                        self.tableHistory.reloadData()
                        
                    } else {
                       // self.arrHistory = self.MainarrHistory.filter{($0["game"] as! String) == "Anytime Game"}
                        self.arrHistory = self.MainarrHistory.filter{($0["game"] as! String) == "Basic"}
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
    @IBOutlet weak var lblatggameno: UILabel!
    @IBOutlet weak var lblresultdate: UILabel!
    @IBOutlet weak var lblplaydate: UILabel!
    @IBOutlet weak var lblresulttime: UILabel!
    @IBOutlet weak var lblplaytime: UILabel!
    
    
    
    override func awakeFromNib() {
         super.awakeFromNib()
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
    }
}

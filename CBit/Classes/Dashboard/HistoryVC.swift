import UIKit
import UserNotifications


class HistoryVC: UIViewController {

    @IBOutlet weak var tableHistory: UITableView!
    @IBOutlet weak var viewNoData: UIView!
    @IBOutlet weak var segment: UISegmentedControl!
    
    private var arrHistory = [[String: Any]]()
    private var MainarrHistory = [[String: Any]]()
    
    private var isFirstTime = Bool()
    private var isanytimeselected = 1
    private var isRefresh = Bool()
    lazy  var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.handleRefresh(_:)), for: .valueChanged)
        refreshControl.tintColor = Define.APPCOLOR
        return refreshControl
    }()
    
    var Start = 0
    var Limit = 10
    var ismoredata = false
    
    @objc func handleRefresh(_ refreshController: UIRefreshControl) {
        if !MyModel().isLogedIn() {
            Alert().showTost(message: Define.ERROR_INTERNET, viewController: self)
        } else {
            isRefresh = true
            refreshControl.beginRefreshing()
             Start = 0
            arrHistory = [[String:Any]]()
            tableHistory.reloadData()
            self.getHistoryListAPI(isanytime: isanytimeselected)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableHistory.rowHeight = UITableView.automaticDimension
        tableHistory.addSubview(refreshControl)
        isFirstTime = true
      //  UNUserNotificationCenter.current().delegate = self
        //Set Notification
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleNotification),
                                               name: .updateHistory,
                                               object: nil)
        
      
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UISegmentedControl.appearance().setTitleTextAttributes(titleTextAttributes, for: .selected)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        if !MyModel().isConnectedToInternet() {
//            Alert().showTost(message: Define.ERROR_INTERNET,
//                             viewController: self)
//        } else {
//            getHistoryListAPI()
//        }
        if !MyModel().isConnectedToInternet() {
            Alert().showTost(message: Define.ERROR_INTERNET,
                             viewController: self)
        } else {
            isRefresh = true
            refreshControl.beginRefreshing()
             Start = 0
            arrHistory = [[String:Any]]()
            tableHistory.reloadData()
            self.getHistoryListAPI(isanytime: isanytimeselected)
        }
    }
    
    @objc func handleNotification() {
        if !MyModel().isConnectedToInternet() {
            Alert().showTost(message: Define.ERROR_INTERNET,
                             viewController: self)
        } else {
            getHistoryListAPI(isanytime: isanytimeselected)
        }
    }
    
    //MARK: -Button Method
    @IBAction func buttonBack(_ sender: Any) {
      //  self.navigationController?.popViewController(animated: true)
        sideMenuController?.revealMenu()
       // self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func segmentchanged(_ sender: UISegmentedControl) {
    arrHistory = []
        Start = 0
        if segment.selectedSegmentIndex == 0 {
//                        self.arrHistory = self.MainarrHistory.filter{($0["game"] as! String) == "Anytime Game"}
//                        tableHistory.reloadData()
          //  status = "0"
            isanytimeselected = 1
            getHistoryListAPI(isanytime: isanytimeselected)
        }
        else if segment.selectedSegmentIndex == 1 {
//                        self.arrHistory = self.MainarrHistory.filter{($0["game"] as! String) == "Basic"}
//                        tableHistory.reloadData()
          //  status = "1"
            isanytimeselected = 0
            getHistoryListAPI(isanytime: isanytimeselected)

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
          //  cell.lblatggameno.textColor = #colorLiteral(red: 0.1221796647, green: 0.3820681274, blue: 0.4405243397, alpha: 1)
        }
        else
        {
            cell.lblatggameno.text = "Live Game"
          //  cell.lblatggameno.textColor = UIColor.red
        }
        
        let is_watch  = arrHistory[indexPath.row]["is_watch"] as! Int
        let gametime  = arrHistory[indexPath.row]["game_time"] as! String
        if gametime == "-"
        {
            cell.imgnew.isHidden = true
        }
        else
        {
            if (is_watch == 0) {
                cell.imgnew.isHidden = false
            }
            else
            {
                cell.imgnew.isHidden = true
            }
        }
        

        if arrHistory.count > 1 {
            let lastElement = arrHistory.count - 1
            if indexPath.row == lastElement && ismoredata{
                //call get api for next page
                getHistoryListAPI(isanytime: isanytimeselected)
            }

        }

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let game  = arrHistory[indexPath.row]["game"] as! String
        let gametype  = arrHistory[indexPath.row]["game_type"] as! String
        let is_watch  = arrHistory[indexPath.row]["is_watch"] as! Int
        let gametime  = arrHistory[indexPath.row]["game_time"] as! String
        if gametime == "-"
        {
        }
        else
        {
            if (is_watch == 0) {
                UpdateWatchAPI(dict: arrHistory[indexPath.row])
            }
        }

        if game == "Anytime Game" {
            let storyBoard : UIStoryboard = UIStoryboard(name: "ATG", bundle:nil)
           
            if gametype == "spinning-machine" {
                
                let NewAGSMResultVC = storyBoard.instantiateViewController(withIdentifier: "NewAGSMResultVC") as! NewAGSMResultVC
                NewAGSMResultVC.dictContest = arrHistory[indexPath.row]
                NewAGSMResultVC.isfromhistory = true
                self.navigationController?.pushViewController(NewAGSMResultVC, animated: true)

            }
            else
            {
                let NewCGGameResultVC = storyBoard.instantiateViewController(withIdentifier: "NewCGGameResultVC") as! NewCGGameResultVC
                NewCGGameResultVC.dictContest = arrHistory[indexPath.row]
                NewCGGameResultVC.isfromhistory = true
                self.navigationController?.pushViewController(NewCGGameResultVC, animated: true)
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
    func getHistoryListAPI(isanytime:Int)  {
        if isFirstTime {
            Loading().showLoading(viewController: self)
        }
        let strURL = Define.APP_URL + Define.API_CONTEST_HISTORY
        print("URL: \(strURL)")
        let parameter: [String: Any] = ["start": Start,"limit":Limit,"is_anytimegame":"\(isanytime)"]
        print("parameter: \(parameter)")

        SwiftAPI().postMethodSecure(stringURL: strURL,
                                    parameters: parameter,
                                    header: Define.USERDEFAULT.value(forKey: "AccessToken") as? String,
                                    auther: Define.USERDEFAULT.value(forKey: "UserID") as? String)
        { (result, error) in
            if error != nil {
                if self.isFirstTime {
                    self.isFirstTime = false
                    Loading().hideLoading(viewController: self)
                }
                if self.isRefresh {
                    self.isRefresh = true
                    self.refreshControl.endRefreshing()
                }
                print("Error: \(error!)")
                self.getHistoryListAPI(isanytime: isanytime)
            } else {
                if self.isRefresh {
                    self.isRefresh = true
                    self.refreshControl.endRefreshing()
                }
                
                if self.isFirstTime {
                    self.isFirstTime = false
                    Loading().hideLoading(viewController: self)
                }
                print("Result: \(result!)")
                let status = result!["statusCode"] as? Int ?? 0
                if status == 200 {
                   // self.arrHistory = result!["content"] as! [[String: Any]]
                    self.MainarrHistory = result!["content"] as! [[String: Any]]
                    let arr =  result!["content"] as! [[String : Any]]
                    
                    if arr.count > 0 {
                        self.arrHistory.append(contentsOf: arr)
                        self.ismoredata = true
                        self.Start = self.Start + 10
                        self.Limit =  10
                    }
                    else
                    {
                        self.ismoredata = false
                    }
                    if self.arrHistory.count == 0 {
                        
                        self.viewNoData.isHidden = false
                        self.tableHistory.reloadData()
                        
                    } else {
                       // self.arrHistory = self.MainarrHistory.filter{($0["game"] as! String) == "Anytime Game"}
                     //   self.arrHistory = self.MainarrHistory.filter{($0["game"] as! String) == "Basic"}
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
    
    func UpdateWatchAPI(dict:[String:Any])  {
        let strURL = Define.APP_URL + Define.updateIsWatch
        print("URL: \(strURL)")
        let parameter: [String: Any] = ["contest_id":dict["id"]!,
                                        "game_no":dict["game_no"]!,
                                        "contestPriceId":dict["contestPriceID"]!,
                                        "is_watch":"1"]
        
        SwiftAPI().postMethodSecure(stringURL: strURL,
                                    parameters: parameter,
                                    header: Define.USERDEFAULT.value(forKey: "AccessToken") as? String,
                                    auther: Define.USERDEFAULT.value(forKey: "UserID") as? String)
        { (result, error) in
            if error != nil {
           
                
                if self.isRefresh {
                    self.isRefresh = true
                    self.refreshControl.endRefreshing()
                }
                print("Error: \(error!)")
            } else {
                if self.isRefresh {
                    self.isRefresh = true
                    self.refreshControl.endRefreshing()
                }
                
            
                print("Result: \(result!)")
                let status = result!["statusCode"] as? Int ?? 0
                if status == 200 {
                   // self.arrHistory = result!["content"] as! [[String: Any]]
                    self.MainarrHistory = result!["content"] as! [[String: Any]]
                    let arr =  result!["content"] as! [[String : Any]]
                    
                    
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
//extension HistoryVC: UNUserNotificationCenterDelegate {
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

//MARK: - Alert Contollert
extension HistoryVC {
    func retry() {
        let alertController = UIAlertController(title: Define.ERROR_TITLE,
                                                message: Define.ERROR_SERVER,
                                                preferredStyle: .alert)
        let buttonRetry = UIAlertAction(title: "Retry",
                                        style: .default)
        { _ in
            self.getHistoryListAPI(isanytime: self.isanytimeselected)
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
    @IBOutlet weak var imgnew: UIImageView!
    
    
    
    override func awakeFromNib() {
         super.awakeFromNib()
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
    }
}

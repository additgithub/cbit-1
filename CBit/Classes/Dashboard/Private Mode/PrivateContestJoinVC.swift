import UIKit
import UserNotifications

class PrivateContestJoinVC: UIViewController {
    @IBOutlet weak var tablePlay: UITableView!
    @IBOutlet weak var viewNoData: UIView!
    
    var arrContest = [[String: Any]]()
    
    var dictParameter = [String: String]()
    var isFromLink = Bool()
    var isFromJoinCode = Bool()
    var currentDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tablePlay.rowHeight = UITableView.automaticDimension
        tablePlay.tableFooterView = UIView()
        //tablePlay.addSubview(refreshControl)
      //  UNUserNotificationCenter.current().delegate = self
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleNotification),
                                               name: .updatePrivateContest,
                                               object: nil)
        if self.arrContest.count == 0 {
            self.viewNoData.isHidden = false
        } else {
            self.viewNoData.isHidden = true
        }
        
        if !isFromJoinCode {
            dictParameter = Define.USERDEFAULT.value(forKey: "LinkParameter") as! [String: String]
            isFromLink = true
            getContestByCode()
        }
    }
    
    @objc func handleNotification() {
        
    }
    
    @IBAction func buttonBack(_ sender: Any) {
        if !isFromJoinCode {
            let storyBoard = UIStoryboard(name: "Dashboard", bundle: nil)
            let menuVC = storyBoard.instantiateViewController(withIdentifier: "MenuNC")
            menuVC.modalPresentationStyle = .fullScreen
            self.present(menuVC,
                         animated: true,
                         completion:
                {
            })
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
}

//MARK: - TableView Delegate Method
extension PrivateContestJoinVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrContest.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UpcominContestTVC") as! UpcominContestTVC
        
        //Set Data
        cell.labelContestName.text = arrContest[indexPath.row]["name"] as? String ?? "No Name"
        
        cell.currentDate = currentDate 
        //let currentDate = MyModel().convertDateToString(date: Date(),
        //                                                returnFormate: "yyyy-MM-dd HH:mm:ss")
        let startDate = arrContest[indexPath.row]["startDate"] as! String
        cell.startDate = nil
        //cell.timer = nil
        cell.startDate = MyModel().converStringToDate(strDate: startDate, getFormate: "yyyy-MM-dd HH:mm:ss")
        
        let closeTime = arrContest[indexPath.row]["closeDate"] as! String
        cell.closeDate = nil
        //cell.closeTimer = nil
        cell.closeDate = MyModel().converStringToDate(strDate: closeTime, getFormate: "yyyy-MM-dd HH:mm:ss")
        
        cell.labelContestDate.text = "Date: " + MyModel().convertStringDateToString(strDate: startDate,
                                                                         getFormate: "yyyy-MM-dd HH:mm:ss",
                                                                         returnFormat: "dd-MM-yyyy")
        cell.labelContestTime.text = MyModel().convertStringDateToString(strDate: startDate,
                                                                         getFormate: "yyyy-MM-dd HH:mm:ss",
                                                                         returnFormat: "hh:mm a")
        
        let gameLevel = arrContest[indexPath.row]["level"] as? Int ?? 1
        
        if gameLevel == 1 {
            //Easy
            cell.imageLevel.image = #imageLiteral(resourceName: "ic_e")
        } else if gameLevel == 2 {
            //Modred
            cell.imageLevel.image = #imageLiteral(resourceName: "ic_m")
        } else if gameLevel == 3 {
            //Pro
            cell.imageLevel.image = #imageLiteral(resourceName: "ic_p")
        }
        
        let gameMode = arrContest[indexPath.row]["type"] as? Int ?? 0
        
        if gameMode == 0 {
            //Flexi Bar
            cell.imageMode.image = #imageLiteral(resourceName: "ic_flexi_new")
        } else if gameMode == 1 {
            //Fix Bar
            cell.imageMode.image = #imageLiteral(resourceName: "ic_fix_new")
        }
        
        //Set Button
        cell.buttonPlayNow.addTarget(self, action: #selector(buttonPlayNow(_:)), for: .touchUpInside)
        cell.buttonPlayNow.tag = indexPath.row
        
        DispatchQueue.main.async {
            MyModel().roundCorners(corners: [.bottomLeft, .bottomRight], radius: 5, view: cell.buttonPlayNow)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let ticketVC = self.storyboard?.instantiateViewController(withIdentifier: "TicketVC") as! TicketVC
        ticketVC.dictContest = arrContest[indexPath.row]
        ticketVC.isFromLink = isFromLink
        self.navigationController?.pushViewController(ticketVC, animated: true)
    }
    
    //MARK: - Tableview Button Mathod
    @objc func buttonPlayNow(_ sender: UIButton) {
        let index = sender.tag
        let ticketVC = self.storyboard?.instantiateViewController(withIdentifier: "TicketVC") as! TicketVC
        ticketVC.dictContest = arrContest[index]
        ticketVC.isFromMyTickets = false
        ticketVC.isFromLink = isFromLink
        self.navigationController?.pushViewController(ticketVC, animated: true)
        
    }
}


//MARK: - Notifcation Delegate Method
//extension PrivateContestJoinVC: UNUserNotificationCenterDelegate {
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
extension PrivateContestJoinVC {
    func getContestByCode() {
        Loading().showLoading(viewController: self)
        let parameter:[String: Any] = ["contestCode": dictParameter["code"]!]
        let strURL = Define.APP_URL + Define.API_JOIN_BY_CODE
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
                Alert().showAlert(title: "Error",
                                  message: result!["message"] as? String ?? Define.ERROR_SERVER,
                                  viewController: self)
            } else {
                Loading().hideLoading(viewController: self)
                print("Result: \(result!)")
                let status = result!["statusCode"] as? Int ?? 0
                if status == 200 {
                    let dictData = result!["content"] as! [String: Any]
                    let arrTickets = dictData["contest"] as! [[String: Any]]
                    let serverDate = dictData["currentTime"] as? String ?? "\(MyModel().convertDateToString(date: Date(), returnFormate: "yyyy-MM-dd HH:mm:ss"))"
                    self.currentDate = MyModel().converStringToDate(strDate: serverDate, getFormate: "yyyy-MM-dd HH:mm:ss")
                    self.arrContest = arrTickets
                    if self.arrContest.count == 0 {
                        self.viewNoData.isHidden = false
                    } else {
                        self.viewNoData.isHidden = true
                    }
                    self.tablePlay.reloadData()
                } else  if status == 401 {
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

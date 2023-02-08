import UIKit
import UserNotifications

class MyContestVC: UIViewController {
    //MARK: - Properties.
    @IBOutlet weak var tableContent: UITableView!
    @IBOutlet weak var viewNoData: UIView!
    @IBOutlet weak var viewMyContest: UIView!
    
    private var arrMyContest = [[String: Any]]()
    
    
    lazy  var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.handleRefresh(_:)), for: .valueChanged)
        refreshControl.tintColor = Define.APPCOLOR
        return refreshControl
    }()
    
    private var isRefresh = Bool()
    private var isShowLoading = Bool()
    private var isVisible = Bool()
    private var currentData = Date()
    
    //MARK: - Default Method
    override func viewDidLoad() {
        super.viewDidLoad()
        tableContent.rowHeight = UITableView.automaticDimension
        tableContent.tableFooterView = UIView()
        tableContent.addSubview(refreshControl)
        
        if !MyModel().isConnectedToInternet() {
            Alert().showTost(message: Define.ERROR_INTERNET,
                             viewController: self)
        } else {
            isShowLoading = true
            getMyContestAPI()
        }
        
        //Set Notification
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleNotitication(_:)),
                                               name: .myContest,
                                               object: nil)
      //  UNUserNotificationCenter.current().delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isVisible = true
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isVisible = false
    }
    
    
    @objc func handleNotitication(_ notification: Notification) {
        isShowLoading = false
        getMyContestAPI()
    }
    @objc func handleRefresh(_ refreshController: UIRefreshControl) {
        isRefresh = true
        isShowLoading = false
        refreshControl.beginRefreshing()
        self.getMyContestAPI()
    }
}

//MARK: - TableView Delegate Method
extension MyContestVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrMyContest.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyContestTVC") as! MyContestTVC
        
        let game_type = arrMyContest[indexPath.row]["game_type"] as! String
        if game_type == "spinning-machine" {
            cell.imageLevel.image = #imageLiteral(resourceName: "slot_machine")
        }
        else if game_type == "0-9"
        {
            cell.imageLevel.image = #imageLiteral(resourceName: "Numberslot")
        }
        else
        {
            cell.imageLevel.image = #imageLiteral(resourceName: "classic_grid")
        }
        
        //Set Data
        cell.labelContestName.text = arrMyContest[indexPath.row]["name"] as? String ?? "No Name"
        
        cell.currentDate = currentData
        //let currentDate = MyModel().convertDateToString(date: Date(),
        //                                                returnFormate: "yyyy-MM-dd HH:mm:ss")
        let startDate = arrMyContest[indexPath.row]["startDate"] as! String
        cell.startDate = nil
        //cell.timer = nil
        cell.startDate = MyModel().converStringToDate(strDate: startDate, getFormate: "yyyy-MM-dd HH:mm:ss")
        
        let closeTime = arrMyContest[indexPath.row]["closeDate"] as! String
        cell.closeDate = nil
        //cell.closeTimer = nil
        cell.closeDate = MyModel().converStringToDate(strDate: closeTime, getFormate: "yyyy-MM-dd HH:mm:ss")
        
        cell.labelContestDate.text = "Date: " + MyModel().convertStringDateToString(strDate: startDate,
                                                                         getFormate: "yyyy-MM-dd HH:mm:ss",
                                                                         returnFormat: "dd-MM-yyyy")
        cell.labelContestTime.text = MyModel().convertStringDateToString(strDate: startDate,
                                                                         getFormate: "yyyy-MM-dd HH:mm:ss",
                                                                         returnFormat: "hh:mm a")
        
        //let closeDate = arrMyContest[indexPath.row]["closeDate"] as? String ?? currentDate
//        cell.labelClosingTime.text = MyModel().convertStringDateToString(strDate: closeDate,
//                                                                            getFormate: "yyyy-MM-dd HH:mm:ss",
//                                                                            returnFormat: "HH:mm:ss")
        
//        let gameLevel = arrMyContest[indexPath.row]["level"] as? Int ?? 1
//
//        if gameLevel == 1 {
//            //Easy
//            cell.imageLevel.image = #imageLiteral(resourceName: "ic_e")
//        } else if gameLevel == 2 {
//            //Modred
//            cell.imageLevel.image = #imageLiteral(resourceName: "ic_m")
//        } else if gameLevel == 3 {
//            //Pro
//            cell.imageLevel.image = #imageLiteral(resourceName: "ic_p")
//        }
        
        let gameMode = arrMyContest[indexPath.row]["type"] as? Int ?? 0
        
        if gameMode == 0 {
            //Flexi Bar
            cell.imageGameMode.image = #imageLiteral(resourceName: "ic_flexi_new")
        } else if gameMode == 1 {
            //Fix Bar
            cell.imageGameMode.image = #imageLiteral(resourceName: "ic_fix_new")
        }
        
        //Set Button
        cell.buttonPlayNow.addTarget(self, action: #selector(buttonPlayNow(_:)), for: .touchUpInside)
        cell.buttonPlayNow.tag = indexPath.row
        
        cell.buttonMyTicket.addTarget(self,
                                      action: #selector(buttonMyTickets(_:)),
                                      for: .touchUpInside)
        cell.buttonMyTicket.tag = indexPath.row
        
        cell.buttonMyTicketsClone.addTarget(self,
                                      action: #selector(buttonMyTickets(_:)),
                                      for: .touchUpInside)
        cell.buttonMyTicketsClone.tag = indexPath.row
        
        DispatchQueue.main.async {
            MyModel().roundCorners(corners: [.bottomLeft], radius: 5, view: cell.buttonMyTicket)
            MyModel().roundCorners(corners: [.bottomRight], radius: 5, view: cell.buttonPlayNow)
            MyModel().roundCorners(corners: [.bottomLeft, .bottomRight], radius: 5, view: cell.buttonMyTicketsClone)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let game_type = arrMyContest[indexPath.row]["game_type"] as! String
        if game_type == "spinning-machine" {
            let SMMyTicketVC = self.storyboard?.instantiateViewController(withIdentifier: "SMMyTicketVC") as! SMMyTicketVC
            SMMyTicketVC.dictContest = arrMyContest[indexPath.row]
            self.navigationController?.pushViewController(SMMyTicketVC, animated: true)
        }
        else
        {
            let myTicketVC = self.storyboard?.instantiateViewController(withIdentifier: "MyTicketVC") as! MyTicketVC
            myTicketVC.dictContest = arrMyContest[indexPath.row]
            self.navigationController?.pushViewController(myTicketVC, animated: true)
        }
    
      
    }
    
    //MARK: - TableView Button Method
    @objc func buttonPlayNow(_ sender: UIButton) {
        let index = sender.tag
        
        //getContestDetail(dictContest: arrMyContest[index])
//        let gamePlayVC = self.storyboard?.instantiateViewController(withIdentifier: "GamePlayVC") as! GamePlayVC
//        gamePlayVC.dictContest = arrMyContest[index]
//        gamePlayVC.isFromNotification = false
//        //gamePlayVC.dictGameData = dictGameData
//        self.navigationController?.pushViewController(gamePlayVC, animated: true)
        
        
        let game_type = arrMyContest[index]["game_type"] as! String
        if game_type == "spinning-machine" {
            let SpinningMachinePlayVC = self.storyboard?.instantiateViewController(withIdentifier: "SpinningMachinePlayVC") as! SpinningMachinePlayVC
            SpinningMachinePlayVC.dictContest = arrMyContest[index]
         //   SpinningMachinePlayVC.storeimage = storeimage
            self.navigationController?.pushViewController(SpinningMachinePlayVC, animated: true)
        }
        else
        {
                    let gamePlayVC = self.storyboard?.instantiateViewController(withIdentifier: "GamePlayVC") as! GamePlayVC
                    gamePlayVC.dictContest = arrMyContest[index]
                    gamePlayVC.isFromNotification = false
                    self.navigationController?.pushViewController(gamePlayVC, animated: true)
        }
    }
    
    func getContestDetail(dictContest: [String: Any]) {
        Loading().showLoading(viewController: self)
        let parameter:[String: Any] = [ "contestId": dictContest["id"]!, "userId":Define.USERDEFAULT.value(forKey: "UserID")!]
        print("Parameter: \(parameter)")
        
        let jsonString = MyModel().getJSONString(object: parameter)
        let encriptString = MyModel().encrypting(strData: jsonString!, strKey: Define.KEY)
        let strBase64 = encriptString.toBase64()
        
        SocketIOManager.sharedInstance.socket.emitWithAck("contestDetails", strBase64!).timingOut(after: 0) {data in
            print("Game Data: \(data)")
            Loading().hideLoading(viewController: self)
            
            guard let strValue = data[0] as? String else {
                Alert().showAlert(title: "Alert",
                                  message: Define.ERROR_SERVER,
                                  viewController: self)
                return
            }
            
            let strJSON = MyModel().decrypting(strData: strValue, strKey: Define.KEY)
            let dictData = MyModel().convertToDictionary(text: strJSON)
            
            let dictGameData = dictData!["content"] as! [String: Any]
            
            let gamePlayVC = self.storyboard?.instantiateViewController(withIdentifier: "GamePlayVC") as! GamePlayVC
            gamePlayVC.dictContest = dictContest
            gamePlayVC.isFromNotification = false
            gamePlayVC.dictGameData = dictGameData
            self.navigationController?.pushViewController(gamePlayVC, animated: true)
        }
    }
    
    @objc func buttonMyTickets(_ sender: UIButton) {
        let index = sender.tag
        
        let game_type = arrMyContest[index]["game_type"] as! String
        if game_type == "spinning-machine" {
            let SMMyTicketVC = self.storyboard?.instantiateViewController(withIdentifier: "SMMyTicketVC") as! SMMyTicketVC
            SMMyTicketVC.dictContest = arrMyContest[index]
            self.navigationController?.pushViewController(SMMyTicketVC, animated: true)
        }
        else
        {
            let myTicketVC = self.storyboard?.instantiateViewController(withIdentifier: "MyTicketVC") as! MyTicketVC
            myTicketVC.dictContest = arrMyContest[index]
            self.navigationController?.pushViewController(myTicketVC, animated: true)
        }
     
    }
}

//MARK: - API
extension MyContestVC {
    func getMyContestAPI() {
        print("IsVisible: \(self.isVisible)")
        if isShowLoading {
            Loading().showLoading(viewController: self)
        }
        let strURL = Define.APP_URL + Define.API_MY_CONTEST
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
                
                self.isShowLoading = false
                Loading().hideLoading(viewController: self)
                
                print("Error: \(error!)")
//                if self.isVisible {
//                    self.retry()
//                } else {
//                    self.getMyContestAPI()
//                }
                self.getMyContestAPI()
                
            } else {
                if self.isRefresh {
                    self.isRefresh = false
                    self.refreshControl.endRefreshing()
                }
                
                self.isShowLoading = false
                Loading().hideLoading(viewController: self)
                
                print("Result: \(result!)")
                let status = result!["statusCode"] as? Int ?? 0
                if status == 200 {
                    
                    let dictData = result!["content"] as! [String: Any]
                    self.arrMyContest = dictData["contest"] as! [[String: Any]]
                    
                    let serverDate = dictData["currentTime"] as? String ?? "\(MyModel().convertDateToString(date: Date(), returnFormate: "yyyy-MM-dd HH:mm:ss"))"
                    self.currentData = MyModel().converStringToDate(strDate: serverDate, getFormate: "yyyy-MM-dd HH:mm:ss")
                    
                    if self.arrMyContest.count <= 0 {
                        self.viewNoData.isHidden = false
                    } else {
                        self.viewNoData.isHidden = true
                    }
                    
                    self.tableContent.reloadData()
                    
                } else if status == 401 {
                    Define.APPDELEGATE.handleLogout()
                } else {
                    self.arrMyContest.removeAll()
                    self.viewNoData.isHidden = false
                    self.tableContent.reloadData()
                    if self.isVisible {
                        Alert().showAlert(title: "Alert",
                                          message: result!["message"] as? String ?? Define.ERROR_SERVER,
                                          viewController: self)
                    } else {
                        self.getMyContestAPI()
                    }
                }
            }
        }
    }
}
//MARK: - Notifcation Delegate Method
//extension MyContestVC: UNUserNotificationCenterDelegate {
//    func userNotificationCenter(_ center: UNUserNotificationCenter,
//                                willPresent notification: UNNotification,
//                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        completionHandler([.alert, .sound])
//    }
//    func userNotificationCenter(_ center: UNUserNotificationCenter,
//                                didReceive response: UNNotificationResponse,
//                                withCompletionHandler completionHandler: @escaping () -> Void) {
//        switch response.actionIdentifier{
//      //  switch response.notification.request.content.categoryIdentifier{
//      //  if response.notification.request.identifier == "textNotification"
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
extension MyContestVC {
    func retry() {
        let alertController = UIAlertController(title: Define.ERROR_TITLE,
                                                message: Define.ERROR_SERVER,
                                                preferredStyle: .alert)
        let buttonRetry = UIAlertAction(title: "Retry",
                                        style: .default)
        { _ in
            self.isShowLoading = true
            self.getMyContestAPI()
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
class MyContestTVC: UITableViewCell {
    
    @IBOutlet weak var buttonPlayNow: UIButton!
    @IBOutlet weak var imageLevel: UIImageView!
    @IBOutlet weak var imageGameMode: UIImageView!
    @IBOutlet weak var labelContestName: UILabel!
    @IBOutlet weak var labelContestTime: UILabel!
    @IBOutlet weak var labelRemainingTime: UILabel!
    @IBOutlet weak var labelClosingTime: UILabel!
    @IBOutlet weak var buttonMyTicket: UIButton!
    @IBOutlet weak var labelContestDate: UILabel!
    @IBOutlet weak var buttonMyTicketsClone: UIButton!
    
    var seconds = Int()
    var timer:Timer?
    var currentDate = Date()
    
    var startDate: Date? {
        didSet {
            guard let sDate = startDate else {
                return
            }
            print("Start Date :\(sDate)")
            let calender = Calendar.current
            let unitFlags = Set<Calendar.Component>([ .second])
            let dateComponent = calender.dateComponents(unitFlags, from: Date(), to: sDate)
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
            
            print(" Close Date :\(date)")
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
                self.buttonPlayNow.isHidden = true
                self.buttonMyTicket.isHidden = true
                self.buttonMyTicketsClone.isHidden = true
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        labelClosingTime.textColor = #colorLiteral(red: 0.9921568627, green: 0.7764705882, blue: 0.09803921569, alpha: 1)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: true)
        
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
            closeSecond = closeSecond - 1
            labelClosingTime.text = timeString(time: TimeInterval(closeSecond))
            
            if self.buttonMyTicketsClone.isHidden {
                self.buttonMyTicketsClone.isHidden = false
            }
        } else {
            if closeTimer != nil {
                closeTimer!.invalidate()
                closeTimer = nil
            }
            labelClosingTime.text = "00:00:00"
            
            buttonPlayNow.isHidden = false
            self.buttonMyTicket.isHidden = false
            self.buttonMyTicketsClone.isHidden = true
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

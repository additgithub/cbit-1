import UIKit
import UserNotifications
import SDWebImage

class PlayVC: UIViewController {
    //MARK: - Properties
    @IBOutlet weak var tablePlay: UITableView!
    @IBOutlet weak var viewNoData: UIView!
    @IBOutlet weak var viewContest: UIView!
    
    private var arrContest = [[String: Any]]()
    
    private var isVisible = Bool()
    lazy  var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.handleRefresh(_:)), for: .valueChanged)
        refreshControl.tintColor = Define.APPCOLOR
        return refreshControl
    }()
    
    private var isRefresh = Bool()
    private var isShowLoading = Bool()
    private var currentData = Date()
    
    var Start = 0
    var Limit = 30
    var ismoredata = false
    
   // var storeimage = [[String: Any]]()
    
    //MARK: - Default Method
    override func viewDidLoad() {
        super.viewDidLoad()
        tablePlay.rowHeight = UITableView.automaticDimension
        tablePlay.tableFooterView = UIView()
        tablePlay.addSubview(refreshControl)
        
        UNUserNotificationCenter.current().delegate = self
        //Add Notification
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleNotitication(_:)),
                                               name: .upComingContest,
                                               object: nil)
        if !MyModel().isLogedIn() {
            Alert().showTost(message: Define.ERROR_INTERNET, viewController: self)
        } else {
            isShowLoading = true
            getAllContest()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isVisible = true
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isVisible = false
    }
    
    @objc func handleRefresh(_ refreshController: UIRefreshControl) {
        if !MyModel().isLogedIn() {
            Alert().showTost(message: Define.ERROR_INTERNET, viewController: self)
        } else {
            isRefresh = true
            isShowLoading = false
            refreshControl.beginRefreshing()
            self.getAllContest()
        }
    }
    
    @objc func handleNotitication(_ notification: Notification) {
        isShowLoading = false
         Start = 0
         Limit = 30
        arrContest = [[String:Any]]()
        self.getAllContest()
    }
}

//MARK: - TableView Delegate Method
extension PlayVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrContest.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UpcominContestTVC") as! UpcominContestTVC
        
        //Set Data
        cell.labelContestName.text = arrContest[indexPath.row]["name"] as? String ?? "No Name"
        
        cell.currentDate = currentData
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
        
        cell.labelContestDate.text = "Date: \( MyModel().convertStringDateToString(strDate: startDate, getFormate: "yyyy-MM-dd HH:mm:ss", returnFormat: "dd-MM-yyyy"))"
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
            MyModel().roundCorners(corners: [.topLeft, .bottomLeft], radius: 5, view: cell.buttonPlayNow)
        }
        
      
            if arrContest.count > 1 {
                let lastElement = arrContest.count - 1
                if indexPath.row == lastElement && ismoredata{
                    //call get api for next page
                    getAllContest()
                }

            }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let game_type = arrContest[indexPath.row]["game_type"] as! String
        if game_type == "spinning-machine" {
            let SpinningMachineTicketVC = self.storyboard?.instantiateViewController(withIdentifier: "SpinningMachineTicketVC") as! SpinningMachineTicketVC
            SpinningMachineTicketVC.dictContest = arrContest[indexPath.row]
          //  SpinningMachineTicketVC.storeimage = storeimage
            self.navigationController?.pushViewController(SpinningMachineTicketVC, animated: true)
        }
        else
        {
            let ticketVC = self.storyboard?.instantiateViewController(withIdentifier: "TicketVC") as! TicketVC
            ticketVC.dictContest = arrContest[indexPath.row]
            self.navigationController?.pushViewController(ticketVC, animated: true)
        }
       
    }
    
    //MARK: - Tableview Button Mathod
    @objc func buttonPlayNow(_ sender: UIButton) {
        isVisible = false
        let index = sender.tag
//        let ticketVC = self.storyboard?.instantiateViewController(withIdentifier: "TicketVC") as! TicketVC
//        ticketVC.dictContest = arrContest[index]
//        ticketVC.isFromMyTickets = false
//        self.navigationController?.pushViewController(ticketVC, animated: true)
        let game_type = arrContest[index]["game_type"] as! String
        if game_type == "spinning-machine" {
            let SpinningMachineTicketVC = self.storyboard?.instantiateViewController(withIdentifier: "SpinningMachineTicketVC") as! SpinningMachineTicketVC
            SpinningMachineTicketVC.dictContest = arrContest[index]
           // SpinningMachineTicketVC.storeimage = storeimage
            self.navigationController?.pushViewController(SpinningMachineTicketVC, animated: true)
        }
        else
        {
            let ticketVC = self.storyboard?.instantiateViewController(withIdentifier: "TicketVC") as! TicketVC
            ticketVC.dictContest = arrContest[index]
            self.navigationController?.pushViewController(ticketVC, animated: true)
        }
    }
}
//MARK: - API
extension PlayVC {
    func getAllContest() {
        print("IsVisible: \(self.isVisible)")
        if isShowLoading {
            Loading().showLoading(viewController: self)
        }
        let strURL = Define.APP_URL + Define.API_GET_CONTEST
        print("URL: \(strURL)")
        let parameter: [String: Any] = ["start": Start,"limit":Limit]
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
                
                self.isShowLoading = true
                Loading().hideLoading(viewController: self)
                
                
                print("Error: \(error!)")
//                if self.isVisible {
//                    self.retry()
//                } else {
//                    self.getAllContest()
//                }
                self.getAllContest()
            } else {
                if self.isRefresh {
                    self.isRefresh = true
                    self.refreshControl.endRefreshing()
                }
                
                self.isShowLoading = true
                Loading().hideLoading(viewController: self)
                
                
                print("Result: \(result!)")
                let status = result!["statusCode"] as? Int ?? 0
                if status == 200 {
                    
                   // self.arrContest.removeAll()
                    let dictData = result!["content"] as! [String: Any]
                  let arr =  dictData["contest"] as! [[String : Any]]
                    if arr.count > 0 {
                        self.arrContest.append(contentsOf: arr)
                        self.ismoredata = true
                        self.Start = self.Start + 30
                        self.Limit =  30
                    }
                    else
                    {
                        self.ismoredata = false
                    }
                  //  self.arrContest = dictData["contest"] as! [[String : Any]]
                    let serverDate = dictData["currentTime"] as? String ?? "\(MyModel().convertDateToString(date: Date(), returnFormate: "yyyy-MM-dd HH:mm:ss"))"
                    self.currentData = MyModel().converStringToDate(strDate: serverDate, getFormate: "yyyy-MM-dd HH:mm:ss")
                 
                    if self.arrContest.count <= 0 {
                        self.viewNoData.isHidden = false
                    } else {
                        self.viewNoData.isHidden = true
                    }
                    self.tablePlay.reloadData()
                    
                } else if status == 401 {
                    Define.APPDELEGATE.handleLogout()
                } else {
                    self.arrContest.removeAll()
                    self.viewNoData.isHidden = false
                    self.tablePlay.reloadData()
                    if self.isVisible {
                        Alert().showAlert(title: "Alert",
                                          message: result!["message"] as? String  ?? Define.ERROR_SERVER,
                                          viewController: self)
                    } else {
                        self.getAllContest()
                    }
                }

            }
        }
    }
    
    
    
  
    
    
 
    
}
//MARK: - Notifcation Delegate Method
extension PlayVC: UNUserNotificationCenterDelegate {
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
extension PlayVC {
    func retry() {
        let alertController = UIAlertController(title: Define.ERROR_TITLE,
                                                message: Define.ERROR_SERVER,
                                                preferredStyle: .alert)
        let buttonRetry = UIAlertAction(title: "Retry",
                                        style: .default)
        { _ in
            self.isShowLoading = true
            self.getAllContest()
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
class UpcominContestTVC: UITableViewCell {
    
    @IBOutlet weak var labelContestDate: UILabel!
    @IBOutlet weak var imageLevel: UIImageView!
    @IBOutlet weak var imageMode: UIImageView!
    @IBOutlet weak var labelContestName: UILabel!
    @IBOutlet weak var labelContestTime: UILabel!
    @IBOutlet weak var labelRemainingTime: UILabel!
    @IBOutlet weak var labelEntryCloseTime: UILabel!
    @IBOutlet weak var buttonPlayNow: UIButton!
    
    var seconds = Int()
    var timer:Timer?
    var currentDate = Date()
    
    var startDate: Date? {
        didSet {
            guard let date = startDate else {
                return
            }
            
            print("Date :\(date)")
            let calender = Calendar.current
            let unitFlags = Set<Calendar.Component>([ .second])
            let dateComponent = calender.dateComponents(unitFlags, from: Date(), to: date)
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
            
            print("Date :\(date)")
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
                buttonPlayNow.isHidden = true
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        labelEntryCloseTime.textColor = UIColor.red
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: true)
        selectionStyle = .none
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
            if buttonPlayNow.isHidden {
                buttonPlayNow.isHidden = false
            }
            closeSecond = closeSecond - 1
            labelEntryCloseTime.text = timeString(time: TimeInterval(closeSecond))
        } else {
            if closeTimer != nil {
                closeTimer!.invalidate()
                closeTimer = nil
            }
            labelEntryCloseTime.text = "00:00:00"
            buttonPlayNow.isHidden = true
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

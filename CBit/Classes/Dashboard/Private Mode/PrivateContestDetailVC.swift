import UIKit
import UserNotifications

class PrivateContestDetailVC: UIViewController {
    //MARK: - Proerties
    @IBOutlet weak var labelContestName: UILabel!
    @IBOutlet weak var tableDetailList: UITableView!
    
    var dictContest = [String: Any]()
    var arrTickets = [[String: Any]]()
    
    
    
    //MARK: - Default Method
    override func viewDidLoad() {
        super.viewDidLoad()
        tableDetailList.rowHeight = 50
        tableDetailList.sectionHeaderHeight = 50
        tableDetailList.tableFooterView = UIView()
        UNUserNotificationCenter.current().delegate = self
        //getPrivateContestDetail()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        labelContestName.text = dictContest["name"] as? String ?? "No Name"
    }
    
    //MARK: - Button Method
    @IBAction func buttonBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
//MARK: - TableView Delegate Method
extension PrivateContestDetailVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrTickets.count
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "PrivateContestHeaderTVC") as! PrivateContestHeaderTVC
        
        return headerCell
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PrivateContestDetailTVC") as! PrivateContestDetailTVC
        
        let strAmonut = "\(arrTickets[indexPath.row]["amount"] as? Double ?? 0.0)"
        //cell.labelEntryFees.text = "₹\(MyModel().getNumbers(value: Double(strAmonut)!))"
        let test = Double(strAmonut) ?? 0.00
        cell.labelEntryFees.text = String(format: "₹ %.02f", test)
        
        cell.labelParticepantJoin.text = "\(arrTickets[indexPath.row]["totalJoin"]!)"
        
        cell.buttonView.addTarget(self,
                                  action: #selector(buttonView(_:)),
                                  for: .touchUpInside)
        cell.buttonView.tag = indexPath.row
        
        return cell
    }
    
    //MARK: - TableView Button
    @objc func buttonView(_ sender: UIButton) {
        let index = sender.tag
        let userVC = self.storyboard?.instantiateViewController(withIdentifier: "JoinedPlayerVC") as! JoinedPlayerVC
        userVC.arrUsers = arrTickets[index]["users"] as! [[String: Any]]
        userVC.dictContest = dictContest
        self.navigationController?.pushViewController(userVC, animated: true)
    }
}

//MARK: - API
extension PrivateContestDetailVC {
    func getPrivateContestDetail() {
        Loading().showLoading(viewController: self)
        let parameter:[String: Any] = ["contestId": dictContest["id"]!]
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
                self.retry(strId: nil)
            } else {
                Loading().hideLoading(viewController: self)
                print("Result: \(result!)")
                let status = result!["statusCode"] as? Int ?? 0
                if status == 200 {
                    let dictData = result!["content"] as! [String: Any]
                    self.arrTickets = dictData["ticket"] as! [[String: Any]]
                    self.tableDetailList.reloadData()
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

extension PrivateContestDetailVC {
    func retry(strId: String?) {
        let alertController = UIAlertController(title: Define.ERROR_TITLE,
                                                message: Define.ERROR_SERVER,
                                                preferredStyle: .alert)
        let buttonRetry = UIAlertAction(title: "Retry",
                                        style: .default)
        { _ in
           self.getPrivateContestDetail()
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

//MARK: - Notifcation Delegate Method
extension PrivateContestDetailVC: UNUserNotificationCenterDelegate {
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

//MARK: - Cell Class
class PrivateContestDetailTVC: UITableViewCell {
    
    @IBOutlet weak var labelEntryFees: UILabel!
    @IBOutlet weak var labelParticepantJoin: UILabel!
    @IBOutlet weak var buttonView: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        MyModel().roundCorners(corners: [.allCorners],
                               radius: 4,
                               view: buttonView)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}

class PrivateContestHeaderTVC: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}

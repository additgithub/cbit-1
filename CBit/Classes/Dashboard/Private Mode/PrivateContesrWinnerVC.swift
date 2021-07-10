import UIKit
import UserNotifications

class PrivateContesrWinnerVC: UIViewController {

    @IBOutlet weak var labelContestName: UILabel!
    @IBOutlet weak var tableWinnerList: UITableView!
    @IBOutlet weak var viewNoData: UIView!
    
    var dictContest = [String: Any]()
    var dictTickets = [String: Any]()
    
    private var arrWinners = [[String: Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
      //  UNUserNotificationCenter.current().delegate = self
        getWinnersAPI()
        
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

extension PrivateContesrWinnerVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrWinners.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userCell = tableView.dequeueReusableCell(withIdentifier: "JoinedPlayerTVC") as! JoinedPlayerTVC
        
        userCell.labelUserName.text = arrWinners[indexPath.row]["name"] as? String ?? "No Name"
        let imageURL = URL(string: arrWinners[indexPath.row]["profile_image"] as? String ?? "")
        userCell.imageUser.sd_setImage(with: imageURL,
                                         placeholderImage: Define.PLACEHOLDER_PROFILE_IMAGE)
        
        return userCell
    }
}

//MARK: - API
extension PrivateContesrWinnerVC {
    func getWinnersAPI() {
        Loading().showLoading(viewController: self)
        let parameter: [String: Any] = ["contestPriceId": dictTickets["id"]!]
        let strURL = Define.APP_URL + Define.API_WINNER_LIST
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
                print("Error: \(error!)")
                self.retry()
            } else {
                Loading().hideLoading(viewController: self)
                print("Result: \(result!)")
                let status = result!["statusCode"] as? Int ?? 0
                if status == 200 {
                    self.arrWinners = result!["content"] as! [[String: Any]]
                    self.tableWinnerList.reloadData()
                    
                    if self.arrWinners.count > 0 {
                        self.viewNoData.isHidden = true
                    } else {
                        self.viewNoData.isHidden = false
                    }
                } else if status == 401 {
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

extension PrivateContesrWinnerVC {
    func retry() {
        let alertController = UIAlertController(title: Define.ERROR_TITLE,
                                                message: Define.ERROR_SERVER,
                                                preferredStyle: .alert)
        let buttonRetry = UIAlertAction(title: "Retry",
                                        style: .default)
        { _ in
            self.getWinnersAPI()
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
//extension PrivateContesrWinnerVC: UNUserNotificationCenterDelegate {
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

import UIKit
import UserNotifications

class JoinByCodeVC: UIViewController {

    @IBOutlet weak var textJoinCode: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      //  UNUserNotificationCenter.current().delegate = self
    }
    
    //MARK: - Button Method.
    @IBAction func buttonMenu(_ sender: Any) {
        view.endEditing(true)
        sideMenuController?.revealMenu()
        //self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonJoin(_ sender: Any) {
        
        if textJoinCode.text!.isEmpty {
            Alert().showTost(message: "Enter Code", viewController: self)
        } else {
            view.endEditing(true)
            getContestByCode()
        }
    }
}

//MARK: - API
extension JoinByCodeVC {
    func getContestByCode() {
        Loading().showLoading(viewController: self)
        let parameter:[String: Any] = ["contestCode": textJoinCode.text!]
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
                self.retry()
            } else {
                Loading().hideLoading(viewController: self)
                print("Result: \(result!)")
                let status = result!["statusCode"] as? Int ?? 0
                if status == 200 {
                    self.textJoinCode.text = nil
                    let dictData = result!["content"] as! [String: Any]
                    let arrTickets = dictData["contest"] as! [[String: Any]]
                    let serverDate = dictData["currentTime"] as? String ?? "\(MyModel().convertDateToString(date: Date(), returnFormate: "yyyy-MM-dd HH:mm:ss"))"
                    
                    let joinVC = self.storyboard?.instantiateViewController(withIdentifier: "PrivateContestJoinVC") as! PrivateContestJoinVC
                    joinVC.arrContest = arrTickets
                    joinVC.currentDate = MyModel().converStringToDate(strDate: serverDate, getFormate: "yyyy-MM-dd HH:mm:ss")
                    joinVC.isFromJoinCode = true
                    self.navigationController?.pushViewController(joinVC, animated: true)
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
//MARK: - Notifcation Delegate Method
//extension JoinByCodeVC: UNUserNotificationCenterDelegate {
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
extension JoinByCodeVC {
    func retry() {
        let alertController = UIAlertController(title: Define.ERROR_TITLE,
                                                message: Define.ERROR_SERVER,
                                                preferredStyle: .alert)
        let buttonRetry = UIAlertAction(title: "Retry",
                                        style: .default)
        { _ in
            self.getContestByCode()
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

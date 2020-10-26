import UIKit
import UserNotifications

class SettingVC: UIViewController {
    //MARK: - Properties
    @IBOutlet weak var switchNotification: UISwitch!
    @IBOutlet weak var labelVarsion: UILabel!
    
    //MARK: - Default Method
    override func viewDidLoad() {
        super.viewDidLoad()
        UNUserNotificationCenter.current().delegate = self
        if Define.USERDEFAULT.bool(forKey: "SetNotification") {
            switchNotification.isOn = true
        } else {
            switchNotification.isOn = false
        }
        
        self.setSwitchBackground(isOn: Define.USERDEFAULT.bool(forKey: "SetNotification"))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        labelVarsion.text = "Version: \(Define.APP_VERSION)"
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        switchNotification.layer.cornerRadius = switchNotification.frame.height / 2
        switchNotification.layer.masksToBounds = true
    }
    //MARK: - Switch Method
    @IBAction func switchNotification(_ sender: UISwitch) {
        setNotificationAPI(isSet: sender.isOn)
    }
    
    //MARK: - Button Method
    @IBAction func buttonMenu(_ sender: Any) {
        sideMenuController?.revealMenu()
    }
    
    func setSwitchBackground(isOn: Bool) {
        if isOn {
           switchNotification.backgroundColor = #colorLiteral(red: 0.1019607843, green: 0.3098039216, blue: 0.3647058824, alpha: 1)
        } else {
            switchNotification.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        }
    }
}

//MARK: - API
extension SettingVC {
    func setNotificationAPI(isSet: Bool) {
        Loading().showLoading(viewController: self)
        let parameter: [String: Any] = ["setNotification": isSet ? "1" : "0"]
        let strURL = Define.APP_URL + Define.API_SETNOTIFICATION
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
                self.switchNotification.isOn = !self.switchNotification.isOn
                print("Error: \(error!.localizedDescription)")
                self.retry()
            } else {
                Loading().hideLoading(viewController: self)
                print("Result: \(result!)")
                let status = result!["statusCode"] as? Int ?? 0
                if status == 200 {
                    let dictData = result!["content"] as! [String: Any]
                    let setNotification = dictData["setNotification"] as? Bool ?? false
                    Define.USERDEFAULT.set(setNotification, forKey: "SetNotification")
                    
                    if Define.USERDEFAULT.bool(forKey: "SetNotification") {
                        self.switchNotification.isOn = true
                    } else {
                        self.switchNotification.isOn = false
                    }
                    self.setSwitchBackground(isOn: setNotification)
                } else if status == 401 {
                    Define.APPDELEGATE.handleLogout()
                } else {
                    self.switchNotification.isOn = !self.switchNotification.isOn
                    Alert().showAlert(title: "Error",
                                      message: result!["message"] as? String ?? Define.ERROR_SERVER,
                                      viewController: self)
                }
            }
        }
    }
}

//MARK: - Alert Contollert
extension SettingVC {
    func retry() {
        let alertController = UIAlertController(title: Define.ERROR_TITLE,
                                                message: Define.ERROR_SERVER,
                                                preferredStyle: .alert)
        let buttonRetry = UIAlertAction(title: "Retry",
                                        style: .default)
        { _ in
            self.setNotificationAPI(isSet: !self.switchNotification.isOn)
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
extension SettingVC: UNUserNotificationCenterDelegate {
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

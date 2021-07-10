import UIKit
import UserNotifications

class OTPVarificationVC: UIViewController {
    //MARKL: - Properties
    @IBOutlet weak var labelMobileNumber: UILabel!
    @IBOutlet weak var textOTP: UITextField!
    
    var transferType = Int()
    var dictWalletData = [String: Any]()
    var dictOTPDetail = [String: Any]()
    
    var isSendOTP = Bool()
    var isAddWalletAPI = Bool()
    
    //MARKL: - Default Method
    override func viewDidLoad() {
        super.viewDidLoad()
      //  UNUserNotificationCenter.current().delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        labelMobileNumber.text = "Please enter Verification code send to \n +91 \(Define.USERDEFAULT.value(forKey: "UserMobile")!)"
        textOTP.text = "\(dictOTPDetail["OTP"]!)"
    }
    
    //MARK: Button Method
    @IBAction func buttonBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonResend(_ sender: UIButton) {
        isSendOTP = true
        isAddWalletAPI = false
        sendOTPAPI()
    }
    
    @IBAction func buttonVerifyOTP(_ sendr: UIButton) {
        isSendOTP = false
        isAddWalletAPI = true
        addWalletAPI()
    }
}

//MARK: - API
extension OTPVarificationVC {
    func addWalletAPI() {
        Loading().showLoading(viewController: self)
        let parameter:[String: Any] = ["mobile": dictWalletData["MobileNumber"]!,
                                       "amount": dictWalletData["Amount"]!,
                                       "otpId": dictOTPDetail["OTPId"]!,
                                       "otp": textOTP.text!,
                                       "type": "\(transferType)"]
        let strURL = Define.APP_URL + Define.API_ADD_WALLET
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
                
            } else {
                Loading().hideLoading(viewController: self)
                print("Result: \(result!)")
                let status = result!["statusCode"] as? Int ?? 0
                if status == 200 {
                    let dictData = result!["content"] as! [String: Any]
                    
                    Define.USERDEFAULT.set(dictData["pbAmount"] as? Double ?? 0.0, forKey: "PBAmount")
                    Define.USERDEFAULT.set(dictData["sbAmount"] as? Double ?? 0.0, forKey: "SBAmount")
                    Define.USERDEFAULT.set(dictData["tbAmount"] as? Double ?? 0.0, forKey: "TBAmount")
                    
                    let statusVC = self.storyboard?.instantiateViewController(withIdentifier: "TransferSuccessVC") as! TransferSuccessVC
                    self.navigationController?.pushViewController(statusVC, animated: true)
                    
                } else if status == 401 {
                    Define.APPDELEGATE.handleLogout()
                } else {
                    Alert().showAlert(title: "Alert",
                                      message: result!["message"] as? String ?? Define.ERROR_SERVER,
                                      viewController: self)
                }
            }
        }
    }
    
    func sendOTPAPI() {
        Loading().showLoading(viewController: self)
        let strURL = Define.APP_URL + Define.API_SEND_OTP
        print("URL: \(strURL)")
        
        SwiftAPI().postMethodSecure(stringURL: strURL,
                                    parameters: nil,
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
                    let dictData = result!["content"] as! [String: Any]
                    self.dictOTPDetail = ["OTPId": dictData["otpId"]!,
                                           "OTP": dictData["otp"]!]
                    //self.textOTP.text = "\(self.dictOTPDetail["OTP"]!)"
                } else if status == 401 {
                    Define.APPDELEGATE.handleLogout()
                } else {
                    Alert().showAlert(title: "Alert",
                                      message: result!["message"] as? String ?? Define.ERROR_SERVER,
                                      viewController: self)
                }
            }
        }
    }
}

//MARK: - Alert Contollert
extension OTPVarificationVC {
    func retry() {
        let alertController = UIAlertController(title: Define.ERROR_TITLE,
                                                message: Define.ERROR_SERVER,
                                                preferredStyle: .alert)
        let buttonRetry = UIAlertAction(title: "Retry",
                                        style: .default)
        { _ in
            if self.isSendOTP {
                self.sendOTPAPI()
            } else if self.isAddWalletAPI {
                self.addWalletAPI()
            }
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
//extension OTPVarificationVC: UNUserNotificationCenterDelegate {
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

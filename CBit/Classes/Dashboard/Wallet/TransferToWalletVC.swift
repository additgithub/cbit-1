import UIKit
import UserNotifications

class TransferToWalletVC: UIViewController {
    //MARK: - Properties
    @IBOutlet weak var textContryCode: UITextField!
    @IBOutlet weak var textMobileNumber: UITextField!
    @IBOutlet weak var textAmount: UITextField!
    @IBOutlet weak var labelbalance: UILabel!
    
    var transferType = Int()
    private var amount = Double()
    //MARK: - Default Method.
    override func viewDidLoad() {
        super.viewDidLoad()
        textMobileNumber.delegate = self
      //  UNUserNotificationCenter.current().delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if transferType == 1 {
            let pbAmount = "\(Define.USERDEFAULT.value(forKey: "SBAmount")!)"
            guard let amountPB = Double(pbAmount) else {
                return
            }
            amount = amountPB
            labelbalance.text = MyModel().getCurrncy(value: amountPB)
            
        } else {
            let pbAmount = "\(Define.USERDEFAULT.value(forKey: "PBAmount")!)"
            guard let amountPB = Double(pbAmount) else {
                return
            }
            amount = amountPB
            labelbalance.text = MyModel().getCurrncy(value: amountPB)
        }
    }
    
    //MARK: - Button Method
    @IBAction func buttonBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func buttonSend(_ sender: Any) {
        
        if textMobileNumber.text!.isEmpty {
            
            Alert().showTost(message: "Enter Mobile Number.", viewController: self)
            
        } else if !MyModel().isValidMobileNumber(value: textMobileNumber.text!)
        {
            
            Alert().showTost(message: "Enter Proper Mobile Number.", viewController: self)
            
        } else if textAmount.text!.isEmpty {
            
            Alert().showTost(message: "Enter Amount.", viewController: self)
        } else {
            guard let enterAmount = Double(textAmount.text!) else {
                Alert().showTost(message: "Enter Proper Amount", viewController: self)
                return
            }
            if amount < enterAmount {
                Alert().showAlert(title: "Insufficiant Balance",
                                  message: "Your balance is too low to proceed",
                                  viewController: self)
            } else {
                sendOTPAPI()
            }
        }
    }
}

//MARK: TextField Delegate Method
extension TransferToWalletVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 10
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        
        return newString.length <= maxLength ? true : false
    }
}

//MARK: - API
extension TransferToWalletVC {
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
                    
                    let otpVC = self.storyboard?.instantiateViewController(withIdentifier: "OTPVarificationVC") as! OTPVarificationVC
                    otpVC.dictOTPDetail = ["OTPId": dictData["otpId"]!,
                                           "OTP": dictData["otp"]!]
                    otpVC.dictWalletData = ["MobileNumber": self.textMobileNumber.text!,
                                            "Amount": self.textAmount.text!]
                    otpVC.transferType = self.transferType
                    self.navigationController?.pushViewController(otpVC,
                                                                  animated: true)
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
extension TransferToWalletVC {
    func retry() {
        let alertController = UIAlertController(title: Define.ERROR_TITLE,
                                                message: Define.ERROR_SERVER,
                                                preferredStyle: .alert)
        let buttonRetry = UIAlertAction(title: "Retry",
                                        style: .default)
        { _ in
            self.sendOTPAPI()
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
//extension TransferToWalletVC: UNUserNotificationCenterDelegate {
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

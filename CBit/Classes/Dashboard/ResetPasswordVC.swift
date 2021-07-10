import UIKit
import UserNotifications

class ResetPasswordVC: UIViewController {
    //MARK: - Properties
    @IBOutlet weak var imageCurrentPassword: ImageViewForTextFieldWight!
    @IBOutlet weak var textCurrentPassword: UITextField!
    @IBOutlet weak var imageNewPassword: ImageViewForTextFieldWight!
    @IBOutlet weak var textNewPassword: UITextField!
    @IBOutlet weak var imageConfirmPassword: ImageViewForTextFieldWight!
    @IBOutlet weak var textConfirmPassword: UITextField!
    
    //MARK: - Default Method
    override func viewDidLoad() {
        super.viewDidLoad()
       // UNUserNotificationCenter.current().delegate = self
    }
    
    //MARK: - Button Method
    @IBAction func buttonBack(_ sender: Any) {
        //sideMenuController?.revealMenu()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func buttonReset(_ sender: Any) {
        if textCurrentPassword.text!.isEmpty || textCurrentPassword.text!.count < 8 {
            Alert().showTost(message: "Enter Proper Current Password", viewController: self)
        } else if textNewPassword.text!.isEmpty || textNewPassword.text!.count < 8 {
            Alert().showTost(message: "Enter Proper New Password", viewController: self)
        } else if textConfirmPassword.text!.isEmpty || textConfirmPassword.text!.count < 8 {
            Alert().showTost(message: "Enter Proper Confirm Password", viewController: self)
        } else if textNewPassword.text!  != textConfirmPassword.text! {
            Alert().showAlert(title: "Password",
                              message: "Confirm password does not match with New password",
                              viewController: self)
        } else {
            resetPasswordAPI()
        }
    }
}

//MARK: - API
extension ResetPasswordVC {
    func resetPasswordAPI() {
        Loading().showLoading(viewController: self)
        let parameter: [String: Any] = ["email" : Define.USERDEFAULT.value(forKey: "Email")!,
                                        "oldPassword": textCurrentPassword.text!,
                                        "newPassword": textNewPassword.text!]
        let strURL = Define.APP_URL + Define.API_CHANGE_PASSWORD
        
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
                Alert().showAlert(title: "Error",
                                  message: Define.ERROR_SERVER,
                                  viewController: self)
            } else {
                Loading().hideLoading(viewController: self)
                print("Result: \(result!)")
                let status = result!["statusCode"] as? Int ?? 0
                if status == 200 {
                    self.textCurrentPassword.text = nil
                    self.textNewPassword.text = nil
                    self.textConfirmPassword.text = nil
                    Alert().showTost(message: result!["message"] as! String, viewController: self)
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
//extension ResetPasswordVC: UNUserNotificationCenterDelegate {
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
extension ResetPasswordVC {
    func retry() {
        let alertController = UIAlertController(title: Define.ERROR_TITLE,
                                                message: Define.ERROR_SERVER,
                                                preferredStyle: .alert)
        let buttonRetry = UIAlertAction(title: "Retry",
                                        style: .default)
        { _ in
            self.resetPasswordAPI()
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

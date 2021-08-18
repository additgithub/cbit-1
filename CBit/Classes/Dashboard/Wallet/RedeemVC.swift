import UIKit
import UserNotifications

class RedeemVC: UIViewController {
    //MARK: - Properties.
    @IBOutlet weak var labelBalance: LabelComman!
    @IBOutlet weak var textBank: UITextField!
    @IBOutlet weak var buttonSelectBank: UIButton!
    @IBOutlet weak var textAmount: UITextField!
    
    var dropDown: MyDropDown?
    var arrBanks = [String]()
    var arrBankAccounts = [[String: Any]]()
    var dictSelectedBank = [String: Any]()
    
    
    //MARK: - Default Method.
    override func viewDidLoad() {
        super.viewDidLoad()
      //  UNUserNotificationCenter.current().delegate = self
        getBankAccounts()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleNotification(_:)),
                                               name: .BankAccountAdded,
                                               object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let sbAmount = "\(Define.USERDEFAULT.value(forKey: "SBAmount")!)"
        guard let amountSB = Double(sbAmount) else {
            return
        }
        labelBalance.text = MyModel().getCurrncy(value: amountSB)
        
    }
    
    func setDetails() {
        if arrBankAccounts.count == 0 {
//            Alert().showAlert(title: "Alert",
//                              message: "No Acount Available.",
//                              viewController: self)
            goToAddBank()
        } else {
            for item in arrBankAccounts {
                if let bankName = item["bank_name"] as? String {
                    let strBankAC = item["account_no"] as? String ?? "XXXXXXXXXX"
                    arrBanks.append(bankName + " XX" + strBankAC.suffix(4))
                }
            }
        }
    }
    
    //MARK: - Handle Notification
    @objc func handleNotification(_ notification: Notification) {
        getBankAccounts()
    }
    
    
    //MARK: - Button Method
    @IBAction func buttonBack(_ sender: Any) {
        NotificationCenter.default.removeObserver(self)
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func buttonSelectBank(_ sender: Any) {
        
        if arrBankAccounts.count == 0 {
            goToAddBank()
        } else {
            if dropDown == nil {
                dropDown = MyDropDown()
                dropDown!.delegate = self
                dropDown!.showMyDropDown(sendButton: buttonSelectBank,
                                         height: 120,
                                         arrayList: arrBanks,
                                         imageList: nil,
                                         direction: "Down")
            } else {
                dropDown!.hideMyDropDown(sendButton: buttonSelectBank)
                dropDown = nil
            }
        }
    }
    @IBAction func buttonRedeem(_ sender: Any) {
        if textBank.text!.isEmpty {
            if arrBankAccounts.count == 0 {
                self.goToAddBank()
            } else {
                Alert().showTost(message: "Select Bank", viewController: self)
            }
        } else if textAmount.text!.isEmpty {
            Alert().showTost(message: "Enter Amount", viewController: self)
        } else if !MyModel().isConnectedToInternet() {
            Alert().showTost(message: Define.ERROR_INTERNET, viewController: self)
        } else {
            guard let _ = Double(textAmount.text!) else {
                Alert().showTost(message: "Enter Proper Amount", viewController: self)
                return
            }
            
            redeemRequest()
        }
    }
}
//MARK: - DropDown Delegate
extension RedeemVC: MyDropDownDelegate {
    func recievedSelectedValue(name: String, index: Int) {
        dropDown!.hideMyDropDown(sendButton: buttonSelectBank)
        dropDown = nil
        textBank.text = name
        dictSelectedBank = arrBankAccounts[index]
    }
}

//MARK: - Notifcation Delegate Method
//extension RedeemVC: UNUserNotificationCenterDelegate {
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
extension RedeemVC {
    func getBankAccounts() {
        Loading().showLoading(viewController: self)
        let strURL = Define.APP_URL + Define.API_GET_ACCOUNTS
        print("URL: \(strURL)")
        SwiftAPI().postMethodSecure(stringURL: strURL,
                                    parameters: nil,
                                    header: Define.USERDEFAULT.value(forKey: "AccessToken") as? String,
                                    auther: Define.USERDEFAULT.value(forKey: "UserID") as? String)
        { (result, error) in
            if error != nil {
                Loading().hideLoading(viewController: self)
                print("Error: \(error!.localizedDescription)")
                //self.retry()
                self.getBankAccounts()
            } else {
                Loading().hideLoading(viewController: self)
                print("Result: \(result!)")
                let status = result!["statusCode"] as? Int ?? 0
                if status == 200 {
                    self.arrBankAccounts = result!["content"] as! [[String: Any]]
                    self.setDetails()
                } else if status == 401 {
                    Define.APPDELEGATE.handleLogout()
                } else {
                    Alert().showAlert(title: "Alert",
                                      message: result!["message"] as? String ?? "Something Wrong",
                                      viewController: self)
                }
            }
        }
    }
    
    func redeemRequest() {
        Loading().showLoading(viewController: self)
        let parameter:[String: Any] = [
            "bank_id": dictSelectedBank["bank_id"]!,
            "bank_name": dictSelectedBank["bank_name"]!,
            "account_no": dictSelectedBank["account_no"]!,
            "ifsc_code": dictSelectedBank["ifsc_code"]!,
            "amount": textAmount.text!
        ]
        let strURL = Define.APP_URL + Define.API_REDEEM
        print("Parameter: \(parameter)\nURL: \(strURL)")
        
        let jsonString = MyModel().getJSONString(object: parameter)
        let encriptString = MyModel().encrypting(strData: jsonString!, strKey: Define.KEY)
        let strbase64 = encriptString.toBase64()
        
        SwiftAPI().postMethodSecure(stringURL: strURL,
                                    parameters: ["data": strbase64!],
                                    header: Define.USERDEFAULT.value(forKey: "AccessToken") as? String,
                                    auther: Define.USERDEFAULT.value(forKey: "UserID") as? String)
        { (result, error) in
            if error != nil {
                Loading().hideLoading(viewController: self)
                print("Error: \(error!.localizedDescription)")
//                Alert().showAlert(title: "Error",
//                                  message: Define.ERROR_SERVER,
//                                  viewController: self)
                self.redeemRequest()
            } else {
                Loading().hideLoading(viewController: self)
                print("Result: \(result!)")
                let status = result!["statusCode"] as? Int ?? 0
                if status == 200 {
                    let dictData = result!["content"] as! [String: Any]
                    
                    Define.USERDEFAULT.set(dictData["pbAmount"] as? Double ?? 0.0, forKey: "PBAmount")
                    Define.USERDEFAULT.set(dictData["sbAmount"] as? Double ?? 0.0, forKey: "SBAmount")
                    Define.USERDEFAULT.set(dictData["tbAmount"] as? Double ?? 0.0, forKey: "TBAmount")
                    
                    self.conformationPopup()
                } else {
                    Alert().showAlert(title: "Alert",
                                      message: result!["message"] as? String ?? "Something Wrong",
                                      viewController: self)
                }
            }
        }
    }
}

//MARK: - Alert Contollert
extension RedeemVC {
    func retry() {
        let alertController = UIAlertController(title: Define.ERROR_TITLE,
                                                message: Define.ERROR_SERVER,
                                                preferredStyle: .alert)
        let buttonRetry = UIAlertAction(title: "Retry",
                                        style: .default)
        { _ in
            self.getBankAccounts()
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
    
    func goToAddBank() {
        let alertController = UIAlertController(title: nil,
                                                message: "Link Bank Account",
                                                preferredStyle: .alert)
        let buttonOk = UIAlertAction(title: "OK",
                                     style: .default)
        { _ in
            let addBankVC = self.storyboard?.instantiateViewController(withIdentifier: "ProfileNC")
            addBankVC!.modalPresentationStyle = .fullScreen
            self.present(addBankVC!, animated: true, completion: nil)
        }
        let buttonCancel = UIAlertAction(title: "CANCEL",
                                         style: .cancel,
                                         handler: nil)
        alertController.addAction(buttonCancel)
        alertController.addAction(buttonOk)
        present(alertController,
                animated: true,
                completion: nil)
        
    }
    //Your redeem request has been processed . You will be notified with an email when the transaction is completed .
    func conformationPopup(){
        let alertContoller = UIAlertController(title: "Withdrawal request",
                                              message: "Your withdrawal request will be processed within 7 working days. You will be notified with a dropdown notification along with a confirmation email when the transaction is successfully processed. You can flip your inr passbook entry to view trancastion ID. Note: ₹3 is deducted on every withdrawal against bank charges, irrelevant of the withdrawal amount.",
                                              preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK",
                                     style: .default)
        { _ in
            self.navigationController?.popViewController(animated: true)
        }
        alertContoller.addAction(okAction)
        self.present(alertContoller, animated: true, completion: nil)
    }
}


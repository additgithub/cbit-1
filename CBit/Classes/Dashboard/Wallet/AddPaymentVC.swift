import UIKit
import UserNotifications
import PayKun

class AddPaymentVC: UIViewController {

    @IBOutlet weak var labelBalance: LabelComman!
    @IBOutlet weak var labelWinning: LabelComman!
    
    @IBOutlet weak var textAmount: UITextField!
    
    var paymentPaykun: PaykunCheckout!
    
    var isFromTicket = Bool()
    var addAmount = Double()
    
    var isFromLink = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UNUserNotificationCenter.current().delegate = self
      
        paymentPaykun = PaykunCheckout.init(key: Define.PAYMENT_ACCESS_TOKEN,
                                            merchantId: Define.PAYMENT_MARCHANT_ID,
                                            isLive: Define.ISLIVE,
                                            andDelegate: self)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("Appear.")
        
        let pbAmount = "\(Define.USERDEFAULT.value(forKey: "PBAmount")!)"
        guard let amountPB = Double(pbAmount) else {
            return
        }
        labelBalance.text = MyModel().getCurrncy(value: amountPB)
        
        let sbAmount = "\(Define.USERDEFAULT.value(forKey: "SBAmount")!)"
        guard let amountSB = Double(sbAmount) else {
            return
        }
        labelWinning.text = MyModel().getCurrncy(value: amountSB)
        
        if isFromTicket {
            textAmount.text = String(format: "₹%.2f", addAmount) // "\(addAmount)"
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("Desappear.")
    }
    
    //MARK: - Button Method
    @IBAction func buttonBack(_ sender: Any) {
        if isFromLink {
            self.dismiss(animated: true, completion: nil)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    @IBAction func buttonAddMoney(_ sender: Any) {
        guard let addAmount = Double(textAmount.text!) else {
            Alert().showTost(message: "Enter Proper Amount", viewController: self)
            return
        }
        
        if addAmount < 10 {
            Alert().showTost(message: "Minimum deposit - ₹10.", viewController: self)
        } else {
            
            var orderId = "\(1 + arc4random_uniform(9))"
            for _ in 0..<9 {
                orderId = orderId + ("\(arc4random_uniform(10))")
            }
                        
//            paymentPaykun.checkout(withCustomerName: Define.USERDEFAULT.value(forKey: "UserName") as? String ?? "CBit User",
//                                   customerEmail: Define.USERDEFAULT.value(forKey: "Email") as! String,
//                                   customerMobile: Define.USERDEFAULT.value(forKey: "UserMobile") as! String,
//                                   productName: "CBit",
//                                   orderNo: orderId,
//                                   amount: "\(addAmount)",
//                                   viewController: self)
            
            paymentPaykun.checkout(withCustomerName: Define.USERDEFAULT.value(forKey:"FirstName") as? String ?? "CBit User",
                                   customerEmail: Define.USERDEFAULT.value(forKey: "Email") as! String,
                                   customerMobile: Define.USERDEFAULT.value(forKey: "UserMobile") as! String,
                                   productName: "CBit",
                                   orderNo: orderId,
                                   amount: "\(addAmount)",
                viewController: self)

        }
    }
}

//MARK: - API
extension AddPaymentVC {
    func addMoneyAPI(paymentId: String)
    {
        Loading().showLoading(viewController: self)
        let parameter: [String: Any] = [
            "amount": textAmount.text!,
            "transactionId": paymentId
        ]
        let strURL = Define.APP_URL + Define.API_ADD_MONEY
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
                //self.retry()
                self.addMoneyAPI(paymentId: paymentId)
            } else {
                Loading().hideLoading(viewController: self)
                print("Result: \(result!)")
                
                let status = result!["statusCode"] as? Int ?? 0
                if status == 200 {
                    self.textAmount.text = nil
                    let dictData = result!["content"] as! [String: Any]
                    
                    Define.USERDEFAULT.set(dictData["pbAmount"]!, forKey: "PBAmount")
                    Define.USERDEFAULT.set(dictData["sbAmount"]!, forKey: "SBAmount")
                    Define.USERDEFAULT.set(dictData["tbAmount"]!, forKey: "TBAmount")
                    let statusVC = self.storyboard?.instantiateViewController(withIdentifier: "PaymentStatusVC") as! PaymentStatusVC
                    statusVC.isTransactionStatus = true
                    self.navigationController?.pushViewController(statusVC, animated: true)
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
extension AddPaymentVC: UNUserNotificationCenterDelegate {
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
extension AddPaymentVC {
    func retry() {
        let alertController = UIAlertController(title: Define.ERROR_TITLE,
                                                message: Define.ERROR_SERVER,
                                                preferredStyle: .alert)
        let buttonRetry = UIAlertAction(title: "Retry",
                                        style: .default)
        { _ in
            //self.addMoneyAPI()
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

//MARK: - PAYKUN Delegate Method
extension AddPaymentVC: PaykunCheckoutDelegate {
    func onPaymentFailed(_ responce: [AnyHashable : Any]) {
        print("-----> Payment Failed")
        print("Data: ", responce)
        
        let statusVC = self.storyboard?.instantiateViewController(withIdentifier: "PaymentStatusVC") as! PaymentStatusVC
        statusVC.isTransactionStatus = false
        self.navigationController?.pushViewController(statusVC, animated: true)
    }
    
    func onPaymentSucceed(_ responce: [AnyHashable : Any]) {
        print("-----> Payment Success")
        print("Data: ", responce)
        let paymentID = responce["req_id"] as? String ?? ""
        self.addMoneyAPI(paymentId: paymentID)
    }
}

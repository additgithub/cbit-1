import UIKit
import UserNotifications
//import PayKun
import CashfreePG
import CashfreePGCoreSDK
import CashfreePGUISDK

class Utils {
    
    // TEST
    // API ID - 19394184a127e65aca15fcbf3f149391
    // Secret Key - 8be190814383278e9815fc8b526d99fe285bddce
    
    // LIVE
    // API ID - 2423146ae9d1b480ecf5840c65413242
    // Secret Key - a156718bf429c722b8b27b4ea81304253cb50a96
    
   // TEST
//    static var environment: CFENVIRONMENT = .SANDBOX
//    static var APPID = "19394184a127e65aca15fcbf3f149391"
//    static var SecretKey = "8be190814383278e9815fc8b526d99fe285bddce"
//    static var URL = "https://sandbox.cashfree.com/pg/orders"

    // LIVE
     static var environment: CFENVIRONMENT = .PRODUCTION
     static var APPID = "2423146ae9d1b480ecf5840c65413242"
     static var SecretKey = "a156718bf429c722b8b27b4ea81304253cb50a96"
     static var URL = "https://api.cashfree.com/pg/orders"


//    static let payment_session_id = "session_PZpsrKm4XXuTA-DhdcsBnwIpTZM8dzO-Pr7hFprzB6e0tbrlbYQecrsPBtd5IHB59wv3y3YuRG3zDfyXuNMJWl83JHZbiLpDnC5AAgN3I-LF"
//    static let order_id = "order_3242E1iDhG1aXtjKgETgKtxj0sDlnS"

}

class AddPaymentVC: UIViewController {

    @IBOutlet weak var labelBalance: LabelComman!
    @IBOutlet weak var labelWinning: LabelComman!
    
    @IBOutlet weak var textAmount: UITextField!
    @IBOutlet weak var btnaddmoney: UIButton!
    
   // var paymentPaykun: PaykunCheckout!
    
    var isFromTicket = Bool()
    var addAmount = Double()
    
    var isFromLink = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
     //   UNUserNotificationCenter.current().delegate = self
      
//        paymentPaykun = PaykunCheckout.init(key: Define.PAYMENT_ACCESS_TOKEN,
//                                            merchantId: Define.PAYMENT_MARCHANT_ID,
//                                            isLive: Define.ISLIVE,
//                                            andDelegate: self)
        
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
        
        getaddmoneystatus()
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
        
//        if addAmount < 10 {
//            Alert().showTost(message: "Minimum deposit - ₹10.", viewController: self)
//        } else {
            
            var orderId = "\(1 + arc4random_uniform(9))"
            for _ in 0..<9 {
                orderId = orderId + ("\(arc4random_uniform(10))")
            }
            GetPaymentIDfromcashfreeAPI(orderId: orderId)

//            paymentPaykun.checkout(withCustomerName: Define.USERDEFAULT.value(forKey: "UserName") as? String ?? "CBit User",
//                                   customerEmail: Define.USERDEFAULT.value(forKey: "Email") as! String,
//                                   customerMobile: Define.USERDEFAULT.value(forKey: "UserMobile") as! String,
//                                   productName: "CBit",
//                                   orderNo: orderId,
//                                   amount: "\(addAmount)",
//                                   viewController: self)
          //  DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                
//                self.paymentPaykun.checkout(withCustomerName: Define.USERDEFAULT.value(forKey:"FirstName") as? String ?? "CBit User",
//                                       customerEmail: Define.USERDEFAULT.value(forKey: "Email") as! String,
//                                       customerMobile: Define.USERDEFAULT.value(forKey: "UserMobile") as! String,
//                                       productName: "Credentia Games LLP Cbit Original",
//                                       orderNo: orderId,
//                                       amount: "\(addAmount)",
//                                       viewController: self)
         //   }
            
      //  }
    }
    
    func MakePayment(dict:[String:Any]) {
        do {
            let session = try CFSession.CFSessionBuilder()
            .setOrderID("\(dict["order_id"] ?? "")") // Replace the order_id
                .setPaymentSessionId("\(dict["payment_session_id"] ?? "")") // Replace the order_token
                .setEnvironment(Utils.environment)
                .build()
            let paymentComponent = try CFPaymentComponent.CFPaymentComponentBuilder()
                .enableComponents([
                    "order-details",
                    "card",
                    "upi",
                    "wallet",
                    "netbanking",
                    "emi",
                    "paylater"
                ])
                .build()
            let nativeCheckoutPayment = try CFDropCheckoutPayment.CFDropCheckoutPaymentBuilder()
                .setSession(session)
                .setComponent(paymentComponent)
                .build()
            
            let service = CFPaymentGatewayService.getInstance()
            service.setCallback(self)
            try service.doPayment(nativeCheckoutPayment, viewController: self)
        } catch let e {
            let error = e as! CashfreeError
            print(error.localizedDescription)
        }
    }
}

extension AddPaymentVC: CFResponseDelegate {
    
    func onError(_ error: CFErrorResponse, order_id: String) {
        print(error.message as Any)
                print("-----> Payment Failed")
              //  print("Data: ", responce)
        
                let statusVC = self.storyboard?.instantiateViewController(withIdentifier: "PaymentStatusVC") as! PaymentStatusVC
                statusVC.isTransactionStatus = false
                self.navigationController?.pushViewController(statusVC, animated: true)
    }
    
    func verifyPayment(order_id: String) {
        // Verify The Payment here
                print("-----> Payment Success")
                print("Data: ", order_id)
               // let paymentID = responce["req_id"] as? String ?? ""
                self.addMoneyAPI(paymentId: order_id)
    }
    
}

//MARK: - API
extension AddPaymentVC {
    func GetPaymentIDfromcashfreeAPI(orderId: String)
    {
        guard let addAmount = Double(textAmount.text!) else {
            Alert().showTost(message: "Enter Proper Amount", viewController: self)
            return
        }
        
       // Loading().showLoading(viewController: self)
        let parameter: [String: Any] = [
            "order_id": orderId,
            "order_amount": "\(addAmount)",
            "order_currency": "INR",
            "order_note": "user order",
            "customer_details": ["customer_id":Define.USERDEFAULT.value(forKey: "UserID") as? String,
                                 "customer_name":Define.USERDEFAULT.value(forKey: "UserName") as? String ?? "CBit User",
                                 "customer_email":Define.USERDEFAULT.value(forKey: "Email") as? String,
                                 "customer_phone":Define.USERDEFAULT.value(forKey: "UserMobile") as? String]
        ]
        let strURL = "https://sandbox.cashfree.com/pg/orders"
        print("Parameter: \(parameter)\nURL: \(strURL)")
        
        let jsonString = MyModel().getJSONString(object: parameter)

        
      
        
       // var semaphore = DispatchSemaphore (value: 0)
        let parameters = jsonString

       // let parameters = "{\n    \"order_amount\": \"1.00\",\n    \"order_id\": \"order_id\",\n    \"order_currency\": \"INR\",\n    \"customer_details\": {\n        \"customer_id\": \"customer_id\",\n        \"customer_name\": \"customer_name\",\n        \"customer_email\": \"customer_email\",\n        \"customer_phone\": \"customer_phone\"\n    },\n    \"order_meta\": {\n        \"notify_url\": \"https://test.cashfree.com\"\n    },\n    \"order_note\": \"some order note here\"\n}"
        let postData = parameters!.data(using: .utf8)

        var request = URLRequest(url: URL(string: Utils.URL)!,timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(Utils.APPID, forHTTPHeaderField: "x-client-id")
        request.addValue(Utils.SecretKey, forHTTPHeaderField: "x-client-secret")
        request.addValue("2022-09-01", forHTTPHeaderField: "x-api-version")
        request.addValue("Cbit", forHTTPHeaderField: "x-request-id")

        request.httpMethod = "POST"
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
           // Loading().hideLoading(viewController: self)
          guard let data = data else {
            print(String(describing: error))
        //    semaphore.signal()
            return
          }
          print(String(data: data, encoding: .utf8)!)
            let orderData = MyModel().convertToDictionary(text: (String(data: data, encoding: .utf8)!))
            print("OrderData",orderData ?? [:])
       //   semaphore.signal()
            DispatchQueue.main.async {
                self.MakePayment(dict: orderData ?? [:])
            }
        }

        task.resume()
      //  semaphore.wait()
    }
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
    
    
    func getaddmoneystatus()  {
      
        let strURL = Define.APP_URL + Define.getaddmoneystatus
        print("URL: \(strURL)")
        
        
        SwiftAPI().postMethodSecure(stringURL: strURL,
                                    parameters: nil,
                                    header: Define.USERDEFAULT.value(forKey: "AccessToken") as? String,
                                    auther: Define.USERDEFAULT.value(forKey: "UserID") as? String)
        { (result, error) in
            if error != nil {
        
                print("Error: \(error!)")
                self.getaddmoneystatus()
            } else {
         
                print("Result: \(result!)")
                
                let status = result!["statusCode"] as? Int ?? 0
                if status == 200 {
                    
                    let content = result!["content"] as? [String: Any] ?? [:]
                    let apddict : NSDictionary = result!["content"] as! NSDictionary
                    if apddict["contest"] as! String == "Active" {
                        self.btnaddmoney.isEnabled = true
                    }
                    else
                    {
                        self.btnaddmoney.isEnabled = false
                    }
                    //  self.arrMyJTicket = content["contest"] as? [[String : Any]] ?? [[:]]
                    //  self.MainarrMyJTicket = content["contest"] as? [[String : Any]] ?? [[:]]
                    
                    // self.arrMyJTicket = self.MainarrMyJTicket.filter{($0["status"] as! Int) == 0}
                    
                    //print(self.arrMyJTicket)
                    print(content)
                    
                    
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
//extension AddPaymentVC: UNUserNotificationCenterDelegate {
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
//extension AddPaymentVC: PaykunCheckoutDelegate {
//    func onPaymentFailed(_ responce: [AnyHashable : Any]) {
//        print("-----> Payment Failed")
//        print("Data: ", responce)
//        
//        let statusVC = self.storyboard?.instantiateViewController(withIdentifier: "PaymentStatusVC") as! PaymentStatusVC
//        statusVC.isTransactionStatus = false
//        self.navigationController?.pushViewController(statusVC, animated: true)
//    }
//    
//    func onPaymentSucceed(_ responce: [AnyHashable : Any]) {
//        print("-----> Payment Success")
//        print("Data: ", responce)
//        let paymentID = responce["req_id"] as? String ?? ""
//        self.addMoneyAPI(paymentId: paymentID)
//    }
//}

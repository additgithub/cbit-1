import UIKit
import UserNotifications

class PaymentStatusVC: UIViewController {

    @IBOutlet weak var labelWallet: UILabel!
    @IBOutlet weak var labelTransactionStatus:UILabel!
    @IBOutlet weak var imageTransactionStatus: UIImageView!
    @IBOutlet weak var buttonOk: ButtonFill!
    
    var isFromLink = Bool()
    var isTransactionStatus = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // UNUserNotificationCenter.current().delegate =  self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let pbAmount = Define.USERDEFAULT.value(forKey: "PBAmount") as? Double ?? 0.0
        let tbAmount = Define.USERDEFAULT.value(forKey: "SBAmount") as? Double ?? 0.0
        
        let totalAmount = pbAmount + tbAmount
        
        labelWallet.text = "Wallet " + MyModel().getCurrncy(value: totalAmount)
        
        if isTransactionStatus {
            labelTransactionStatus.text = "Transaction Successful."
            labelTransactionStatus.textColor = UIColor.green
            imageTransactionStatus.image = #imageLiteral(resourceName: "ic_validation")
        } else {
            
            labelTransactionStatus.text = "Transaction Failed."
            labelTransactionStatus.textColor = UIColor.red
            imageTransactionStatus.image = #imageLiteral(resourceName: "ic_failed")
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        MyModel().roundCorners(corners: [.allCorners], radius: 5, view: buttonOk)
    }
    
    @IBAction func buttonOK(_ sender: UIButton) {
        let viewConteollers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        print(viewConteollers.count)
        self.navigationController?.popToViewController(viewConteollers[viewConteollers.count - 3], animated: true)
    }
    @IBAction func buttonBack(_ sender: UIButton) {
        let viewConteollers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        self.navigationController?.popToViewController(viewConteollers[viewConteollers.count - 3], animated: true)
    }
}

//MARK: - Notifcation Delegate Method
//extension PaymentStatusVC: UNUserNotificationCenterDelegate {
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

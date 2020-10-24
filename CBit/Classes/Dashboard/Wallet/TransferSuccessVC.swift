import UIKit
import UserNotifications

class TransferSuccessVC: UIViewController {
    //MARK: - Properties
    @IBOutlet weak var imageStatus: UIImageView!
    @IBOutlet weak var labelStatus: UILabel!
    @IBOutlet weak var buttonWallet: UIButton!
    
    //MARK: - Default Method
    override func viewDidLoad() {
        super.viewDidLoad()
        UNUserNotificationCenter.current().delegate = self
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        MyModel().roundCorners(corners: [.allCorners], radius: 5, view: buttonWallet)
    }
    
    //MARK: - Button Method
    @IBAction func buttonWallet(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}

//MARK: - Notifcation Delegate Method
extension TransferSuccessVC: UNUserNotificationCenterDelegate {
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

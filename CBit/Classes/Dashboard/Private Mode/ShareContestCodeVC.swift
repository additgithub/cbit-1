import UIKit
import UserNotifications

class ShareContestCodeVC: UIViewController {
    //MARK: - Properties
    @IBOutlet weak var labelContetCode: UILabel!
    @IBOutlet weak var buttonShare: UIButton!
    
    var strContestCode = String()
    
    //MARK: - Default Method
    override func viewDidLoad() {
        super.viewDidLoad()
      //  UNUserNotificationCenter.current().delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        labelContetCode.text = "Contest Code: \(strContestCode)"
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        buttonShare.layer.cornerRadius = buttonShare.frame.height / 2
        buttonShare.layer.masksToBounds = true
    }
    
    func shareCode(strCode: String) {
        let strShareLink = "\(Define.USERDEFAULT.value(forKey: "UserName") as? String ?? "") invited you to join the private room"
        let strJoinCode = "\(Define.SHARE_URL)\(strCode)"
        let arrShareItem = [strShareLink, strJoinCode]
        let activityViewController = UIActivityViewController(activityItems: arrShareItem,
                                                              applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        present(activityViewController, animated: true, completion: nil)
    }
    
    //MARK: - Button Method
    @IBAction func buttonShareCode(_ sender: Any) {
        shareCode(strCode: strContestCode)
    }
    
    @IBAction func buttonMyContest(_ sender: Any) {
        self.dismiss(animated: true) {
        }
    }
}

//MARK: - Notifcation Delegate Method
//extension ShareContestCodeVC: UNUserNotificationCenterDelegate {
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

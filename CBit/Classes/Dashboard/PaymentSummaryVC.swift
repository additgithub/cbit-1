import UIKit
import UserNotifications

class PaymentSummaryVC: UIViewController {
    //MARK: - Properties.
    @IBOutlet weak var labelWallet: UILabel!
    @IBOutlet weak var buttonContest: UIButton!
    @IBOutlet weak var buttonWallet: ButtonEmpty!
    
    var isFromLink = Bool()
    
    //MARK: - Default Method
    override func viewDidLoad() {
        super.viewDidLoad()
        UNUserNotificationCenter.current().delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        let pbAmount = Define.USERDEFAULT.value(forKey: "PBAmount") as? Double ?? 0.0
        let tbAmount = Define.USERDEFAULT.value(forKey: "SBAmount") as? Double ?? 0.0
        
        let totalAmount = pbAmount + tbAmount
        
        labelWallet.text = "Wallet " + MyModel().getCurrncy(value: totalAmount)
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        MyModel().roundCorners(corners: [.allCorners], radius: 5, view: buttonContest)
    }
    //MARK: - Button Method
    @IBAction func buttonBack(_ sender: UIButton) {
        
        self.navigationController?.popToRootViewController(animated: true)
        
        
    }
    
    @IBAction func buttonWallet(_ sender: UIButton) {
        if isFromLink {
            
            let storyBoard = UIStoryboard(name: "Dashboard", bundle: nil)
            let menuVC = storyBoard.instantiateViewController(withIdentifier: "MenuNC")
            menuVC.modalPresentationStyle = .fullScreen
            self.present(menuVC,
                         animated: true,
                         completion:
                {
            })
            
        } else {
            let walletVC = self.storyboard?.instantiateViewController(withIdentifier: "WalletVC") as! WalletVC
            
            sideMenuController?.setContentViewController(to: walletVC, animated: true, completion: {
                self.navigationController?.popToRootViewController(animated: true)
            })
        }
    }
    
    @IBAction func buttonMyContest(_ sender: UIButton) {
        if isFromLink {
            let storyBoard = UIStoryboard(name: "Dashboard", bundle: nil)
            let menuVC = storyBoard.instantiateViewController(withIdentifier: "MenuNC")
            menuVC.modalPresentationStyle = .fullScreen
            self.present(menuVC,
                         animated: true,
                         completion:
                {
            })
            
        } else {
            let dashBoardVC = self.storyboard?.instantiateViewController(withIdentifier: "DashboardNC")
            
            sideMenuController?.setContentViewController(to: dashBoardVC!, animated: true, completion: {
                self.navigationController?.popToRootViewController(animated: true)
            })
        }
    }
}

//MARK: - Notifcation Delegate Method
extension PaymentSummaryVC: UNUserNotificationCenterDelegate {
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

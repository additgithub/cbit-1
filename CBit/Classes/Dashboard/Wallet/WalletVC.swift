import UIKit
import UserNotifications

class WalletVC: UIViewController {
    //MARK: - Properties
    @IBOutlet weak var labelTotalBalance: UILabel!
    @IBOutlet weak var labelbalance: UILabel!
    @IBOutlet weak var labelWinningBalance: UILabel!
    @IBOutlet weak var buttonAddMoney: UIButton!
    @IBOutlet weak var buttonTransferToWallet: UIButton!
    @IBOutlet weak var buttonTransferToAccount: UIButton!
    @IBOutlet weak var buttonTransferToWalletTwo: UIButton!
    
    
    @IBOutlet weak var btnaddmoney: UIButton!
    
    @IBOutlet weak var btntranfertoaccnt: UIButton!
    
    @IBOutlet weak var lblcc: UILabel!
    //MARK: - Default Method
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleNotification),
                                               name: .paymentUpdated,
                                               object: nil)
        UNUserNotificationCenter.current().delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let pbAmount = "\(Define.USERDEFAULT.value(forKey: "PBAmount")!)"
        guard let amountPB = Double(pbAmount) else {
            return
        }
        labelbalance.text = MyModel().getCurrncy(value: amountPB)
        
        let sbAmount = "\(Define.USERDEFAULT.value(forKey: "SBAmount")!)"
        guard let amountSB = Double(sbAmount) else {
            return
        }
        
        let ccAmount = "\(Define.USERDEFAULT.value(forKey:"ccAmount")!)"
        guard let amountCC = Double(ccAmount) else {
            return
        }
     
        lblcc.text! =  "CC " + MyModel().getNumbers(value:amountCC)
            
            //MyModel().getCurrncy(value: amountCC)
        
        labelWinningBalance.text = MyModel().getCurrncy(value: amountSB)
        
        labelTotalBalance.text = MyModel().getCurrncy(value: (amountPB + amountSB))
        
        
     
       
        let WalletAuth =  "\(String(describing: UserDefaults.standard.value(forKey:"WalletAuth")!))"
        
        if WalletAuth == "0"
        {
            buttonTransferToWallet.isHidden = true
            buttonTransferToWalletTwo.isHidden = true
            btntranfertoaccnt.isHidden = false
            btnaddmoney.isHidden = false
            
            
        }
        else
        {
             buttonTransferToWallet.isHidden = false
             buttonTransferToWalletTwo.isHidden = false
             btntranfertoaccnt.isHidden = true
             btnaddmoney.isHidden = true
        }
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        MyModel().roundCorners(corners: [.bottomLeft], radius: 5, view: buttonAddMoney)
        MyModel().roundCorners(corners: [.bottomRight], radius: 5, view: buttonTransferToWallet)
        MyModel().roundCorners(corners: [.bottomLeft], radius: 5, view: buttonTransferToAccount)
        MyModel().roundCorners(corners: [.bottomRight], radius: 5, view: buttonTransferToWalletTwo)
    }
    
    @objc func handleNotification() {
        viewWillAppear(true)
    }
    
    //MARK: - Button Method
    @IBAction func buttonMenu(_ sender: Any) {
        sideMenuController?.revealMenu()
    }
    @IBAction func buttonAddMoney(_ sender: UIButton) {
        let addMoneyVC = self.storyboard?.instantiateViewController(withIdentifier: "AddPaymentVC") as! AddPaymentVC
        addMoneyVC.isFromTicket = false
        self.navigationController?.pushViewController(addMoneyVC, animated: true)
    }
    
    @IBAction func butonTransferToWallet(_ sender: UIButton) {
        print("Tag: \(sender.tag)")
        
        let transferVC = self.storyboard?.instantiateViewController(withIdentifier: "TransferToWalletVC") as! TransferToWalletVC
         transferVC.transferType = sender.tag
        //  transferVC.transferType = 0
        self.navigationController?.pushViewController(transferVC, animated: true)
    }
    
    @IBAction func buttonTransferToWallet(_ sender: UIButton) {
        let strIsPanVerify = "\(Define.USERDEFAULT.value(forKey: "IsPanVerify")!)"
        
        if strIsPanVerify == "0" {
            
            goToAddPanCard()
            
        } else if strIsPanVerify == "2" {
            
            Alert().showAlert(title: "Alert",
                              message: "KYC Verification Rejected, Add New Details.",
                              viewController: self)
            
        } else if strIsPanVerify == "3" {
            
            Alert().showAlert(title: "Alert",
                              message: "KYC Verification Pending.",
                              viewController: self)
        } else {
            if !MyModel().isConnectedToInternet() {
                
                Alert().showTost(message: Define.ERROR_INTERNET,
                                 viewController: self)
                
            } else {
                
                let redeemVC = self.storyboard?.instantiateViewController(withIdentifier: "RedeemVC") as! RedeemVC
                self.navigationController?.pushViewController(redeemVC, animated: true)
                
            }
        }
    }
    
    @IBAction func buttonPassBook(_ sender: UIButton) {
      
        let passBookVC = self.storyboard?.instantiateViewController(withIdentifier: "PassBookVC") as! PassBookVC
        self.navigationController?.pushViewController(passBookVC, animated: true)
        
    }
    
    
    @IBAction func button_CCPassbook(_ sender: Any) {
        
        let CCpassBookVC = self.storyboard?.instantiateViewController(withIdentifier: "CCPassBookViewController") as! CCPassBookViewController
        self.navigationController?.pushViewController(CCpassBookVC, animated: true)
    }
    
    
}

//MARK: - Notifcation Delegate Method
extension WalletVC: UNUserNotificationCenterDelegate {
    
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
extension WalletVC {
    
    func goToAddPanCard() {
        let alertController = UIAlertController(title: nil,
                                                message: "You need to complete your KYC for redeem process.",
                                                preferredStyle: .alert)
        let buttonOk = UIAlertAction(title: "OK",
                                     style: .default)
        { _ in
            let srotyboard = UIStoryboard(name: "Authentication", bundle: nil)
            let panVC = srotyboard.instantiateViewController(withIdentifier: "KYCVerifycationVC") as! KYCVerifycationVC
            panVC.isFromWallet = true
            panVC.delegate = self
            self.navigationController?.pushViewController(panVC, animated: true)
        }
        let buttonCancel = UIAlertAction(title: "Cancel",
                                         style: .cancel,
                                         handler: nil)
        alertController.addAction(buttonCancel)
        alertController.addAction(buttonOk)
        present(alertController,
                animated: true,
                completion: nil)
        
    }
}

//MARK: - KYC Delegate Method
extension WalletVC: KYCVerifycationDelegate {
    func processAdded() {
//        Alert().showAlert(title: "CBit",
//                          message: "Your PAN card added successfully, Wait for the verification.",
//                          viewController: self)
    }
}

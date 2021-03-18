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
    
    @IBOutlet weak var vw_jticketasset: UIView!
    
    @IBOutlet weak var lblcc: UILabel!
    
    
    @IBOutlet weak var lbl_redeem_cc: UILabel!
    @IBOutlet weak var lbl_applied_cc: UILabel!
    @IBOutlet weak var tbl_redeem: UITableView!
    
     private var isFirstTime = Bool()
    private var arrjtickets = [[String: Any]]()
    
    
    private var arrMyJTicket = [[String: Any]]()
    
    var MainarrMyJTicket = [[String: Any]]()
    var MyJTicketDateArr = [[String: Any]]()
    var MyJTicketNameArr = [[String: Any]]()
    var arrApproachList = [[String:Any]]()
    
    var arrAssetList = [GetAppliedReedeemedList]()
    
    var isasc = true
    private var id = 0
    private var jticketid = 0
    
    var Start = 0
    var Limit = 10
    var ismoredata = false
    
    
    //MARK: - Default Method
    override func viewDidLoad() {
        super.viewDidLoad()
        isFirstTime = true
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleNotification),
                                               name: .paymentUpdated,
                                               object: nil)
        UNUserNotificationCenter.current().delegate = self
        
        getUserJticket()
        CallJAssetData()
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
    
    @IBAction func btn_WALLATE_J_ASSET(_ sender: Any) {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.tag = 100
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        vw_jticketasset.center = view.center
        vw_jticketasset.alpha = 1
        vw_jticketasset.transform = CGAffineTransform(scaleX: 0.8, y: 1.2)
        
        self.view.addSubview(vw_jticketasset)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [],  animations: {
            self.vw_jticketasset.transform = .identity
        })
    }
    
    @IBAction func btn_CLOSE(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0, options: [], animations: {
            //use if you wish to darken the background
            //self.viewDim.alpha = 0
            self.vw_jticketasset.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        }) { (success) in
            for view in self.view.subviews {
                if let viewWithTag = view.viewWithTag(100) {
                    viewWithTag.removeFromSuperview()
                }
            }
            self.vw_jticketasset.removeFromSuperview()
        }
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

extension WalletVC
{
   
    func getUserJticket()  {
        if isFirstTime {
            Loading().showLoading(viewController: self)
        }
        let strURL = Define.APP_URL + Define.getUserJTicket
        print("URL: \(strURL)")
        
        let parameter: [String: Any] = [
            "status":"0",
            "start":Start,
            "limit":"",
            "filterAscDesc":"",
            "filterTicketName":"",
            "filterByDate":"",
            "sortByApproch":""
        ]
        
        SwiftAPI().postMethodSecure(stringURL: strURL,
                                    parameters: parameter,
                                    header: Define.USERDEFAULT.value(forKey: "AccessToken") as? String,
                                    auther: Define.USERDEFAULT.value(forKey: "UserID") as? String)
        { (result, error) in
            if error != nil {
                if self.isFirstTime {
                    self.isFirstTime = false
                    Loading().hideLoading(viewController: self)
                }
                print("Error: \(error!)")
                self.getUserJticket()
            } else {
                if self.isFirstTime {
                    
                    self.isFirstTime = false
                    Loading().hideLoading(viewController: self)
                    
                }
                print("Result: \(result!)")
                
                let status = result!["statusCode"] as? Int ?? 0
                if status == 200 {
                    
                    let content = result!["content"] as? [String: Any] ?? [:]
                    let apddict : NSDictionary = result!["content"] as! NSDictionary
                    
                    //  self.arrMyJTicket = content["contest"] as? [[String : Any]] ?? [[:]]
                    //  self.MainarrMyJTicket = content["contest"] as? [[String : Any]] ?? [[:]]
                    
                    // self.arrMyJTicket = self.MainarrMyJTicket.filter{($0["status"] as! Int) == 0}
                    
                    //print(self.arrMyJTicket)
                    print(content)
                    
                    
                    let arr =  content["contest"] as! [[String : Any]]
                    if arr.count > 0 {
                        self.arrMyJTicket.append(contentsOf: arr)
                        self.MainarrMyJTicket.append(contentsOf: arr)
                        self.ismoredata = true
                        self.Start = self.Start + 10
                        self.Limit =  10
                    }
                    else
                    {
                        self.ismoredata = false
                    }
                    
                    
                    
                    let APD = "\(apddict.value(forKey:"ADP") as? String ?? "0.00")"
                    
                    guard let amountPB = Double(APD) else {
                        return
                    }
                    
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
    
    func CallJAssetData()  {
        if isFirstTime {
            Loading().showLoading(viewController: self)
        }
        let strURL = Define.APP_URL + Define.getJAssets
        print("URL: \(strURL)")
        
        let parameter: [String: Any] = [
            :
        ]
        
        SwiftAPI().postMethodSecure(stringURL: strURL,
                                    parameters: parameter,
                                    header: Define.USERDEFAULT.value(forKey: "AccessToken") as? String,
                                    auther: Define.USERDEFAULT.value(forKey: "UserID") as? String)
        { (result, error) in
            if error != nil {
                if self.isFirstTime {
                    self.isFirstTime = false
                    Loading().hideLoading(viewController: self)
                }
                print("Error: \(error!)")
                self.getUserJticket()
            } else {
                if self.isFirstTime {
                    
                    self.isFirstTime = false
                    Loading().hideLoading(viewController: self)
                    
                }
                print("Result: \(result!)")
                
                let status = result!["statusCode"] as? Int ?? 0
                if status == 200 {
                    
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: result!, options: .prettyPrinted)
                        // here "jsonData" is the dictionary encoded in JSON data
                        
                        let allAssetListModel = try? JSONDecoder().decode(JAssetsListModel.self, from: jsonData)
                        
                        self.arrAssetList = (allAssetListModel?.content?.getAppliedReedeemedList)!
                        let contact = allAssetListModel?.content!
                        self.lbl_applied_cc.text = "CC \(contact!.appliedCC!)"
                        self.lbl_redeem_cc.text = "CC \(contact!.redemedCC!)"
                        
                        self.tbl_redeem.reloadData()
                       
                    } catch {
                        print(error.localizedDescription)
                    }
                    
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

extension WalletVC : UITableViewDelegate , UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrAssetList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! WalletCell
        
        cell.lbl_ticket_name.text = arrAssetList[indexPath.row].name ?? ""
        cell.lbl_redeemcc.text = "CC \(arrAssetList[indexPath.row].redemedCC!)"
        cell.lbl_appliedcc.text = "CC \(arrAssetList[indexPath.row].appliedCC!)"
        
        return cell
        
    }
    
    
}

//MARK: - Alert Contollert
extension WalletVC {
    func retry() {
        let alertController = UIAlertController(title: Define.ERROR_TITLE,
                                                message: Define.ERROR_SERVER,
                                                preferredStyle: .alert)
        let buttonRetry = UIAlertAction(title: "Retry",
                                        style: .default)
        { _ in
            self.getUserJticket()
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


class WalletCell : UITableViewCell
{
    
    @IBOutlet weak var lbl_ticket_name: UILabel!
    @IBOutlet weak var lbl_redeemcc: UILabel!
    @IBOutlet weak var lbl_appliedcc: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
}


import Foundation

// MARK: - JAssetsListModel
struct JAssetsListModel: Codable {
    let message: String?
    let content: ContentData?
    let statusCode: Int?
}

// MARK: - Content
struct ContentData: Codable {
    let appliedCC, redemedCC: String?
    let getAppliedReedeemedList: [GetAppliedReedeemedList]?

    enum CodingKeys: String, CodingKey {
        case appliedCC = "AppliedCC"
        case redemedCC = "RedemedCC"
        case getAppliedReedeemedList
    }
}

// MARK: - GetAppliedReedeemedList
struct GetAppliedReedeemedList: Codable {
    let appliedCC, redemedCC : String?
    let id : Int?
    let name: String?

    enum CodingKeys: String, CodingKey {
        case appliedCC = "AppliedCC"
        case redemedCC = "RedemedCC"
        case id, name
    }
}

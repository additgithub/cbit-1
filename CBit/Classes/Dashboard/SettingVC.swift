import UIKit
import UserNotifications
import M13Checkbox
class SettingVC: UIViewController {
    //MARK: - Properties
    @IBOutlet weak var switchNotification: UISwitch!
    @IBOutlet weak var labelVarsion: UILabel!
    @IBOutlet weak var tblticket: UITableView!
    @IBOutlet weak var chkall: M13Checkbox!
    
    var TicketArr = [[String: Any]]()
    //var SavedIndex = [String]()
    //MARK: - Default Method
    override func viewDidLoad() {
        super.viewDidLoad()
        UNUserNotificationCenter.current().delegate = self
        if Define.USERDEFAULT.bool(forKey: "SetNotification") {
            switchNotification.isOn = true
        } else {
            switchNotification.isOn = false
        }
        
        self.setSwitchBackground(isOn: Define.USERDEFAULT.bool(forKey: "SetNotification"))
        
        chkall.boxType = .square
        chkall.tintColor = #colorLiteral(red: 0, green: 0.2535815537, blue: 0, alpha: 1)
        chkall.secondaryTintColor = #colorLiteral(red: 0.2176683843, green: 0.8194433451, blue: 0.2584097683, alpha: 1)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        labelVarsion.text = "Version: \(Define.APP_VERSION)"
        getdefaultJoinTicket()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        switchNotification.layer.cornerRadius = switchNotification.frame.height / 2
        switchNotification.layer.masksToBounds = true
    }
    func SetDetails()  {
        //        for (index,dict) in TicketArr.enumerated() {
        //            let isSelected = dict["isSelected"] as? Bool ?? false
        //            if isSelected {
        //                SavedIndex.append(String(index))
        //            }
        //            else
        //            {
        //                SavedIndex.append(String(""))
        //            }
        //        }
        self.tblticket.reloadData()
    }
    //MARK: - Switch Method
    @IBAction func switchNotification(_ sender: UISwitch) {
        setNotificationAPI(isSet: sender.isOn)
    }
    
    //MARK: - Button Method
    @IBAction func buttonMenu(_ sender: Any) {
        sideMenuController?.revealMenu()
    }
    @IBAction func CheckAll_click(_ sender: M13Checkbox) {
        print("TAG:",sender.tag)
        switch sender.checkState {
        case .unchecked:
            print("UnChecked")
            for (index,dict) in TicketArr.enumerated() {
                //  let isSelected = dict["isSelected"] as? Bool ?? false
                TicketArr[index]["isSelected"] = false
            }
            break
        case .checked:
            print("Checked")
            for (index,dict) in TicketArr.enumerated() {
                //  let isSelected = dict["isSelected"] as? Bool ?? false
                TicketArr[index]["isSelected"] = true
            }
            break
        case .mixed:
            print("Mixed")
            break
        }
        tblticket.reloadData()
    }
    @IBAction func savechanges_click(_ sender: UIButton) {
        setUserDefaultTicketPrice()
    }
    
    func setSwitchBackground(isOn: Bool) {
        if isOn {
            switchNotification.backgroundColor = #colorLiteral(red: 0.1019607843, green: 0.3098039216, blue: 0.3647058824, alpha: 1)
        } else {
            switchNotification.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        }
    }
}

//MARK: - API
extension SettingVC {
    func getdefaultJoinTicket() {
        Loading().showLoading(viewController: self)
        let parameter: [String: Any] = [:]
        let strURL = Define.APP_URL + Define.getdefaultJoinTicket
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
                
                self.getdefaultJoinTicket()
            } else {
                Loading().hideLoading(viewController: self)
                print("Result: \(result!)")
                let status = result!["statusCode"] as? Int ?? 0
                if status == 200 {
                    let arr =  result!["content"] as! [String : Any]
                    self.TicketArr = arr["contest"] as? [[String : Any]] ?? []
                    self.SetDetails()
                    
                } else if status == 401 {
                    Define.APPDELEGATE.handleLogout()
                } else {
                    Alert().showAlert(title: "Error",
                                      message: result!["message"] as?  String ?? "No Message.",
                                      viewController: self)
                }
            }
        }
    }
    
    func setUserDefaultTicketPrice() {
        Loading().showLoading(viewController: self)
        var prices = String()
        for (index,dict) in TicketArr.enumerated() {
            let isSelected = dict["isSelected"] as? Bool ?? false
            let price = dict["price"]
            if isSelected {
                prices.append("\(price ?? ""),")
            }
        }
        if prices.count > 0 {
            prices.removeLast(1)
        }
        
        let parameter: [String: Any] = ["priceId": prices]
        let strURL = Define.APP_URL + Define.setUserDefaultTicketPrice
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
                
                self.setUserDefaultTicketPrice()
            } else {
                Loading().hideLoading(viewController: self)
                print("Result: \(result!)")
                let status = result!["statusCode"] as? Int ?? 0
                if status == 200 {
                    Alert().showAlert(title: "",
                                      message: "Saved Successfully",
                                      viewController: self)
                } else if status == 401 {
                    Define.APPDELEGATE.handleLogout()
                } else {
                    Alert().showAlert(title: "Error",
                                      message: result!["message"] as?  String ?? "No Message.",
                                      viewController: self)
                }
            }
        }
    }
    func setNotificationAPI(isSet: Bool) {
        Loading().showLoading(viewController: self)
        let parameter: [String: Any] = ["setNotification": isSet ? "1" : "0"]
        let strURL = Define.APP_URL + Define.API_SETNOTIFICATION
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
                self.switchNotification.isOn = !self.switchNotification.isOn
                print("Error: \(error!.localizedDescription)")
                self.retry()
            } else {
                Loading().hideLoading(viewController: self)
                print("Result: \(result!)")
                let status = result!["statusCode"] as? Int ?? 0
                if status == 200 {
                    let dictData = result!["content"] as! [String: Any]
                    let setNotification = dictData["setNotification"] as? Bool ?? false
                    Define.USERDEFAULT.set(setNotification, forKey: "SetNotification")
                    
                    if Define.USERDEFAULT.bool(forKey: "SetNotification") {
                        self.switchNotification.isOn = true
                    } else {
                        self.switchNotification.isOn = false
                    }
                    self.setSwitchBackground(isOn: setNotification)
                } else if status == 401 {
                    Define.APPDELEGATE.handleLogout()
                } else {
                    self.switchNotification.isOn = !self.switchNotification.isOn
                    Alert().showAlert(title: "Error",
                                      message: result!["message"] as? String ?? Define.ERROR_SERVER,
                                      viewController: self)
                }
            }
        }
    }
}

//MARK: - Alert Contollert
extension SettingVC {
    func retry() {
        let alertController = UIAlertController(title: Define.ERROR_TITLE,
                                                message: Define.ERROR_SERVER,
                                                preferredStyle: .alert)
        let buttonRetry = UIAlertAction(title: "Retry",
                                        style: .default)
        { _ in
            self.setNotificationAPI(isSet: !self.switchNotification.isOn)
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

//MARK: - Notifcation Delegate Method
extension SettingVC: UNUserNotificationCenterDelegate {
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


//MARK: - TableView Delegate
extension SettingVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TicketArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PopUpCell", for: indexPath) as! PopUpCell
        //                    cell.chkvw?.markType = .checkmark
        cell.chkvw?.boxType = .square
        cell.chkvw?.tintColor = #colorLiteral(red: 0, green: 0.2535815537, blue: 0, alpha: 1)
        cell.chkvw?.secondaryTintColor = #colorLiteral(red: 0.2176683843, green: 0.8194433451, blue: 0.2584097683, alpha: 1)
        cell.chkvw?.tag = indexPath.row
        cell.chkvw?.addTarget(self, action: #selector(PassBookVC.checkboxValueChangedPopUp(_:)), for: .valueChanged)
        
        cell.lbltitle.text = "₹\(TicketArr[indexPath.row]["price"] ?? "")"
        
        
        
        //                if SavedIndex.contains(String(indexPath.row)) {
        //                    cell.chkvw?.checkState = .checked
        //                }
        //                else
        //                {
        //                    cell.chkvw?.checkState = .unchecked
        //                }
        
        let isSelected = TicketArr[indexPath.row]["isSelected"] as? Bool ?? false
        if isSelected {
            cell.chkvw?.checkState = .checked
        }
        else
        {
            cell.chkvw?.checkState = .unchecked
        }
        
        cell.selectionStyle = .none
        return cell
        
    }
    
    @IBAction func checkboxValueChangedPopUp(_ sender: M13Checkbox) {
        print("TAG:",sender.tag)
        switch sender.checkState {
        case .unchecked:
            print("UnChecked")
            //  let isSelected = dict["isSelected"] as? Bool ?? false
            TicketArr[sender.tag]["isSelected"] = false
            break
        case .checked:
            print("Checked")
            TicketArr[sender.tag]["isSelected"] = true
            break
        case .mixed:
            print("Mixed")
            
            break
        }
        tblticket.reloadData()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

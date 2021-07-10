import UIKit
import UserNotifications
import M13Checkbox
import DropDown

class PackegaListVC: UIViewController {
    //MARK: - Properties.
    @IBOutlet weak var tablePackageList: UITableView!
    @IBOutlet weak var viewNoData: UIView!
    @IBOutlet var txtgametime: UITextField!
    @IBOutlet var txtvalidity: UITextField!
    @IBOutlet var chkall: M13Checkbox!
    
    @IBOutlet var vwpopup: UIView!
    @IBOutlet var lblgametime: UILabel!
    @IBOutlet var lblvalidity: UILabel!
    @IBOutlet var lblentryfee: UILabel!
    @IBOutlet var lblunutilizeblnc: UILabel!
    @IBOutlet var lblwithdrawableblnc: UILabel!
    @IBOutlet var lbltotal: UILabel!
    @IBOutlet var lblpackageprice: UILabel!
    
    @IBOutlet weak var labelPurchasedAmount: UILabel!
       @IBOutlet weak var labelPBAmount: UILabel!
       @IBOutlet weak var labelPay: UILabel!
    @IBOutlet var vwpayheight: NSLayoutConstraint!
    
    
    var arrPackageList = [[String: Any]]()
     var TimeList = [[String: Any]]()
     var ValidityList = [[String: Any]]()
    var SavedIndex = [String]()
    
    private var isGetPackageList = Bool()
    private var isBuyPackage = Bool()
    //MARK: - Default Method
    override func viewDidLoad() {
        super.viewDidLoad()
        tablePackageList.rowHeight = UITableView.automaticDimension
        tablePackageList.tableFooterView = UIView()
      //  UNUserNotificationCenter.current().delegate = self
           getPackageList()
        vwpayheight.constant = 0
                                    chkall?.markType = .checkmark
                                    chkall?.boxType = .square
                                    chkall?.tintColor = #colorLiteral(red: 0.1019607843, green: 0.3098039216, blue: 0.3647058824, alpha: 1)
                                    chkall?.secondaryTintColor = #colorLiteral(red: 0.1019607843, green: 0.3098039216, blue: 0.3647058824, alpha: 1)
                 vwpopup.isHidden = true
        
        GetTime()
        GetValidity()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
    }
    
    func SetData()  {
        lblgametime.text = "Game Time : \(txtgametime.text ?? "00")"
        lblvalidity.text = "\(txtvalidity.text ?? "00") days"
        
        var entryfee = "Entry Fee\n"
        var packageprice = "Package Price\n"
        
        for i in 0..<arrPackageList.count {
                                 //YOUR LOGIC....
                                 if SavedIndex.contains(String(i)) {
                                    entryfee.append("₹\(arrPackageList[i]["TicketPrice"]!)\n")
                                    packageprice.append("₹\(arrPackageList[i]["amount"]!)\n")
                                 }
                             }
        lblentryfee.text = entryfee
        lblpackageprice.text = packageprice
        lbltotal.text = "Total : \(labelPurchasedAmount.text ?? "0")"
    }
    var WithdrawableAmt:Double = 0
    
    func CalcAmt()  {
        WithdrawableAmt = 0
        for i in 0..<arrPackageList.count {
            //YOUR LOGIC....
            if SavedIndex.contains(String(i)) {
                WithdrawableAmt =  WithdrawableAmt + Double("\(arrPackageList[i]["amount"]!)")!
            }
        }
        
        lblwithdrawableblnc.text = "\("From withdrawable balance: ₹\(String(format: "%.2f", WithdrawableAmt))")"
        labelPurchasedAmount.text = "₹\(String(format: "%.2f", WithdrawableAmt))"
        
        if SavedIndex.count > 0 {
            vwpayheight.constant = 50
        }
        else
        {
            vwpayheight.constant = 0
        }
        
        let pbAmount = Define.USERDEFAULT.value(forKey: "PBAmount") as? Double ?? 0.0
              let sbAmount = Define.USERDEFAULT.value(forKey: "SBAmount") as? Double ?? 0.0
              
              let totalAmount = pbAmount + sbAmount
              
              labelPBAmount.text = MyModel().getCurrncy(value: totalAmount)
              
              lblunutilizeblnc.text = "From unutilized balance :\(MyModel().getCurrncy(value: totalAmount))"
    }
    
    
    @IBAction func chkall_click(_ sender: M13Checkbox) {
         SavedIndex = []
        
        switch sender.checkState {
        case .unchecked:
            print("UnChecked")
                        
                             
        case .checked:
            print("Checked")
            
                    for i in 0..<arrPackageList.count {
                        //YOUR LOGIC....
                        SavedIndex.append(String(i))
                    }
        case .mixed:
             print("Mixed")
        }
        tablePackageList.reloadData()
         CalcAmt()
    }
    
    @IBAction func gametime_click(_ sender: UIButton) {
        
        let  dropDown1 = DropDown()
                
              dropDown1.dataSource = self.TimeList.compactMap{$0["StartTime"] as? String}
              
              dropDown1.anchorView =  txtgametime
              
                dropDown1.selectionAction = {
                  
                  [unowned self] (index: Int, item: String) in
                  print("Selected item: \(item) at index: \(index)")
                 
//                  self.cityid =  self.TimeList[index]["CityID"] as? Int ?? 0
//                  print(self.cityid)
                
                  self.txtgametime.text  = item
                   self.getPackageList()
              }
              dropDown1.show()
    }
    
    @IBAction func validity_click(_ sender: UIButton) {
        
        let  dropDown2 = DropDown()
                        
        dropDown2.dataSource = self.ValidityList.compactMap{"\($0["validity"] as? Int ?? 0)"}
                      
                      dropDown2.anchorView =  txtvalidity
                      
                        dropDown2.selectionAction = {
                          
                          [unowned self] (index: Int, item: String) in
                          print("Selected item: \(item) at index: \(index)")
                         
        //                  self.cityid =  self.ValidityList[index]["CityID"] as? Int ?? 0
        //                  print(self.cityid)
                            
                          self.txtvalidity.text  = item
                            self.getPackageList()
                          
                      }
                      dropDown2.show()
    }
    
    
    @IBAction func buttonMenu(_ sender: Any) {
        sideMenuController?.revealMenu()
        //self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonHowToPLay(_ sender: Any) {
        let gameInfo = GamePlayInfo.instanceFromNib() as! GamePlayInfo
        gameInfo.frame = view.bounds
        view.addSubview(gameInfo)
    }
    
    
    @IBAction func buy_click(_ sender: UIButton) {
        CalcAmt()
        SetData()
        vwpopup.isHidden = false
        

    }
    
    @IBAction func ok_click(_ sender: UIButton) {
                var Packageid = String()
                if SavedIndex.count > 0 {
                         for i in 0..<arrPackageList.count {
                                    //YOUR LOGIC....
                                    if SavedIndex.contains(String(i)) {
                                        Packageid.append("\(arrPackageList[i]["id"] ?? "0"),")
        
                                    }
                                }
                     Packageid = String(Packageid.dropLast(1))
                    showConformationDialog(strPackageID: Packageid, index: 0)
                      }
                      else
                      {
                          Alert().showTost(message: "Select Package", viewController: self)
                      }
    }
    @IBAction func cancel_click(_ sender: UIButton) {
        vwpopup.isHidden = true
    }
    @IBAction func clear_click(_ sender: UIButton) {
      ClearData()
    getPackageList()
    }
    
    func ClearData()  {
        self.SavedIndex = []
              self.tablePackageList.reloadData()
              self.CalcAmt()
              self.vwpopup.isHidden = true
              txtvalidity.text = ""
              txtgametime.text = ""
        chkall.checkState = .unchecked
    }
    
}



//MARK: - TableView Delegate Method
extension PackegaListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrPackageList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PackageListCell") as! PackageListCell
        
       // cell.labelPercentage.text = "\(arrPackageList[indexPath.row]["commission"]!)%  commission on winning amount"
        cell.labelPackagePrice.text = "₹\(arrPackageList[indexPath.row]["amount"]!)"
        cell.labelValidity.text = "₹\(arrPackageList[indexPath.row]["TicketPrice"]!)"
        
        cell.chkcell?.markType = .checkmark
                          cell.chkcell?.boxType = .square
                          cell.chkcell?.tintColor = #colorLiteral(red: 0.1019607843, green: 0.3098039216, blue: 0.3647058824, alpha: 1)
                          cell.chkcell?.secondaryTintColor = #colorLiteral(red: 0.1019607843, green: 0.3098039216, blue: 0.3647058824, alpha: 1)
                          cell.chkcell?.tag = indexPath.row
                          cell.chkcell?.addTarget(self, action: #selector(PackegaListVC.checkboxValueChangedPopUp(_:)), for: .valueChanged)
        
        if SavedIndex.contains(String(indexPath.row)) {
            cell.chkcell?.checkState = .checked
        }
        else
        {
            cell.chkcell?.checkState = .unchecked
        }
        
        
//        cell.buttonBuy.addTarget(self,
//                                 action: #selector(buttonBuy(_:)),
//                                 for: .touchUpInside)
//        cell.buttonBuy.tag = indexPath.row
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK: - Table Button Method
    
    @IBAction func checkboxValueChangedPopUp(_ sender: M13Checkbox) {
        print("TAG:",sender.tag)
        switch sender.checkState {
                 case .unchecked:
                    print("UnChecked")
                 
                        if SavedIndex.contains((String(sender.tag))) {
                            let index = SavedIndex.firstIndex(of: (String(sender.tag)))!
                            SavedIndex.remove(at: index)
                        }
                    
                     break
                 case .checked:
                     print("Checked")
                  
                    SavedIndex.append(String(sender.tag))
                                        
                     break
                 case .mixed:
                     print("Mixed")
                     
                     break
                 }
        CalcAmt()
    }
    
    @objc func buttonBuy(_ sender: UIButton) {
        let index = sender.tag
        print("=> \(arrPackageList[index])")
        let strID = "\(arrPackageList[index]["id"]!)"
        showConformationDialog(strPackageID: strID, index: index)
    }
}

//MARK: - Notifcation Delegate Method
//extension PackegaListVC: UNUserNotificationCenterDelegate {
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
extension PackegaListVC {
    func getPackageList() {
        Loading().showLoading(viewController: self)
        let strURL = Define.APP_URL + Define.API_GET_PACKAGE
        print("URL: \(strURL)")
        self.SavedIndex = []
                   self.tablePackageList.reloadData()
                   self.CalcAmt()
                   self.vwpopup.isHidden = true
        var validity = String()
             var time = String()
             if txtvalidity.text == "" {
                 validity = "0"
             }
             else
             {
                 validity = txtvalidity.text!
             }
             
             if txtgametime.text == "" {
                       time = "0"
                   }
                   else
                   {
                     time = txtgametime.text!
                   }
             
             
             let parameter: [String: Any] = [
                                             "StartTime":time,
                                             "validity":validity
    ]
        SwiftAPI().postMethodSecure(stringURL: strURL,
                                    parameters: parameter,
                                    header: Define.USERDEFAULT.value(forKey: "AccessToken") as? String,
                                    auther: Define.USERDEFAULT.value(forKey: "UserID") as? String)
        { (result, error) in
            if error != nil {
                Loading().hideLoading(viewController: self)
                print("Error: \(error!.localizedDescription)")
                self.isBuyPackage = false
                self.isGetPackageList = true
                //self.retry(strId: nil)
                self.getPackageList()
            } else {
                Loading().hideLoading(viewController: self)
                print("Result: \(result!)")
                let status = result!["statusCode"] as? Int ?? 0
                if status == 200 {
                    self.arrPackageList = result!["content"] as! [[String: Any]]
                    if self.arrPackageList.count == 0 {
                        self.viewNoData.isHidden = false
                        self.tablePackageList.reloadData()
                    } else {
                        self.viewNoData.isHidden = true
                        self.tablePackageList.reloadData()
                    }
                    
                } else if status == 401 {
                    Define.APPDELEGATE.handleLogout()
                } else {
                    Alert().showAlert(title: "Alert",
                                      message: result!["message"] as? String  ?? Define.ERROR_SERVER,
                                      viewController: self)
                }
            }
        }
    }
    
       func GetTime()
        {
              Loading().showLoading(viewController: self)
                  
                  let strURL = Define.APP_URL + Define.CONTEST_TIME
                 // print("Parameter: \(parameter)\nURL: \(strURL)")
                  
                  //let jsonString = MyModel().getJSONString(object: parameter)
                  let encriptString = MyModel().encrypting(strData:"", strKey: Define.KEY)
                  let strbase64 = encriptString.toBase64()
                  
//                  SwiftAPI().getMethodSecure(stringURL: strURL,
//                                              parameters: ["data":strbase64!],
//                                              header: Define.USERDEFAULT.value(forKey: "AccessToken") as? String,
//                                              auther: Define.USERDEFAULT.value(forKey: "UserID") as? String)
                    SwiftAPI().postMethodSecure(stringURL: strURL,
                    parameters: ["data":strbase64!],
                    header: Define.USERDEFAULT.value(forKey: "AccessToken") as? String,
                                           auther: Define.USERDEFAULT.value(forKey: "UserID") as? String)
                  { (result, error) in
                      if error != nil {
                          Loading().hideLoading(viewController: self)
                          print("Error: \(error!.localizedDescription)")
                      //  self.retry(strMsg: "")
                      } else {
                          Loading().hideLoading(viewController: self)
                          print("Result: \(result!)")
                          let status = result!["statusCode"] as? Int ?? 0
                          if status == 200 {
                              let dictData = result!["content"] as?  [[String: Any]] ?? []
                              
                            self.TimeList = dictData
                          
                            
                          } else if status == 401 {
                              Define.APPDELEGATE.handleLogout()
                          } else {
                              Alert().showAlert(title: "Alert",
                                                message: result!["message"] as? String  ?? Define.ERROR_SERVER,
                                                viewController: self)
                          }
                      }
                  }
              }
    
           func GetValidity()
            {
                  Loading().showLoading(viewController: self)
                      
                      let strURL = Define.APP_URL + Define.CONTEST_DAYS
                     // print("Parameter: \(parameter)\nURL: \(strURL)")
                      
                      //let jsonString = MyModel().getJSONString(object: parameter)
                      let encriptString = MyModel().encrypting(strData:"", strKey: Define.KEY)
                      let strbase64 = encriptString.toBase64()
                      
    //                  SwiftAPI().getMethodSecure(stringURL: strURL,
    //                                              parameters: ["data":strbase64!],
    //                                              header: Define.USERDEFAULT.value(forKey: "AccessToken") as? String,
    //                                              auther: Define.USERDEFAULT.value(forKey: "UserID") as? String)
                        SwiftAPI().postMethodSecure(stringURL: strURL,
                        parameters: ["data":strbase64!],
                        header: Define.USERDEFAULT.value(forKey: "AccessToken") as? String,
                        auther: Define.USERDEFAULT.value(forKey: "UserID") as? String)
                      { (result, error) in
                          if error != nil {
                              Loading().hideLoading(viewController: self)
                              print("Error: \(error!.localizedDescription)")
                          //  self.retry(strMsg: "")
                          } else {
                              Loading().hideLoading(viewController: self)
                              print("Result: \(result!)")
                              let status = result!["statusCode"] as? Int ?? 0
                              if status == 200 {
                                let dictData = result!["content"] as?  [[String: Any]] ?? []
                                  
                                self.ValidityList = dictData
                              
                                
                              } else if status == 401 {
                                  Define.APPDELEGATE.handleLogout()
                              } else {
                                  Alert().showAlert(title: "Alert",
                                                    message: result!["message"] as? String  ?? Define.ERROR_SERVER,
                                                    viewController: self)
                              }
                          }
                      }
                  }
    
    
    func buyPackage(strPackageID: String) {
        Loading().showLoading(viewController: self)
        let parameter: [String: Any] = ["packageId": strPackageID]
        let strURL = Define.APP_URL + Define.API_BUY_PACKAGE
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
                print("Error: \(error!.localizedDescription)")
                self.isBuyPackage = true
                self.isGetPackageList = false
                self.buyPackage(strPackageID: strPackageID)
            } else {
                Loading().hideLoading(viewController: self)
                print("Result: \(result!)")
                let status = result!["statusCode"] as? Int ?? 0
                if status == 200 {
                    
                    Alert().showTost(message: "Congratulations, Commission is now active under your account.", viewController: self)
                    let dictData = result!["content"] as! [String: Any]
                    
                    Define.USERDEFAULT.set(dictData["pbAmount"]!, forKey: "PBAmount")
                    Define.USERDEFAULT.set(dictData["sbAmount"]!, forKey: "SBAmount")
                    Define.USERDEFAULT.set(dictData["tbAmount"]!, forKey: "TBAmount")
                    
                    self.getPackageList()
                    
                } else if status == 401 {
                    Define.APPDELEGATE.handleLogout()
                } else {
                    Alert().showAlert(title: "Alert",
                                      message: result!["message"] as? String  ?? Define.ERROR_SERVER,
                                      viewController: self)
                }
            }
        }
    }
}

//MARK: - Alert Contollert
extension PackegaListVC {
    func retry(strId: String?) {
        let alertController = UIAlertController(title: Define.ERROR_TITLE,
                                                message: Define.ERROR_SERVER,
                                                preferredStyle: .alert)
        let buttonRetry = UIAlertAction(title: "Retry",
                                        style: .default)
        { _ in
            if self.isGetPackageList {
                self.getPackageList()
            } else if self.isBuyPackage {
                self.buyPackage(strPackageID: strId!)
            }
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
    
    func showConformationDialog(strPackageID: String, index: Int) {
        let alertContoller = UIAlertController(title: "Purchase Package",
                                               message: "Are you sure to want purchase this package?",
                                               preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel)
        let buyAction = UIAlertAction(title: "Buy",
                                      style: .default)
        { _ in
          //  self.checkBalance(strPackageID: strPackageID, index: index)
            self.SavedIndex = []
            self.tablePackageList.reloadData()
            self.CalcAmt()
            self.vwpopup.isHidden = true
            self.buyPackage(strPackageID: strPackageID)
        }
        
        alertContoller.addAction(cancelAction)
        alertContoller.addAction(buyAction)
        
        self.present(alertContoller, animated: true, completion: nil)
    }
    
    func checkBalance(strPackageID: String, index: Int) {
        let amount = arrPackageList[index]["amount"] as? Double ?? 0.0
        if !MyModel().checkAmount(amount: amount) {
            let pbAmount = Define.USERDEFAULT.value(forKey: "PBAmount") as? Double ?? 0.0
            let sbAmount = Define.USERDEFAULT.value(forKey: "SBAmount") as? Double ?? 0.0
            
            let cutUtilized = amount - (pbAmount + sbAmount)
            
            let paymentVC = self.storyboard?.instantiateViewController(withIdentifier: "AddPaymentVC") as! AddPaymentVC
            paymentVC.isFromTicket = true
            paymentVC.addAmount = cutUtilized
            paymentVC.isFromLink = false
            self.navigationController?.pushViewController(paymentVC, animated: true)
        } else {
            buyPackage(strPackageID: strPackageID)
        }
    }
}


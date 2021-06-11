//
//  EasyJoinVC.swift
//  CBit
//
//  Created by Nirmal Bodar on 28/05/21.
//  Copyright © 2021 Bhavik Kothari. All rights reserved.
//

import UIKit
import M13Checkbox
import DropDown

class EasyJoinVC: UIViewController {
    
    @IBOutlet weak var chkalltime: M13Checkbox!
    @IBOutlet weak var chkallticket: M13Checkbox!
    
    @IBOutlet weak var tbltime: UITableView!
    @IBOutlet weak var tblticket: UITableView!
    
    @IBOutlet weak var btnsortby: UIButton!
    
    //View Amount
    @IBOutlet weak var viewAmountMain: UIView!
    @IBOutlet weak var viewAmount: UIView!
    @IBOutlet weak var labelUtilizedbalance: UILabel!
    @IBOutlet weak var labelwidrawableBalance: UILabel!
    @IBOutlet weak var labelTotalBalance: UILabel!
    @IBOutlet weak var buttonAmountOk: UIButton!
    @IBOutlet weak var buttonAmountCancel: UIButton!
    
    @IBOutlet weak var labelPurchasedAmount: UILabel!
    @IBOutlet weak var labelPBAmount: UILabel!
    @IBOutlet weak var buttonPay: UIButton!
    @IBOutlet weak var labelPay: UILabel!
    
    // var JoinArr = [[String: Any]]()
    var TimeArr = [[String: Any]]()
    var TicketArr = [[String: Any]]()
    
    var SavedIndexTime = [String]()
    var SavedIndexTicket = [String]()
    var selecteddata = [[String:Any]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let chkarr = [chkalltime,chkallticket]
        for chkall in chkarr {
            chkall?.boxType = .square
            chkall?.tintColor = #colorLiteral(red: 0, green: 0.2535815537, blue: 0, alpha: 1)
            chkall?.secondaryTintColor = #colorLiteral(red: 0.2176683843, green: 0.8194433451, blue: 0.2584097683, alpha: 1)
        }
        
        easyJoinContest(sortby: "All")
        viewAmountMain.isHidden = true
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        let pbAmount = Define.USERDEFAULT.value(forKey: "PBAmount") as? Double ?? 0.0
        let sbAmount = Define.USERDEFAULT.value(forKey: "SBAmount") as? Double ?? 0.0
        
        let totalAmount = pbAmount + sbAmount
        
        labelPBAmount.text = MyModel().getCurrncy(value: totalAmount)
    }
    
    //MARK: - Button Action Method
    
    @IBAction func chkalltime(_ sender: M13Checkbox) {
        print("TAG:",sender.tag)
        switch sender.checkState {
        case .unchecked:
            print("UnChecked")
            SavedIndexTime.removeAll()
            break
        case .checked:
            print("Checked")
            for (index,_) in TimeArr.enumerated() {
                SavedIndexTime.append("\(index)")
            }
            break
        case .mixed:
            print("Mixed")
            break
        }
        tbltime.reloadData()
        CalculateAmt()
        
    }
    @IBAction func chkallticket(_ sender: M13Checkbox) {
        print("TAG:",sender.tag)
        switch sender.checkState {
        case .unchecked:
            print("UnChecked")
            SavedIndexTicket.removeAll()
            break
        case .checked:
            print("Checked")
            for (index,_) in TicketArr.enumerated() {
                SavedIndexTicket.append("\(index)")
            }
            break
        case .mixed:
            print("Mixed")
            break
        }
        tblticket.reloadData()
        CalculateAmt()
    }
    
    @IBAction func back_click(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    var totalSelectedAmount = Double()
    
    @IBAction func pay_click(_ sender: UIButton) {
        
        if SavedIndexTime.count > 0 {
            if SavedIndexTicket.count > 0 {
                
                
                totalSelectedAmount = Double(CalculateAmt())
                
                viewAmountMain.isHidden = false
                let pbAmount = Define.USERDEFAULT.value(forKey: "PBAmount") as? Double ?? 0.0
                //let tbAmount = Define.USERDEFAULT.value(forKey: "TBAmount") as? Double ?? 0.0
                if totalSelectedAmount <= pbAmount {
                    labelUtilizedbalance.text = String(format: "₹%.2f", totalSelectedAmount) //"₹ \()"
                    labelwidrawableBalance.text = "₹ 0.0"
                    labelTotalBalance.text = String(format: "₹%.2f", totalSelectedAmount) //"₹ \(totalSelectedAmount)"
                } else {
                    let cutUtilized = totalSelectedAmount - pbAmount
                    labelUtilizedbalance.text = String(format: "₹%.2f", pbAmount) //"₹ \(pbAmount)"
                    labelwidrawableBalance.text = String(format: "₹%.2f", cutUtilized) //"₹ \(cutUtilized)"
                    labelTotalBalance.text = String(format: "₹%.2f", totalSelectedAmount) //"₹ \(totalSelectedAmount)"
                }
                
                self.view.layoutIfNeeded()
                
                let sbAmount = Define.USERDEFAULT.value(forKey: "SBAmount") as? Double ?? 0.0
                
                let totalAmount1 = pbAmount + sbAmount

                
                
                if Double(totalSelectedAmount) > totalAmount1 {
                    labelTotalBalance.textColor = UIColor.red
                    buttonAmountOk.setTitle("Add to wallet", for: .normal)
                } else {
                    labelTotalBalance.textColor = UIColor.green
                    buttonAmountOk.setTitle("OK", for: .normal)
                }
            }
            else {
                Alert().showTost(message: "Choose games and contests", viewController: self)
            }
        }
        else {
            Alert().showTost(message: "Choose games and contests", viewController: self)
        }
    }
    private var noOfSelected = Int()
    @IBAction func buttonPay(_ sender: Any) {
        if labelPay.text == "Pay" {
            if !MyModel().isConnectedToInternet() {
                Alert().showTost(message: Define.ERROR_INTERNET,
                                 viewController: self)
            } else if noOfSelected == 0 {
                Alert().showTost(message: "Select Ticket",
                                 viewController: self)
            } else {
                viewAmountMain.isHidden = false
                let pbAmount = Define.USERDEFAULT.value(forKey: "PBAmount") as? Double ?? 0.0
                //let tbAmount = Define.USERDEFAULT.value(forKey: "TBAmount") as? Double ?? 0.0
                if totalSelectedAmount <= pbAmount {
                    labelUtilizedbalance.text = String(format: "₹%.2f", totalSelectedAmount) //"₹ \()"
                    labelwidrawableBalance.text = "₹ 0.0"
                    labelTotalBalance.text = String(format: "₹%.2f", totalSelectedAmount) //"₹ \(totalSelectedAmount)"
                } else {
                    let cutUtilized = totalSelectedAmount - pbAmount
                    labelUtilizedbalance.text = String(format: "₹%.2f", pbAmount) //"₹ \(pbAmount)"
                    labelwidrawableBalance.text = String(format: "₹%.2f", cutUtilized) //"₹ \(cutUtilized)"
                    labelTotalBalance.text = String(format: "₹%.2f", totalSelectedAmount) //"₹ \(totalSelectedAmount)"
                }
            }
        } else {
//            let pbAmount = Define.USERDEFAULT.value(forKey: "PBAmount") as? Double ?? 0.0
//            let sbAmount = Define.USERDEFAULT.value(forKey: "SBAmount") as? Double ?? 0.0
//
//            let cutUtilized = totalSelectedAmount - (pbAmount + sbAmount)
//
//            let paymentVC = self.storyboard?.instantiateViewController(withIdentifier: "AddPaymentVC") as! AddPaymentVC
//            paymentVC.isFromTicket = true
//            paymentVC.addAmount = cutUtilized
//            paymentVC.isFromLink = isFromLink
//            self.navigationController?.pushViewController(paymentVC, animated: true)
            let pbAmount = Define.USERDEFAULT.value(forKey: "PBAmount") as? Double ?? 0.0
            let sbAmount = Define.USERDEFAULT.value(forKey: "SBAmount") as? Double ?? 0.0
            
            let cutUtilized = totalSelectedAmount - (pbAmount + sbAmount)
            
            let paymentVC = self.storyboard?.instantiateViewController(withIdentifier: "AddPaymentVC") as! AddPaymentVC
            paymentVC.isFromTicket = true
            paymentVC.addAmount = cutUtilized
            paymentVC.isFromLink = true
          //  paymentVC.modalPresentationStyle = .fullScreen
            present(paymentVC, animated: true) {
            }
        }
    }
    
    @IBAction func btnsortbby_click(_ sender: UIButton) {
        let  dropDown1 = DropDown()
        
        //  dropDown1.dataSource = self.MainarrMyJTicket.compactMap{$0["FilterDate"] as? String}.removeDuplicates()
        dropDown1.dataSource = ["Hourly","Half-hourly","Quarterly","All"]
        dropDown1.anchorView =  sender
        
        dropDown1.selectionAction = {
            
            [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            
            self.btnsortby.setTitle( item, for: .normal)
            self.SavedIndexTime = [String]()
            self.SavedIndexTicket = [String]()
            self.easyJoinContest(sortby: item)
        }
        dropDown1.show()
    }
    var isFromLink = Bool()
    @IBAction func buttonAmountOK(_ sender: UIButton) {
        if sender.titleLabel?.text == "OK" {
            if !MyModel().isConnectedToInternet() {
                Alert().showTost(message: Define.ERROR_INTERNET,
                                 viewController: self)
            }
            else
            {
                easyjoinContestPrice()
            }
        } else {
            let pbAmount = Define.USERDEFAULT.value(forKey: "PBAmount") as? Double ?? 0.0
            let sbAmount = Define.USERDEFAULT.value(forKey: "SBAmount") as? Double ?? 0.0
            
            let cutUtilized = totalSelectedAmount - (pbAmount + sbAmount)
            
            let paymentVC = self.storyboard?.instantiateViewController(withIdentifier: "AddPaymentVC") as! AddPaymentVC
            paymentVC.isFromTicket = true
            paymentVC.addAmount = cutUtilized
            paymentVC.isFromLink = true
          //  paymentVC.modalPresentationStyle = .fullScreen
            present(paymentVC, animated: true) {
            }
        }
        
    }
    
    @IBAction func buttonAmountCancel(_ sender: UIButton) {
        viewAmountMain.isHidden = true
    }
    
    //MARK: - Manual Function
    
    func CalculateAmt() -> Double {
        var totalAmount = Double()
        for (index,dict) in TimeArr.enumerated() {
            var selecteddict = [String:Any]()
            if SavedIndexTime.contains(String(index)) {
                let contestid = dict["id"]
                selecteddict["contest_id"] = contestid
                let princeData = dict["princeData"] as! [[String:Any]]
                for (tindix,tdict) in TicketArr.enumerated() {
                    if SavedIndexTicket.contains(String(tindix)) {
                        for (_,pdict) in princeData.enumerated() {
                            if tdict["price"] as! Int == pdict["amount"] as! Int {
                                totalAmount = totalAmount + Double(pdict["amount"] as! Int)
                            }
                        }
                    }
                }
            }
        }
        
        labelPurchasedAmount.text = String(format: "₹%.2f", totalAmount)
        
        let pbAmount = Define.USERDEFAULT.value(forKey: "PBAmount") as? Double ?? 0.0
        let sbAmount = Define.USERDEFAULT.value(forKey: "SBAmount") as? Double ?? 0.0
        
        let totalAmount1 = pbAmount + sbAmount
        
        if Double(totalAmount) > totalAmount1 {
            labelPBAmount.textColor = UIColor.red
            labelPay.text = "Add to wallet"
        } else {
            labelPBAmount.textColor = Define.MAINVIEWCOLOR2
            labelPBAmount.textColor = UIColor.green
            labelPay.text = "Pay"
        }
        return totalAmount
    }
    
    func SetDetails()  {
        
        
        self.tblticket.reloadData()
        self.tbltime.reloadData()
    }
}

extension EasyJoinVC {
    func easyJoinContest(sortby:String) {
        Loading().showLoading(viewController: self)
        let parameter: [String: Any] = ["filters":sortby]
        let strURL = Define.APP_URL + Define.easyJoinContest
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
                
                self.easyJoinContest(sortby: sortby)
            } else {
                Loading().hideLoading(viewController: self)
                print("Result: \(result!)")
                let status = result!["statusCode"] as? Int ?? 0
                if status == 200 {
                    let arr =  result!["content"] as! [String : Any]
                    self.TimeArr = arr["contest"] as? [[String : Any]] ?? []
                    self.TicketArr = arr["ticketData"] as? [[String : Any]] ?? []
                    self.SetDetails()
                    if self.TimeArr.count > 0 {
                        self.tbltime.setContentOffset(.zero, animated: true)
                        self.tbltime.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableView.ScrollPosition.top, animated: true)
                    }
                    else
                    {
                       // self.tbltime.isHidden = true
                    }
                    
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
    
    func getUserJoinDateTime() {
        Loading().showLoading(viewController: self)
        let parameter: [String: Any] = [:]
        let strURL = Define.APP_URL + Define.getUserJoinDateTime
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
                
                self.getUserJoinDateTime()
            } else {
                Loading().hideLoading(viewController: self)
                print("Result: \(result!)")
                let status = result!["statusCode"] as? Int ?? 0
                if status == 200 {
                    let dict =  result!["content"] as! [String : Any]
                    let arr = dict["contest"] as? [[String:Any]] ?? []
                    let selectedarr = self.selecteddata.compactMap {"\($0["contest_id"] as? Int ?? 0)"}
                    for dic in arr {
                        if selectedarr.contains(String(dic["id"] as? Int ?? 0)) {
                            self.createReminderbeforethirtysecond(strTitle: dic["name"] as? String ?? "No Name",strDate: dic["startDate"] as! String)
                        }
                      
                    }
                    
                    self.dismiss(animated: true, completion: nil)
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
    
    func createReminderbeforethirtysecond(strTitle: String, strDate: String) {
      
            let center = UNUserNotificationCenter.current()

            let content = UNMutableNotificationContent()
               content.title = strTitle
               content.body = "Your game starts soon, Hurry!!!!"
               content.categoryIdentifier = "alarm"
            content.categoryIdentifier = Define.PLAYGAME
             //  content.userInfo = ["customData": "fizzbuzz"]
          //     content.sound = UNNotificationSound.default
            content.sound = UNNotificationSound.init(named:UNNotificationSoundName(rawValue: "message_tone_lg_no.mp3"))
            
               let reminderDate = MyModel().getDateForRemiderbeforethirtysecond(contestDate: strDate)
                let timeInterval = reminderDate.timeIntervalSinceNow
               let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)

               let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
              // center.add(request)
        
        let curret = UNUserNotificationCenter.current()
        curret.add(request) { (error) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                print("EasyJoin Notification Registered.")
            }
        }
            
        
    }

    func easyjoinContestPrice() {
        Loading().showLoading(viewController: self)
        
         selecteddata = [[String:Any]]()
        for (index,dict) in TimeArr.enumerated() {
            var selecteddict = [String:Any]()
            var selectedticketstr = String()
            if SavedIndexTime.contains(String(index)) {
                let contestid = dict["id"]
                selecteddict["contest_id"] = contestid
                let princeData = dict["princeData"] as! [[String:Any]]
                for (tindix,tdict) in TicketArr.enumerated() {
                    if SavedIndexTicket.contains(String(tindix)) {
                        for (_,pdict) in princeData.enumerated() {
                            if tdict["price"] as! Int == pdict["amount"] as! Int {
                                selectedticketstr.append("\(pdict["id"] as! Int),")
                            }
                        }
                    }
                }
                if selectedticketstr.count > 0 {
                    selectedticketstr = String(selectedticketstr.dropLast(1))
                }
                selecteddict["contestPriceID"] = selectedticketstr
                selecteddata.append(selecteddict)
            }
        }
        
        
        let parameter: [String: Any] = ["contestData":selecteddata]
        
        let strURL = Define.APP_URL + Define.easyjoinContestPrice
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
                
                self.easyjoinContestPrice()
            } else {
                Loading().hideLoading(viewController: self)
                print("Result: \(result!)")
                let status = result!["statusCode"] as? Int ?? 0
                if status == 200 {
                   // let arr =  result!["content"] as! [String : Any]
//                    Alert().showAlert(title: "",
//                                      message: "Contests Joined Successfully",
//                                      viewController: self)
                    let alertController = UIAlertController(title:Define.ERROR_TITLE, message: "Contests Joined Successfully", preferredStyle:UIAlertController.Style.alert)

                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
                       { action -> Void in
                        if MyModel().isLogedIn() {
                            SocketIOManager.sharedInstance.establisConnection()
                            if MyModel().isConnectedToInternet() {
                                NotificationCenter.default.post(name: .upComingContest, object: nil)
                                NotificationCenter.default.post(name: .myContest, object: nil)
                                NotificationCenter.default.post(name:.getAllspecialContest,object: nil)
                            }
                        }
                        self.getUserJoinDateTime()
                       // self.dismiss(animated: true, completion: nil)
                       })
                    self.present(alertController, animated: true, completion: nil)
               
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
    
    
}


//MARK: - TableView Delegate
extension EasyJoinVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tbltime {
            return TimeArr.count
        }
        else if tableView == tblticket
        {
            return TicketArr.count
        }
        else
        {
            return 0
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tbltime {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PopUpCell", for: indexPath) as! PopUpCell
            //                    cell.chkvw?.markType = .checkmark
            cell.chkvw?.boxType = .square
            cell.chkvw?.tintColor = #colorLiteral(red: 0, green: 0.2535815537, blue: 0, alpha: 1)
            cell.chkvw?.secondaryTintColor = #colorLiteral(red: 0.2176683843, green: 0.8194433451, blue: 0.2584097683, alpha: 1)
            cell.chkvw?.tag = indexPath.row
            cell.chkvw?.addTarget(self, action: #selector(EasyJoinVC.checkboxValueChangedPopUpTime(_:)), for: .valueChanged)
            
            cell.lbltitle.text = "\(TimeArr [indexPath.row]["name"] ?? "")"
            
            let startDate = TimeArr [indexPath.row]["startDate"] ?? ""
            let inputFormatter = DateFormatter()
            inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "yyyy-MM-dd h:mm a"
            
            let showDate = inputFormatter.date(from: startDate as! String)
            var resultString = outputFormatter.string(from: showDate!)
            resultString = String(resultString.dropFirst(11))
            cell.lblsubtitle.text = "\(resultString)"
            
            if SavedIndexTime.contains(String(indexPath.row)) {
                cell.chkvw?.checkState = .checked
            }
            else
            {
                cell.chkvw?.checkState = .unchecked
            }
            
            cell.selectionStyle = .none
            return cell
        }
        else if tableView == tblticket
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PopUpCell", for: indexPath) as! PopUpCell
            //                    cell.chkvw?.markType = .checkmark
            cell.chkvw?.boxType = .square
            cell.chkvw?.tintColor = #colorLiteral(red: 0, green: 0.2535815537, blue: 0, alpha: 1)
            cell.chkvw?.secondaryTintColor = #colorLiteral(red: 0.2176683843, green: 0.8194433451, blue: 0.2584097683, alpha: 1)
            cell.chkvw?.tag = indexPath.row
            cell.chkvw?.addTarget(self, action: #selector(EasyJoinVC.checkboxValueChangedPopUpTicket(_:)), for: .valueChanged)
            
            cell.lbltitle.text = "₹\(TicketArr[indexPath.row]["price"] ?? "")"
            
            if SavedIndexTicket.contains(String(indexPath.row)) {
                cell.chkvw?.checkState = .checked
            }
            else
            {
                cell.chkvw?.checkState = .unchecked
            }
            cell.selectionStyle = .none
            return cell
        }
        else
        {
            return UITableViewCell()
        }
    }
    
    @IBAction func checkboxValueChangedPopUpTime(_ sender: M13Checkbox) {
        print("TAG:",sender.tag)
        switch sender.checkState {
        case .unchecked:
            print("UnChecked")
            if SavedIndexTime.contains((String(sender.tag))) {
                let index = SavedIndexTime.firstIndex(of: (String(sender.tag)))!
                SavedIndexTime.remove(at: index)
            }
            break
        case .checked:
            print("Checked")
            SavedIndexTime.append(String(sender.tag))
            break
        case .mixed:
            print("Mixed")
            
            break
        }
        CalculateAmt()
    }
    @IBAction func checkboxValueChangedPopUpTicket(_ sender: M13Checkbox) {
        print("TAG:",sender.tag)
        switch sender.checkState {
        case .unchecked:
            print("UnChecked")
            if SavedIndexTicket.contains((String(sender.tag))) {
                let index = SavedIndexTicket.firstIndex(of: (String(sender.tag)))!
                SavedIndexTicket.remove(at: index)
            }
            break
        case .checked:
            print("Checked")
            SavedIndexTicket.append(String(sender.tag))
            break
        case .mixed:
            print("Mixed")
            
            break
        }
        CalculateAmt()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

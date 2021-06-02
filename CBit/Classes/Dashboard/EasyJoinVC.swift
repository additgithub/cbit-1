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
    
    // var JoinArr = [[String: Any]]()
    var TimeArr = [[String: Any]]()
    var TicketArr = [[String: Any]]()
    
    var SavedIndexTime = [String]()
    var SavedIndexTicket = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let chkarr = [chkalltime,chkallticket]
        for chkall in chkarr {
            chkall?.boxType = .square
            chkall?.tintColor = #colorLiteral(red: 0, green: 0.2535815537, blue: 0, alpha: 1)
            chkall?.secondaryTintColor = #colorLiteral(red: 0.2176683843, green: 0.8194433451, blue: 0.2584097683, alpha: 1)
        }
        
        easyJoinContest(sortby: "all")
        viewAmountMain.isHidden = true
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
    }
    
    @IBAction func back_click(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func pay_click(_ sender: UIButton) {
        
        if SavedIndexTime.count > 0 {
            if SavedIndexTicket.count > 0 {
                
                var totalAmount = Double()
                
                var selecteddata = [[String:Any]]()
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
                                        totalAmount = totalAmount + Double(pdict["amount"] as! Int)
                                    }
                                }
                            }
                        }
                    }
                }
                
              let  totalSelectedAmount = Double(totalAmount)
                
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
            else {
                Alert().showTost(message: "Select Ticket", viewController: self)
            }
        }
        else {
            Alert().showTost(message: "Select Contest", viewController: self)
        }
    }
    
    @IBAction func btnsortbby_click(_ sender: UIButton) {
        let  dropDown1 = DropDown()
        
        //  dropDown1.dataSource = self.MainarrMyJTicket.compactMap{$0["FilterDate"] as? String}.removeDuplicates()
        dropDown1.dataSource = ["hour","half-hour","quarter","all"]
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
    
    @IBAction func buttonAmountOK(_ sender: UIButton) {
        easyjoinContestPrice()
    }
    
    @IBAction func buttonAmountCancel(_ sender: UIButton) {
        viewAmountMain.isHidden = true
    }
    
    //MARK: - Manual Function
    
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
    
    func easyjoinContestPrice() {
        Loading().showLoading(viewController: self)
        
        var selecteddata = [[String:Any]]()
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
//                                      message: "Contests Joines Successfully",
//                                      viewController: self)
                    if MyModel().isLogedIn() {
                        SocketIOManager.sharedInstance.establisConnection()
                        if MyModel().isConnectedToInternet() {
                            NotificationCenter.default.post(name: .upComingContest, object: nil)
                            NotificationCenter.default.post(name: .myContest, object: nil)
                            NotificationCenter.default.post(name:.getAllspecialContest,object: nil)
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
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

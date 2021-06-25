//
//  AutoRenewVC.swift
//  CBit
//
//  Created by Nirmal Bodar on 23/06/21.
//  Copyright © 2021 Bhavik Kothari. All rights reserved.
//

import UIKit
import M13Checkbox

class autorenewcell: UITableViewCell {
    @IBOutlet weak var lbltime: UILabel!
    @IBOutlet weak var lblticket: UILabel!
    @IBOutlet weak var swtch: UISwitch!
    @IBOutlet weak var btnadd: UIButton!
    
    var actionBlock: (() -> Void)? = nil
    var actionBlockSwitch: (() -> Void)? = nil
    
    @IBAction func Add_click(sender: UIButton) {
            actionBlock?()
        }
    
  
    @IBAction func swtch_chaged(_ sender: UISwitch)
    {
        actionBlockSwitch?()
    }
}

class AutoRenewVC: UIViewController {

    @IBOutlet weak var tblautorenew: UITableView!
    @IBOutlet weak var tblticket: UITableView!
    @IBOutlet weak var vwpopup: UIView!
    
    var AutorenewtblArr = [[String:Any]]()
    var TicketArr = [[String:Any]]()
    
    var SavedIndexTicket = [String]()
    
    var autorenew_time = String()
    var contest_status = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        vwpopup.isHidden = true
        getAutoRenewEasyJoin()
    }
    

    //MARK: - Button Action Method
    
    @IBAction func back_click(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func cancel_click(_ sender: UIButton) {
        vwpopup.isHidden = true
    }
    @IBAction func set_click(_ sender: UIButton) {
        setAutoRenewEasyJoin()
//        if SavedIndexTicket.count > 0
//        {
//            setAutoRenewEasyJoin()
//        }
//        else
//        {
//            Alert().showTost(message: "Choose tickets", viewController: self)
//        }
        
    }
    
   

}

//MARK: - API
extension AutoRenewVC {
    
    func getAutoRenewEasyJoin() {
        Loading().showLoading(viewController: self)
        let parameter: [String: Any] = [:]
        let strURL = Define.APP_URL + Define.getAutoRenewEasyJoin
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
                
                self.getAutoRenewEasyJoin()
            } else {
                Loading().hideLoading(viewController: self)
                print("Result: \(result!)")
                let status = result!["statusCode"] as? Int ?? 0
                if status == 200 {
                    let price = result?["price"] as? [[String:Any]] ?? []
                    let autorenewTable = result?["autorenewTable"] as? [[String:Any]] ?? []
                    self.AutorenewtblArr = autorenewTable
                    self.TicketArr = price
                    self.tblautorenew.reloadData()
                    self.tblticket.reloadData()
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
    
    func setAutoRenewEasyJoinStatus(id:Int,status:Int) {
        Loading().showLoading(viewController: self)
        let parameter: [String: Any] = ["id":id,"status":status]
        let strURL = Define.APP_URL + Define.setAutoRenewEasyJoinStatus
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
                
                self.setAutoRenewEasyJoinStatus(id: id, status: status)
            } else {
                Loading().hideLoading(viewController: self)
                print("Result: \(result!)")
                let status = result!["statusCode"] as? Int ?? 0
                if status == 200 {
                    self.getAutoRenewEasyJoin()
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
    
    
    func setAutoRenewEasyJoin() {
        Loading().showLoading(viewController: self)
        
        var selecteddata = [[String:Any]]()
      //  for (index,dict) in AutorenewtblArr.enumerated() {
            var selecteddict = [String:Any]()
            var selectedticketstr = String()
            
//            let autorenew_time = dict["autorenew_time"]
//            let contest_status = dict["contest_status"]
            selecteddict["contest_time"] = autorenew_time
            selecteddict["status"] = contest_status
            
              //  let contest_price = dict["contest_price"] as? NSArray ?? []
                for (tindix,tdict) in TicketArr.enumerated() {
                    if SavedIndexTicket.contains(String(tindix)) {
                   //     for (_,pdict) in contest_price.enumerated() {
                          //  if tdict["price"] as! Int == pdict["amount"] as! Int {
                                selectedticketstr.append("\(tdict["price"] as! Int),")
                          //  }
                      //  }
                    }
                }
                if selectedticketstr.count > 0 {
                    selectedticketstr = String(selectedticketstr.dropLast(1))
                }
                selecteddict["price"] = selectedticketstr
            
                selecteddata.append(selecteddict)
            
    //    }
        
        
        let parameter: [String: Any] = ["contestData":selecteddata]
        
        let strURL = Define.APP_URL + Define.setAutoRenewEasyJoin
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
               
                self.setAutoRenewEasyJoin()
            } else {
                Loading().hideLoading(viewController: self)
                print("Result: \(result!)")
                let status = result!["statusCode"] as? Int ?? 0
                if status == 200 {
                   // let arr =  result!["content"] as! [String : Any]
//                    Alert().showAlert(title: "",
//                                      message: "Contests Joined Successfully",
//                                      viewController: self)
//                    let alertController = UIAlertController(title:Define.ERROR_TITLE, message: "Contests Joined Successfully", preferredStyle:UIAlertController.Style.alert)
//
//                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
//                       { action -> Void in
//                        if MyModel().isLogedIn() {
//                            SocketIOManager.sharedInstance.establisConnection()
//                            if MyModel().isConnectedToInternet() {
//                                NotificationCenter.default.post(name: .upComingContest, object: nil)
//                                NotificationCenter.default.post(name: .myContest, object: nil)
//                                NotificationCenter.default.post(name:.getAllspecialContest,object: nil)
//                            }
//                        }
//
//                       // self.dismiss(animated: true, completion: nil)
//                       })
//                    self.present(alertController, animated: true, completion: nil)
                    self.vwpopup.isHidden = true
                    self.getAutoRenewEasyJoin()
               
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
extension AutoRenewVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblautorenew {
            return AutorenewtblArr.count
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
        if tableView == tblautorenew {
            let cell = tableView.dequeueReusableCell(withIdentifier: "autorenewcell", for: indexPath) as! autorenewcell
          
            
            cell.lbltime.text = "\(AutorenewtblArr [indexPath.row]["twentyfourhourformat"] ?? "")"
            
            let special_contest = AutorenewtblArr [indexPath.row]["special_contest"] as? Int
            
            if special_contest == 1 {
                cell.lbltime.textColor = UIColor.blue
            }
            else
            {
                cell.lbltime.textColor = UIColor.darkGray
            }
            
            let contest_price = AutorenewtblArr [indexPath.row]["contest_price"] as? NSArray ?? []
            let str = contest_price.componentsJoined(by: ", ₹")
            if contest_price.count > 0 {
                cell.lblticket.text = "₹\(str )"
            }
            else
            {
                cell.lblticket.text = ""
            }
            
            
            let status = AutorenewtblArr [indexPath.row]["contest_status"] as? Int ?? 0
            if status == 1 {
                cell.swtch.isOn = true
            }
            else
            {
                cell.swtch.isOn = false
            }
            
//            let startDate = AutorenewtblArr [indexPath.row]["startDate"] ?? ""
//            let inputFormatter = DateFormatter()
//            inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//
//            let outputFormatter = DateFormatter()
//            outputFormatter.dateFormat = "yyyy-MM-dd h:mm a"
//
//            let showDate = inputFormatter.date(from: startDate as! String)
//            var resultString = outputFormatter.string(from: showDate!)
//            resultString = String(resultString.dropFirst(11))
            
          //  cell.lblsubtitle.text = "\(resultString)"
            
            cell.actionBlock = { [self] in
                  //Do whatever you want to do when the button is tapped here
                vwpopup.isHidden = false
                SavedIndexTicket = [String]()
                
                for (index,dict) in TicketArr.enumerated() {
                    for (_,str) in contest_price.enumerated() {
                        if str as? Int == dict["price"] as? Int {
                            SavedIndexTicket.append("\(index)")
                        }
                    }
                }
               
                autorenew_time = AutorenewtblArr [indexPath.row]["autorenew_time"]  as? String ?? ""
                contest_status = status
               
                self.tblticket.reloadData()
               }
            
            cell.actionBlockSwitch = { [self] in
                  //Do whatever you want to do when the button is tapped here
             let contest_Id =   AutorenewtblArr [indexPath.row]["contest_Id"] as? Int ?? 0
                if contest_Id  != 0 {
                    if status == 1 {
                        setAutoRenewEasyJoinStatus(id: contest_Id, status: 0)
                    }
                    else
                    {
                        setAutoRenewEasyJoinStatus(id: contest_Id, status: 1)
                    }
                }
                else
                {
                    Alert().showAlert(title: "",
                                      message: "Click on + to add contests",
                                      viewController: self)
                    tblautorenew.reloadData()
                }
          
                
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
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
}

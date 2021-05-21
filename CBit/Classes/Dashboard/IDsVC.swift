//
//  IDsVC.swift
//  CBit
//
//  Created by Emp-Mac-1 on 28/01/21.
//  Copyright © 2021 Bhavik Kothari. All rights reserved.
//

import UIKit
import DropDown
import ActionSheetPicker_3_0

class CriteriaCell: UITableViewCell {
    @IBOutlet weak var imglevelname: UIImageView!
    @IBOutlet weak var lblidname: UILabel!
    @IBOutlet weak var lblbenifits: UILabel!
    @IBOutlet weak var lblcriteria: UILabel!
    
}

class IDCell: UITableViewCell {
    @IBOutlet weak var lbllevel: UILabel!
    @IBOutlet weak var lblreferal: UILabel!
    @IBOutlet weak var lblem: UILabel!
    @IBOutlet weak var lblrefcom: UILabel!
    @IBOutlet weak var lbltds: UILabel!
    
}

class IDsVC: UIViewController {
    
    @IBOutlet weak var lblyourid: UILabel!
    @IBOutlet weak var btnviewcriteria: ButtonWithBlueColor!
    @IBOutlet weak var lblnetwork: UILabel!
    @IBOutlet weak var btninvitefrnd: ButtonWithBlueColor!
    @IBOutlet weak var btnsortby: UIButton!
    @IBOutlet weak var tbllist: UITableView!
    
    @IBOutlet weak var lblleveltotal: UILabel!
    @IBOutlet weak var lblreferaltotal: UILabel!
    @IBOutlet weak var lblemtotal: UILabel!
    @IBOutlet weak var lblrefcomtotal: UILabel!
    @IBOutlet weak var lbltdstotal: UILabel!
    @IBOutlet weak var tblheight: NSLayoutConstraint!
    
    @IBOutlet weak var vwpopup: UIView!
    @IBOutlet weak var btnclose: UIButton!
    @IBOutlet weak var tblcriteria: UITableView!
    
    @IBOutlet weak var vwpopuplevel: UIView!
    @IBOutlet weak var tbllevel: UITableView!
    @IBOutlet weak var lbllevel: UILabel!
    
    @IBOutlet weak var btnfromdate: UIButton!
    @IBOutlet weak var btntodate: UIButton!
    
    
    var referalcriteriaarr = [[String:Any]]()
    var referallistarr = [[String:Any]]()
    var levellistarr = [[String:Any]]()
    var sortbydatestr = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        sortbydatestr = "T"
        getReferalCriteriaChart()
        getReferalCriteria()
    }
    
    override func viewDidLayoutSubviews() {
        tblheight.constant = tbllist.contentSize.height
    }
    
    
    // MARK: - Button Action Method
    @IBAction func back_click(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func refresh_click(_ sender: UIButton) {
        getReferalCriteriaChart()
        getReferalCriteria()
    }
    
    @IBAction func close_click(_ sender: Any) {
        vwpopup.isHidden = true
        vwpopuplevel.isHidden = true
    }
    @IBAction func viewcriteria_click(_ sender: ButtonWithBlueColor) {
        self.view.bringSubviewToFront(vwpopup)
        vwpopup.isHidden = false
    }
    @IBAction func invitefrnd_click(_ sender: ButtonWithBlueColor) {
        
                    let Referral = self.storyboard?.instantiateViewController(withIdentifier: "ReferralViewController") as! ReferralViewController
                    Referral.modalPresentationStyle = .fullScreen
                    present(Referral, animated: true) {
                    }
//        let SpinningMachineTicketVC = self.storyboard?.instantiateViewController(withIdentifier: "ReferralViewController") as! ReferralViewController
//        self.navigationController?.pushViewController(SpinningMachineTicketVC, animated: true)
        //        Install the ‘Cbit Original’ Gaming App with my referral code - *DHANIK*
        //
        //    • Worlds first Win-Win gaming concept
        //        • Worlds shortest and easiest games
        //        • Responsible Gaming
        //        • Digital Money Market
        //        • Minimum entry fee ₹5/- only
        //
        //        Click on the link to download the app- www.cbitoriginal.com
        //
        //        Hurry! Join now!
                
                
//              
//                            if let urlStr = NSURL(string:"https://cbitoriginal.com/")
//                               
//                            {
//                               
//                              
//                        let url1 =  "Hey there! \n\n"
//         
//
//                        let url2 = UserDefaults.standard.value(forKey:"Referralcode")! as? String
//                               
//                        let url4 = "Install the ‘CBIT Original’ Gaming App with my referral code - " + "*" + (url2 ?? "") + "*"
//                              
//                                
//                        let url3 = "\n\n• Worlds first Win-Win gaming concept \n• Worlds shortest and easiest games \n• Responsible Gaming \n• Digital Money Market \n• Minimum entry fee ₹5/- only \n\nClick on the link to download the app- www.cbitoriginal.com \n\nHurry! Join now!"
//
//                    
//                        
//                                
//                
//                        var appendString  = "\(url1)\(url4)\(url3)"
//                                
//                                
//                       // let objectsToShare = [appendString,urlStr] as [Any]
//                         
//                         let objectsToShare = [appendString] as [Any]
//                                
//                                
//                                
//                        let activityVC = UIActivityViewController(activityItems: objectsToShare as [Any], applicationActivities: nil)
//                
//                        if UI_USER_INTERFACE_IDIOM() == .pad
//                        {
//                                    if let popup = activityVC.popoverPresentationController {
//                                        popup.sourceView = self.view
//                                        popup.sourceRect = CGRect(x: self.view.frame.size.width / 2, y: self.view.frame.size.height / 4, width: 0, height: 0)
//                                    }
//                                }
//                
//                                self.present(activityVC, animated: true, completion: nil)
//                
//                 }
                
            }
    @IBAction func sortby_click(_ sender: UIButton) {
        let  dropDown1 = DropDown()
        
        //  dropDown1.dataSource = self.MainarrMyJTicket.compactMap{$0["FilterDate"] as? String}.removeDuplicates()
        dropDown1.dataSource = ["Till Date","Daily","Weekly","Monthly","Custom Date"]
        dropDown1.anchorView =  sender
        
        dropDown1.selectionAction = {
            
            [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.btnsortby.setTitle( item, for: .normal)
            if item == "Till Date" {
                sortbydatestr = "T"
            }
            else if item == "Daily" {
                sortbydatestr = "D"
            }
            else if item == "Weekly" {
                sortbydatestr = "W"
            }
            else if item == "Monthly" {
                sortbydatestr = "M"
            }
            else if item == "Custom Date" {
                sortbydatestr = "C"
            }
            
            if item == "Custom Date" {
                btnfromdate.isEnabled = true
                btntodate.isEnabled = true
            }
            else
            {
                btnfromdate.isEnabled = false
                btntodate.isEnabled = false
            }
            
            getReferalCriteriaChart()
            
        }
        dropDown1.show()
    }
    
    @IBAction func fromdate_click(_ sender: UIButton) {
        // example of date picker with min and max values set (as a week in past and week in future from today)
        let datePicker = ActionSheetDatePicker(title: "Select From Date",
                                               datePickerMode: UIDatePicker.Mode.date,
                                               selectedDate: Date(),
                                               doneBlock: { picker, date, origin in
                                                    print("picker = \(String(describing: picker))")
                                                    print("date = \(String(describing: date))")
                                                    print("origin = \(String(describing: origin))")
                                                let dateFormater: DateFormatter = DateFormatter()
                                                dateFormater.dateFormat = "dd-MM-yyyy"
                                                let stringFromDate: String = dateFormater.string(from: date as! Date) as String
                                                sender.setTitle(stringFromDate, for: .normal)
                                                    return
                                                },
                                               cancel: { picker in
                                                    return
                                               },
                                               origin: sender.superview!.superview)
//        let secondsInWeek: TimeInterval = 7 * 24 * 60 * 60;
//        datePicker?.minimumDate = Date(timeInterval: -secondsInWeek, since: Date())
//        datePicker?.maximumDate = Date(timeInterval: secondsInWeek, since: Date())
        if #available(iOS 14.0, *) {
          //  datePicker?.datePickerStyle = .inline
        }

        datePicker?.show()
    }
    @IBAction func todate_click(_ sender: UIButton) {
        // example of date picker with min and max values set (as a week in past and week in future from today)
        let datePicker = ActionSheetDatePicker(title: "Select To Date",
                                               datePickerMode: UIDatePicker.Mode.date,
                                               selectedDate: Date(),
                                               doneBlock: { picker, date, origin in
                                                    print("picker = \(String(describing: picker))")
                                                    print("date = \(String(describing: date))")
                                                    print("origin = \(String(describing: origin))")
                                                
                                                let dateFormater: DateFormatter = DateFormatter()
                                                dateFormater.dateFormat = "dd-MM-yyyy"
                                                let stringFromDate: String = dateFormater.string(from: date as! Date) as String
                                                sender.setTitle(stringFromDate, for: .normal)
                                                self.getReferalCriteriaChart()
                                                    return
                                                },
                                               cancel: { picker in
                                                    return
                                               },
                                               origin: sender.superview!.superview)
//        let secondsInWeek: TimeInterval = 7 * 24 * 60 * 60;
//        datePicker?.minimumDate = Date(timeInterval: -secondsInWeek, since: Date())
//        datePicker?.maximumDate = Date(timeInterval: secondsInWeek, since: Date())
        if #available(iOS 14.0, *) {
         //   datePicker?.datePickerStyle = .inline
        }

        datePicker?.show()
    }
    
    var EMShow:Double = 0
    
    @IBAction func em_click(_ sender: UIButton) {
        let alert = UIAlertController(title: "", message: "₹ \(EMShow)", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func setdata(dict:[String:Any])  {
        
        lblyourid.text = "\(dict["UserCriteriaID"]!)"
        lblnetwork.text = "\(dict["UserRefferalNetwork"]!) Players"
       // lblleveltotal.text = "Total (\(referallistarr.count))"
        var EM:Double = 0
        var RefComm:Double = 0
        var TDS:Double = 0
        
        for item in referallistarr {
            EM = EM + Double(item["EM"] as! String)!
            RefComm = RefComm + Double(item["RefComm"] as! String)!
            TDS = TDS + Double(item["TDS"] as! String)!
        }
        
      EMShow = EM
        
        if (EM >= 10000000) {
            EM = EM / 10000000;
            lblemtotal.text = "₹ \(EM.rounded(toPlaces: 1)) Cr"
              } else if (EM >= 100000) {
                EM = EM / 100000;
                lblemtotal.text = "₹ \(EM.rounded(toPlaces: 1)) Lac"
              } else if (EM >= 10000) {
                EM = EM / 1000;
                lblemtotal.text = "₹ \(EM.rounded(toPlaces: 1)) K"
              }
        else
              {
                lblemtotal.text = "₹ \(EM.rounded(toPlaces: 1))"
              }
        
       
        lblrefcomtotal.text = "₹ \(RefComm.rounded(toPlaces: 1))"
        lbltdstotal.text = "₹ \(TDS.rounded(toPlaces: 1))"
        
        lblreferaltotal.text = "\(dict["UserRefferalNetwork"]!)"
        self.tbllist.reloadData()
    }
    
    func RoundAmt(amount:Double)  {
      
    }
    
    
}

extension IDsVC
{
    func getReferalCriteriaChart() {
        Loading().showLoading(viewController: self)
        let parameter: [String: Any] = ["sortType": sortbydatestr,
                                        "StartDate":btnfromdate.titleLabel?.text ?? "",
                                        "EndDate":btntodate.titleLabel?.text ?? ""
        ]
        let strURL = Define.APP_URL + Define.referal_criteria_chart
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
                print("Error: \(error!)")
                //                Alert().showAlert(title: "Error",
                //                                  message: Define.ERROR_SERVER,
                //                                  viewController: self)
                self.getReferalCriteriaChart()
            } else {
                Loading().hideLoading(viewController: self)
                print("Result: \(result!)")
                let status = result!["statusCode"] as? Int ?? 0
                if status == 200 {
                    let content = result!["content"] as! [String: Any]
                    self.referallistarr = content["ReferralList"] as? [[String : Any]] ?? []
                    self.setdata(dict: content)
                    
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
    
    func getReferalCriteria() {
        Loading().showLoading(viewController: self)
        let parameter: [String: Any] = [:]
        let strURL = Define.APP_URL + Define.referal_criteria
        print("Parameter: \(parameter)\nURL: \(strURL)")
        
        let jsonString = MyModel().getJSONString(object: parameter)
        let encriptString = MyModel().encrypting(strData: jsonString!, strKey: Define.KEY)
        let strbase64 = encriptString.toBase64()
        
        
        SwiftAPI().getMethodSecure(stringURL: strURL,
                                    parameters: ["data":strbase64!],
                                    header: Define.USERDEFAULT.value(forKey: "AccessToken") as? String,
                                    auther: Define.USERDEFAULT.value(forKey: "UserID") as? String)
        { (result, error) in
            if error != nil {
                Loading().hideLoading(viewController: self)
                print("Error: \(error!)")
                //                Alert().showAlert(title: "Error",
                //                                  message: Define.ERROR_SERVER,
                //                                  viewController: self)
                self.getReferalCriteriaChart()
            } else {
                Loading().hideLoading(viewController: self)
                print("Result: \(result!)")
                let status = result!["statusCode"] as? Int ?? 0
                if status == 200 {
                  //  let content = result!["content"] as! [String: Any]
                    self.referalcriteriaarr = result!["content"] as? [[String : Any]] ?? []
                    self.tblcriteria.reloadData()
                    
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
    
    
    func getReferralPopup(level:String) {
        Loading().showLoading(viewController: self)
        let parameter: [String: Any] = ["Level": level
        ]
        let strURL = Define.APP_URL + Define.getReferralPopup
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
                print("Error: \(error!)")
                //                Alert().showAlert(title: "Error",
                //                                  message: Define.ERROR_SERVER,
                //                                  viewController: self)
                self.getReferralPopup(level: level)
            } else {
                Loading().hideLoading(viewController: self)
                print("Result: \(result!)")
                let status = result!["statusCode"] as? Int ?? 0
                if status == 200 {
                  
                    self.levellistarr = result!["content"] as? [[String : Any]] ?? []
                    self.tbllevel.reloadData()
                  //  self.setdata(dict: content)
                    
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

extension IDsVC: UITableViewDelegate, UITableViewDataSource,UIGestureRecognizerDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tbllist
        {
            return referallistarr.count
        }
        else if tableView == tblcriteria
        {
            return referalcriteriaarr.count
        }
        else if tableView == tbllevel
        {
            return levellistarr.count
        }
        return 0
    }
    func currentTimeInMilliSeconds()-> Int
        {
            let currentDate = Date()
            let since1970 = currentDate.timeIntervalSince1970
            return Int(since1970 * 1000)
        }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tbllist
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "IDCell") as! IDCell
            
            cell.lbllevel.text = "\(referallistarr[indexPath.row]["Level"]!)"
            cell.lblreferal.text = "\(referallistarr[indexPath.row]["Refferel"]!)"
           // cell.lblem.text = "₹ \((Double(referallistarr[indexPath.row]["EM"] as! String))!.rounded(toPlaces: 2))"
            var EM = (Double(referallistarr[indexPath.row]["EM"] as! String))!
            if (EM >= 10000000) {
                EM = EM / 10000000;
                cell.lblem.text = "₹ \(EM.rounded(toPlaces: 1)) Cr"
                  } else if (EM >= 100000) {
                    EM = EM / 100000;
                    cell.lblem.text = "₹ \(EM.rounded(toPlaces: 1)) Lac"
                  } else if (EM >= 10000) {
                    EM = EM / 1000;
                    cell.lblem.text = "₹ \(EM.rounded(toPlaces: 1)) K"
                  }
            else
                  {
                    cell.lblem.text = "₹ \((Double(referallistarr[indexPath.row]["EM"] as! String))!.rounded(toPlaces: 1))"
                  }
            
            cell.lblrefcom.text = "₹ \((Double(referallistarr[indexPath.row]["RefComm"]as! String))!.rounded(toPlaces: 1))"
            cell.lbltds.text = "₹ \((Double(referallistarr[indexPath.row]["TDS"]as! String))!.rounded(toPlaces: 1))"
            
            let tapGestureem : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(lblemClick(tapGesture:)))
            tapGestureem.delegate = self
            tapGestureem.numberOfTapsRequired = 1
            cell.lblem.isUserInteractionEnabled = true
            cell.lblem.tag = indexPath.row
            cell.lblem.addGestureRecognizer(tapGestureem)
            
            let tapGesture : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(lblClick(tapGesture:)))
            tapGesture.delegate = self
            tapGesture.numberOfTapsRequired = 1
            cell.lbllevel.isUserInteractionEnabled = true
            cell.lbllevel.tag = indexPath.row
            cell.lbllevel.addGestureRecognizer(tapGesture)
            return cell
        }
        else if tableView == tblcriteria
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CriteriaCell") as! CriteriaCell
            
                            let imageURL = URL(string: referalcriteriaarr[indexPath.row]["image"] as? String ?? "")
                            cell.imglevelname.sd_setImage(with: imageURL,placeholderImage: Define.PLACEHOLDER_PROFILE_IMAGE)
            
            cell.lblidname.text = "\(referalcriteriaarr[indexPath.row]["ReferalLevelName"]!)"
            cell.lblbenifits.text = "Random Commission UpTo \(referalcriteriaarr[indexPath.row]["CommissionLevel"]!) Levels"
            cell.lblcriteria.text = "\(referalcriteriaarr[indexPath.row]["TotalReferal"]!) referrals"
            return cell
        }
        else if tableView == tbllevel
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CriteriaCell") as! CriteriaCell
            
            cell.lblidname.text = "\(levellistarr[indexPath.row]["User"]!)"
            cell.lblbenifits.text = "(\(levellistarr[indexPath.row]["ReffralList"]!))"
            
            return cell
        }
        return UITableViewCell()
    }
    
    @objc func lblClick(tapGesture:UITapGestureRecognizer){
       print("Lable tag is:\(tapGesture.view!.tag)")
        self.view.bringSubviewToFront(vwpopuplevel)
        vwpopuplevel.isHidden = false
        lbllevel.text = "Level \(referallistarr[tapGesture.view!.tag]["Level"]!)"
        getReferralPopup(level: referallistarr[tapGesture.view!.tag]["Level"] as! String)
    }
    
    @objc func lblemClick(tapGesture:UITapGestureRecognizer){
       print("Lable tag is:\(tapGesture.view!.tag)")
        let alert = UIAlertController(title: "", message: "₹ \(Double(referallistarr[tapGesture.view!.tag]["EM"] as! String) ?? 0)", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
       
    }
}



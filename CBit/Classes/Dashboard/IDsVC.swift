//
//  IDsVC.swift
//  CBit
//
//  Created by Emp-Mac-1 on 28/01/21.
//  Copyright © 2021 Bhavik Kothari. All rights reserved.
//

import UIKit
import DropDown

class CriteriaCell: UITableViewCell {
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
    var referalcriteriaarr = [[String:Any]]()
    var referallistarr = [[String:Any]]()
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
    @IBAction func close_click(_ sender: Any) {
        vwpopup.isHidden = true
    }
    @IBAction func viewcriteria_click(_ sender: ButtonWithBlueColor) {
        vwpopup.isHidden = false
    }
    @IBAction func invitefrnd_click(_ sender: ButtonWithBlueColor) {
        
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
                
                
              
                            if let urlStr = NSURL(string:"https://cbitoriginal.com/")
                               
                            {
                               
                              
                        let url1 =  "Hey there! \n\n"
         

                        let url2 = UserDefaults.standard.value(forKey:"Referralcode")! as? String
                               
                        let url4 = "Install the ‘CBIT Original’ Gaming App with my referral code - " + "*" + (url2 ?? "") + "*"
                              
                                
                        let url3 = "\n\n• Worlds first Win-Win gaming concept \n• Worlds shortest and easiest games \n• Responsible Gaming \n• Digital Money Market \n• Minimum entry fee ₹5/- only \n\nClick on the link to download the app- www.cbitoriginal.com \n\nHurry! Join now!"

                    
                        
                                
                
                        var appendString  = "\(url1)\(url4)\(url3)"
                                
                                
                       // let objectsToShare = [appendString,urlStr] as [Any]
                         
                         let objectsToShare = [appendString] as [Any]
                                
                                
                                
                        let activityVC = UIActivityViewController(activityItems: objectsToShare as [Any], applicationActivities: nil)
                
                        if UI_USER_INTERFACE_IDIOM() == .pad
                        {
                                    if let popup = activityVC.popoverPresentationController {
                                        popup.sourceView = self.view
                                        popup.sourceRect = CGRect(x: self.view.frame.size.width / 2, y: self.view.frame.size.height / 4, width: 0, height: 0)
                                    }
                                }
                
                                self.present(activityVC, animated: true, completion: nil)
                
                 }
                
            }
    @IBAction func sortby_click(_ sender: UIButton) {
        let  dropDown1 = DropDown()
        
        //  dropDown1.dataSource = self.MainarrMyJTicket.compactMap{$0["FilterDate"] as? String}.removeDuplicates()
        dropDown1.dataSource = ["Till Date","Daily","Weekly","Monthly"]
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
            getReferalCriteriaChart()
            
        }
        dropDown1.show()
    }
    
    func setdata(dict:[String:Any])  {
        
        lblyourid.text = "\(dict["UserCriteriaID"]!)"
        lblnetwork.text = "\(dict["UserRefferalNetwork"]!) Players"
        var EM:Double = 0
        var RefComm:Double = 0
        var TDS:Double = 0
        
        for item in referallistarr {
            EM = EM + Double(item["EM"] as! Double)
            RefComm = RefComm + Double(item["RefComm"] as! Double)
            TDS = TDS + Double(item["TDS"] as! Double)
        }
        
        lblemtotal.text = "₹ \(EM.rounded(toPlaces: 2))"
        lblrefcomtotal.text = "₹ \(RefComm.rounded(toPlaces: 2))"
        lbltdstotal.text = "\(TDS.rounded(toPlaces: 2))%"
        
        lblreferaltotal.text = "\(dict["UserRefferalNetwork"]!)"
        self.tbllist.reloadData()
    }
    
    
}

extension IDsVC
{
    func getReferalCriteriaChart() {
        Loading().showLoading(viewController: self)
        let parameter: [String: Any] = ["sortType": sortbydatestr
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
    
    
}

extension IDsVC: UITableViewDelegate, UITableViewDataSource
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
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tbllist
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "IDCell") as! IDCell
            
            cell.lbllevel.text = "L \(referallistarr[indexPath.row]["Level"]!)"
            cell.lblreferal.text = "\(referallistarr[indexPath.row]["Refferel"]!)"
            cell.lblem.text = "₹ \((referallistarr[indexPath.row]["EM"] as! Double).rounded(toPlaces: 2))"
            cell.lblrefcom.text = "₹ \((referallistarr[indexPath.row]["RefComm"]as! Double).rounded(toPlaces: 2))"
            cell.lbltds.text = "\((referallistarr[indexPath.row]["TDS"]as! Double).rounded(toPlaces: 2))%"
            
            //            cell.btn_deal.tag = indexPath.row
            //            cell.btn_deal.addTarget(self, action: #selector(btnDeal(sender:)), for: .touchUpInside)
            return cell
        }
        else if tableView == tblcriteria
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CriteriaCell") as! CriteriaCell
            
            cell.lblidname.text = "\(referalcriteriaarr[indexPath.row]["ReferalLevelName"]!)"
            cell.lblbenifits.text = "Random Commission UpTo \(referalcriteriaarr[indexPath.row]["CommissionLevel"]!) Levels"
            cell.lblcriteria.text = "\(referalcriteriaarr[indexPath.row]["TotalReferal"]!) referrals"
            return cell
        }
        return UITableViewCell()
    }
}



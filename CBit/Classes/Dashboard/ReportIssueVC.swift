//
//  ReportIssueVC.swift
//  CBit
//
//  Created by Nirmal Bodar on 22/07/21.
//  Copyright © 2021 Bhavik Kothari. All rights reserved.
//

import UIKit
import IBAnimatable
class reportcell: UITableViewCell {
    @IBOutlet weak var lblname: UILabel!
    @IBOutlet weak var btnreport: UIButton!
    
}

class ReportIssueVC: UIViewController {

    @IBOutlet weak var tblreportlist: UITableView!
    @IBOutlet weak var vwpopup: UIView!
    @IBOutlet weak var textvwsuggestion: AnimatableTextView!
    
    var ReportListArr = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        vwpopup.isHidden = true
        getReportListAPI()
    }
    

    @IBAction func back_click(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func refresh_click(_ sender: UIButton) {
        getReportListAPI()
    }
    @IBAction func otherissue_click(_ sender: AnimatableButton) {
        vwpopup.isHidden = false
    }
    @IBAction func cancel_click(_ sender: UIButton) {
        vwpopup.isHidden = true
    }
    @IBAction func send_click(_ sender: UIButton) {
        
        if textvwsuggestion.text.count > 1 {
            SendReportAPI(msgtitle: textvwsuggestion.text)
        }
        else
        {
            Alert().showAlert(title: "",
                              message: "Enter Suggestion",
                              viewController: self)
        }
    }
    
}

//MARK: - TableView Delegate Method
extension ReportIssueVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ReportListArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reportcell = tableView.dequeueReusableCell(withIdentifier: "reportcell") as! reportcell
        reportcell.lblname.text = ReportListArr[indexPath.row]["report_title"] as? String ?? "No Message"
        reportcell.btnreport.tag = indexPath.row
        reportcell.btnreport.addTarget(self,action: #selector(buttonReport(_:)),for: .touchUpInside)
        tableView.tableFooterView = UIView()
        return reportcell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
      
    }
    @objc func buttonReport(_ sender: UIButton) {
        
        let index = sender.tag
        let report_title = ReportListArr[index]["report_title"] as? String ?? "No Message"
         SendReportAPI(msgtitle: report_title)
    }
}

// MARK: - API
extension ReportIssueVC {
    func getReportListAPI() {
        Loading().showLoading(viewController: self)
        let strURL = Define.APP_URL + Define.reportslisting
        print("URL: \(strURL)")
        
        SwiftAPI().postMethodSecure(stringURL: strURL,
                                    parameters: nil,
                                    header: Define.USERDEFAULT.value(forKey: "AccessToken") as? String,
                                    auther: Define.USERDEFAULT.value(forKey: "UserID") as? String)
        { (result, error) in
            if error != nil {
                Loading().hideLoading(viewController: self)
                print("Error: \(error!.localizedDescription)")
                //self.retry()
                self.getReportListAPI()
            } else {
                Loading().hideLoading(viewController: self)
                print("Result: \(result!)")
                let status = result!["statusCode"] as? Int ?? 0
                if status == 200 {
                    self.ReportListArr = result!["content"] as! [[String: Any]]
//                    if self.arrNotification.count == 0 {
//                        self.viewNoData.isHidden = false
//                    } else {
//                        self.viewNoData.isHidden = true
//                    }
                    self.tblreportlist.reloadData()
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
    
    
    func SendReportAPI(msgtitle:String) {
        Loading().showLoading(viewController: self)
        let strURL = Define.APP_URL + Define.setUserIssues
        print("URL: \(strURL)")
        let parameter: [String: Any] = ["title": msgtitle]
        SwiftAPI().postMethodSecure(stringURL: strURL,
                                    parameters: parameter,
                                    header: Define.USERDEFAULT.value(forKey: "AccessToken") as? String,
                                    auther: Define.USERDEFAULT.value(forKey: "UserID") as? String)
        { (result, error) in
            if error != nil {
                Loading().hideLoading(viewController: self)
                print("Error: \(error!.localizedDescription)")
                //self.retry()
                self.SendReportAPI(msgtitle: msgtitle)
            } else {
                Loading().hideLoading(viewController: self)
                print("Result: \(result!)")
                let status = result!["statusCode"] as? Int ?? 0
                if status == 200 {
                    Alert().showAlert(title: "",
                                      message: result!["message"] as! String,
                                      viewController: self)
                    self.getReportListAPI()
                    self.vwpopup.isHidden = true
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

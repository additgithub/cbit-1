//
//  CCPassBookViewController.swift
//  CBit
//
//  Created by My Mac on 04/01/20.
//  Copyright © 2020 Bhavik Kothari. All rights reserved.
//

import UIKit



class CCPassBookTVC: UITableViewCell {
    
    @IBOutlet weak var viewafterbal: UIView!
    @IBOutlet weak var lblafterbal: UILabel!
    @IBOutlet weak var imageTransaction: UIImageView!
    @IBOutlet weak var labelTransactionName: UILabel!
    @IBOutlet weak var labelData: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var labelAmount: UILabel!
    @IBOutlet weak var labelTDS: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
    
}


class CCPassBookViewController: UIViewController {

    @IBOutlet weak var lblcredentiacurrency: UILabel!
    
    
    
    @IBOutlet weak var tablePassBook: UITableView!
    @IBOutlet weak var labelbalance: UILabel!
   // @IBOutlet weak var labelWinning: LabelComman!
    @IBOutlet weak var viewNoData: UIView!
    
    private var arrPassbook = [[String: Any]]()
    
    lazy  var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.handleRefresh(_:)), for: .valueChanged)
        refreshControl.tintColor = Define.APPCOLOR
        return refreshControl
    }()
    
    private var isRefresh = Bool()
    private var isShowLoading = Bool()
    
    var Start = 0
    var Limit = 10
    var ismoredata = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let ccAmount = "\(Define.USERDEFAULT.value(forKey: "ccAmount")!)"
        
        guard let amountCC = Double(ccAmount) else {
            return
        }
        
       
        
        lblcredentiacurrency.text! =  "CC " + MyModel().getNumbers(value:amountCC)
       
        
        tablePassBook.rowHeight = UITableView.automaticDimension
        tablePassBook.tableFooterView = UIView()
        tablePassBook.addSubview(refreshControl)
        
    //    UNUserNotificationCenter.current().delegate = self
        if !MyModel().isConnectedToInternet() {
            Alert().showTost(message: Define.ERROR_INTERNET,
                             viewController: self)
        } else {
            isShowLoading = true
            getccPassbookData()
        }
        // Do any additional setup after loading the view.
    }
    
    @objc func handleRefresh(_ refresh: UIRefreshControl) {
    //    setWalletDetail()
        if !MyModel().isLogedIn() {
            Alert().showTost(message: Define.ERROR_INTERNET, viewController: self)
        } else {
            isRefresh = true
            isShowLoading = false
            refreshControl.beginRefreshing()
            Start = 0
           arrPassbook = [[String:Any]]()
           tablePassBook.reloadData()
            self.getccPassbookData()
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: - Button Method
    @IBAction func buttonBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        //    }
}

}


//MARK: - TableView Delegate
extension CCPassBookViewController: UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrPassbook.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let passBookCell = tableView.dequeueReusableCell(withIdentifier: "CCPassBookTVC") as! CCPassBookTVC
        
        passBookCell.labelTransactionName.text = arrPassbook[indexPath.row]["title"] as? String ?? "No Name"
        passBookCell.labelData.text = "\(arrPassbook[indexPath.row]["date"] as? String ?? "00-00-0000")"
        passBookCell.labelTime.text = "\(arrPassbook[indexPath.row]["time"] as? String ?? "00:00")"
        passBookCell.labelAmount.text = arrPassbook[indexPath.row]["amount"] as? String ?? "0"
         passBookCell.lblafterbal.text =  arrPassbook[indexPath.row]["beforebalance"] as? String ?? "0"
        
        let strType = arrPassbook[indexPath.row]["type"] as? String ?? "subtract"
        if strType == "subtract" {
            passBookCell.imageTransaction.image = #imageLiteral(resourceName: "ic_recive")
            passBookCell.viewafterbal.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            
        } else {
            passBookCell.imageTransaction.image = #imageLiteral(resourceName: "ic_send")
            passBookCell.viewafterbal.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        }
        
        let strTDS = "\(arrPassbook[indexPath.row]["tds"]!)"
        if strTDS == "0" {
            passBookCell.labelTDS.isHidden = true
            passBookCell.labelTDS.text = nil
        } else {
            passBookCell.labelTDS.isHidden = false
            MyModel().setGradient(view: passBookCell.labelTDS, startColor: #colorLiteral(red: 1, green: 0.3215686275, blue: 0.3215686275, alpha: 1), endColor: #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1))
            
            //            if let amountTDS = Double(strTDS)  {
            //               passBookCell.labelTDS.text = "TDS " + MyModel().getCurrncy(value: amountTDS)
            //            } else {
            passBookCell.labelTDS.text = "TDS " + strTDS
            //}
            
        }
        
        if arrPassbook.count > 1 {
            let lastElement = arrPassbook.count - 1
            if indexPath.row == lastElement && ismoredata{
                //call get api for next page
                getccPassbookData()
            }

        }

        
        return passBookCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}

//MARK: - API
extension CCPassBookViewController {
    
    func getccPassbookData()
    {
        if isShowLoading
        {
            Loading().showLoading(viewController: self)
        }
        let strURL = Define.APP_URL + Define.API_getCCPassbook
        
        print("URL: \(strURL)")
        let parameter: [String: Any] = ["start": Start,"limit":Limit]
        SwiftAPI().postMethodSecure(stringURL: strURL,
                                    parameters: parameter,
                                    header: Define.USERDEFAULT.value(forKey: "AccessToken") as? String,
                                    auther: Define.USERDEFAULT.value(forKey: "UserID") as? String)
        { (result, error) in
            if error != nil {
                if self.isRefresh {
                    self.isRefresh = false
                    self.refreshControl.endRefreshing()
                }
                
                Loading().hideLoading(viewController: self)
                print("Error: \(error!)")
                //self.retry()
                self.getccPassbookData()
            } else {
                if self.isRefresh {
                    self.isRefresh = false
                    self.refreshControl.endRefreshing()
                }
                
                Loading().hideLoading(viewController: self)
                print("Result: \(result!)")
                let status = result!["statusCode"] as? Int ?? 0
                if status == 200 {
                   // self.arrPassbook = result!["content"] as! [[String: Any]]
                    let arr =  result!["content"] as! [[String : Any]]
                    
                    if arr.count > 0 {
                        self.arrPassbook.append(contentsOf: arr)
                        self.ismoredata = true
                        self.Start = self.Start + 10
                        self.Limit =  10
                    }
                    else
                    {
                        self.ismoredata = false
                    }
                    if self.arrPassbook.count == 0 {
                        self.viewNoData.isHidden = false
                    } else {
                        self.viewNoData.isHidden = true
                    }
                    self.tablePassBook.reloadData()
                    
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

//MARK: - Notifcation Delegate Method
//extension PassBookVC: UNUserNotificationCenterDelegate {
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

//MARK: - Alert Contollert
extension CCPassBookViewController {
    func retry() {
        let alertController = UIAlertController(title: Define.ERROR_TITLE,
                                                message: Define.ERROR_SERVER,
                                                preferredStyle: .alert)
        let buttonRetry = UIAlertAction(title: "Retry",
                                        style: .default)
        { _ in
            self.getccPassbookData()
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

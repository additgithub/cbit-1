//
//  MyJticketViewController.swift
//  CBit
//
//  Created by My Mac on 19/12/19.
//  Copyright © 2019 Bhavik Kothari. All rights reserved.
//

import UIKit

class MyJticketViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

  
    @IBOutlet weak var lblapd: UILabel!
    
    
    private var isFirstTime = Bool()
    
    private var arrMyJTicket = [[String: Any]]()
    
    var MainarrMyJTicket = [[String: Any]]()
    
     private var id = 0
    private var jticketid = 0
    
    @IBOutlet weak var tbllistingMyjticket: UITableView!
    
    
    @IBOutlet weak var lblApdrefresh: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
    
       getUserJticket()
    }
    override func viewWillAppear(_ animated: Bool) {
   
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrMyJTicket.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let userCell = tableView.dequeueReusableCell(withIdentifier: "MyJticketlisting") as! MyJticketlisting
        userCell.btnapply.addTarget(self, action: #selector(btnapply(_:event:)), for: .touchUpInside)
        userCell.lbldate.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        
        userCell.imgjticketbackground.layer.shadowColor = UIColor.black.cgColor
        userCell.imgjticketbackground.layer.shadowOffset = CGSize(width: 0, height: 1)
        userCell.imgjticketbackground.layer.shadowOpacity = 4
        userCell.imgjticketbackground.layer.shadowRadius = 8.0
        userCell.imgjticketbackground.clipsToBounds = false
        
  
      userCell.lbljticketno.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        
//         userCell.lblname.text! = arrMyJTicket[indexPath.row]["name"] as? String ?? ""
//        
       let price = arrMyJTicket[indexPath.row]["price"] as? Double ?? 0
       
        
        
        
        userCell.lblprice.text! = "Redeemed @ CC \(price)"
        
        userCell.lbljticketno.text! = arrMyJTicket[indexPath.row]["ticket_number"] as? String ?? ""
       // userCell.lblwaitingno.text! = "\(arrMyJTicket[indexPath.row]["waiting"] as? Int ??
        
        let date = arrMyJTicket[indexPath.row]["ApplyDate"] as? String ?? ""
         if date != ""
         {
            userCell.lbldate.text! =   MyModel().convertStringDateToString(strDate:date,
                                                                           getFormate: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", returnFormat: "dd-MM-yyyy")
            
        }
         else{
            userCell.lbldate.text! =  ""
        }
        let status =  arrMyJTicket[indexPath.row]["status"] as! Int
        print(status)
        if status == 0 {
            
         userCell.btnapply.setTitle("Apply Now", for: .normal)
         userCell.btnapply.isUserInteractionEnabled = true
      //   userCell.lblwon.isHidden = true
     //    userCell.lblwinningprice.isHidden  = true
         userCell.btnapply.backgroundColor = #colorLiteral(red: 0.09803921569, green: 0.3098039216, blue: 0.3647058824, alpha: 1)
             userCell.vwhit.isHidden = true
        }
        else if status == 1 {
            
            let  waiting = arrMyJTicket[indexPath.row]["waiting"] as? Int ?? 0
            
            let price = arrMyJTicket[indexPath.row]["price"] as? Double ?? 0.00
            
            userCell.btnapply.setTitle("Current Waiting : \(waiting)" , for: .normal)
            userCell.btnapply.isUserInteractionEnabled = false
      //      userCell.lblwon.isHidden = true
     //       userCell.lblwinningprice.isHidden  = true
            userCell.btnapply.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            userCell.vwhit.isHidden = true
        }
        else if status == 2 {
        
//            userCell.lblwon.isHidden = false
//            userCell.lblwinningprice.isHidden  = false
     //       userCell.lblwinningprice.text! = "Rs" +
            
       //     "\(arrMyJTicket[indexPath.row]["WinningAmount"] as? Double ?? 0)"
            userCell.btnapply.setTitle("Cashback Received Rs.\(arrMyJTicket[indexPath.row]["WinningAmount"] as? Double ?? 0)", for: .normal)
            
            userCell.btnapply.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
 
            //            userCell.btnapply.backgroundColor = #colorLiteral(red: 0.1254901961, green: 0.6117647059, blue: 0.6196078431, alpha: 1)
            
            userCell.btnapply.isUserInteractionEnabled = false
             userCell.vwhit.isHidden = false
            userCell.lbldt.text = userCell.lbldate.text!
            
        }
      
        let imageURL = URL(string: arrMyJTicket[indexPath.row]["image"] as? String ?? "")
        userCell.imgjticket.sd_setImage(with: imageURL,placeholderImage:Define.PLACEHOLDER_PROFILE_IMAGE)
    
        
        return userCell

    }
    

    @IBAction func btn_back(_ sender: Any) {
          self.dismiss(animated: true)
    }
    @IBAction func redeemed_click(_ sender: UIBarButtonItem) {
        
      
    }
    @IBAction func applied_click(_ sender: UIBarButtonItem) {
       
    }
    @IBAction func hit_click(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func segmentchanged(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            self.arrMyJTicket = self.MainarrMyJTicket.filter{($0["status"] as! Int) == 0}
                  
                  tbllistingMyjticket.reloadData()
            
           
          }
        else if sender.selectedSegmentIndex == 1 {
            self.arrMyJTicket = self.MainarrMyJTicket.filter{($0["status"] as! Int) == 1}
                   
                   tbllistingMyjticket.reloadData()
                 }
        else if sender.selectedSegmentIndex == 2 {
            self.arrMyJTicket = self.MainarrMyJTicket.filter{($0["status"] as! Int) == 2}
            
            tbllistingMyjticket.reloadData()
        }
        if arrMyJTicket.count > 0 {
                       tbllistingMyjticket.isHidden = false
            tbllistingMyjticket.setContentOffset(.zero, animated: true)
            tbllistingMyjticket.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableView.ScrollPosition.top, animated: true)
                   }
                   else
                   {
                      tbllistingMyjticket.isHidden = true
                   }
    }
    
}
class MyJticketlisting: UITableViewCell {
    
    
    @IBOutlet weak var imgjticketbackground: UIImageView!
    
    
    @IBOutlet weak var imgjticket: UIImageView!
    @IBOutlet weak var lblname: UILabel!
    
    @IBOutlet weak var lblwaitingno: UILabel!
    
    @IBOutlet weak var lbldate: UILabel!
    
    @IBOutlet weak var lbljticketno: UILabel!
    
    @IBOutlet weak var lblprice: UILabel!
    
    @IBOutlet weak var btnapply: UIButton!
    
    @IBOutlet weak var lblwinningprice: UILabel!
    
    @IBOutlet weak var lblwon: UILabel!
    
    @IBOutlet var vwhit: UIView!
    @IBOutlet var lbldt: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
         vwhit.transform = CGAffineTransform(rotationAngle: 125 )
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}
extension MyJticketViewController {
    // Mark API For Getting ALLJticket
    func getUserJticket()  {
        if isFirstTime {
            Loading().showLoading(viewController: self)
        }
        let strURL = Define.APP_URL + Define.getUserJTicket
        print("URL: \(strURL)")
        
        SwiftAPI().postMethodSecure(stringURL: strURL,
                                    parameters: nil,
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
                    self.MainarrMyJTicket = content["contest"] as? [[String : Any]] ?? [[:]]
                    
                    self.arrMyJTicket = self.MainarrMyJTicket.filter{($0["status"] as! Int) == 0}
                    
                    print(self.arrMyJTicket)
                    print(content)
                    
                    let APD = "\(apddict.value(forKey:"ADP") as? String ?? "0.00")"
                    
                    guard let amountPB = Double(APD) else {
                              return
                          }
                    self.lblapd.text = MyModel().getCurrncy(value: amountPB)
                    
                   // self.lblapd.text! = "₹" + "\(Double(APD)!.rounded(toPlaces:2))"
                 
                    self.lblApdrefresh.text = "Your APD Cycle refreshes on " + "\(apddict.value(forKey:"DayOfJoin") as? Int ?? 0)th" + " of every month"


                  
                
                    print(self.lblapd.text!)
                    self.tbllistingMyjticket.reloadData()
                    
                    
                    
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
    
    
    
   
    //Mark APi For Applying Jticket
    
    func ApplyJticket() {
        
        Loading().showLoading(viewController: self)
        
        let parameter: [String: Any] = [
            
            "id":id
            
        ]
        let strURL = Define.APP_URL + Define.ApplyJtciket
        print("Parameter: \(parameter)\nURL: \(strURL)")
        
        let jsonString = MyModel().getJSONString(object: parameter)
        let encriptString = MyModel().encrypting(strData: jsonString!, strKey: Define.KEY)
        let strBase64 = encriptString.toBase64()
        
        SwiftAPI().postMethodSecure(stringURL: strURL,
                                    parameters: ["data": strBase64!],
                                    header: Define.USERDEFAULT.value(forKey: "AccessToken") as? String,
                                    auther: Define.USERDEFAULT.value(forKey: "UserID") as? String)
        { (result, error) in
            if error != nil {
                Loading().hideLoading(viewController: self)
                print("Error: \(error!.localizedDescription)")
                self.retry()
            } else {
                Loading().hideLoading(viewController: self)
                print("Result: \(result!)")
                let status = result!["statusCode"] as? Int ?? 0
                if status == 200 {
                    
                    
                    self.tbllistingMyjticket.reloadData()
                    let alertController = UIAlertController(title:"Alert",
                                                            message: result!["message"] as! String,
                                                            preferredStyle: .alert)
                    let ok = UIAlertAction(title: "OK", style: .default, handler: { action in   self.OkPressed()})
                    alertController.addAction(ok)
                    self.present(alertController, animated: true, completion: nil)
                    
                    print(self.arrMyJTicket)
                    
                    
                } else if status == 401 {
                    Define.APPDELEGATE.handleLogout()
                } else {
                    Alert().showAlert(title: "Alert",
                                      message: result!["message"] as! String,
                                      viewController: self)
                }
            }
        }
    }
    func OkPressed(){
//        let jticketwaitinglist = self.storyboard?.instantiateViewController(withIdentifier: "JticketWaitingListViewController") as! JticketWaitingListViewController
//        //  gamePlayVC.isFromNotification = true
//        jticketwaitinglist.id = jticketid
//        self.present(jticketwaitinglist, animated: true, completion: nil)
        
        getUserJticket()
    }
    
    @objc func btnapply(_ sender: Any, event: Any) {
        
        
        let point : CGPoint = (sender as AnyObject).convert(CGPoint.zero, to:tbllistingMyjticket)
        var indexPath =  self.tbllistingMyjticket!.indexPathForRow(at: point)
        var selectedrow = indexPath!.row


        id =  (arrMyJTicket[selectedrow] as AnyObject).value(forKey:"id") as! Int
        jticketid = (arrMyJTicket[selectedrow] as AnyObject).value(forKey:"j_ticket_id") as! Int
        ApplyJticket()
      

    }


}
//MARK: - Notifcation Delegate Method
//extension ReferralViewController: UNUserNotificationCenterDelegate {
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


extension MyJticketViewController {
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

//
//  JticketWaitingListViewController.swift
//  CBit
//
//  Created by My Mac on 18/12/19.
//  Copyright © 2019 Bhavik Kothari. All rights reserved.
//

import UIKit

class JticketWaitingListViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var imgjticket: UIImageView!
    
    private var isFirstTime = Bool()
    
    @IBOutlet weak var lblCurrentWaitingperiod: UILabel!
    
    @IBOutlet weak var tblwaitinglist: UITableView!
    
    var id = 0
    private var arrJticketwaitinglist = [[String: Any]]()
    
    var Start = 0
    var Limit = 30
    var ismoredata = false
    
    override func viewDidLoad()
    {
         super.viewDidLoad()

         isFirstTime = true

         getJticketWaitingList()
        
    }
    
    
  

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrJticketwaitinglist.count
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let userCell = tableView.dequeueReusableCell(withIdentifier: "Jticketwaitinglisting") as! Jticketwaitinglisting
        
      userCell.lblusername.text! = arrJticketwaitinglist[indexPath.row]["userName"] as? String ?? "No Name"
      userCell.lbljticketno.text = arrJticketwaitinglist[indexPath.row]["ticket_number"] as? String ?? "Not Available"
        
     
      userCell.jticketwaitingno.text! =  "\(arrJticketwaitinglist[indexPath.row]["waiting"] as? Int ?? 0)"
        
      let date = arrJticketwaitinglist[indexPath.row]["ApplyDate"] as? String ?? ""
        
        if date != ""  {
        
      userCell.lblappliedDate.text! =  MyModel().convertStringDateToString(strDate:date,
                                            getFormate: "yyyy-MM-dd'T'HH:mm:ss.SSSZ",
                                            returnFormat: "h:mm a dd-MM-yyyy")
        }
        
        if arrJticketwaitinglist.count > 1 {
            let lastElement = arrJticketwaitinglist.count - 1
            if indexPath.row == lastElement && ismoredata{
                //call get api for next page
                getJticketWaitingList()
            }

        }

   
        
        return userCell
        
        
        
        
    }
  
    
    
    @IBAction func btn_back(_ sender: Any) {
          self.dismiss(animated: true)
    }
    
}
class Jticketwaitinglisting: UITableViewCell {
    
  
    
    @IBOutlet weak var viewjticketlisting: ViewWithShadow!
    
    @IBOutlet weak var lblusername: UILabel!
    
 
    
    @IBOutlet weak var lbljticketno: UILabel!
    
    @IBOutlet weak var lblappliedDate: UILabel!
    
    @IBOutlet weak var jticketwaitingno: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}

extension JticketWaitingListViewController
{
    // Mark API For Getting ALLJticket
    func getJticketWaitingList() {
        
        Loading().showLoading(viewController: self)
        
        let parameter: [String: Any] = [
            
            "id":id,
            "start": Start,
            "limit":Limit
            
        ]
        let strURL = Define.APP_URL + Define.getWaitingroom
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
                    
                    let content = result!["content"] as! [String: Any]
                    //  self.arrJticketwaitinglist = content["contest"] as? [[String : Any]] ?? [[:]]
                    
                    let arr =  content["contest"] as? [[String : Any]] ?? [["":""]]
                    if arr.count > 0 {
                        self.arrJticketwaitinglist.append(contentsOf: arr)
                        self.ismoredata = true
                        self.Start = self.Start + 30
                        self.Limit =  30
                    }
                    else
                    {
                        self.ismoredata = false
                    }
                    
                    if self.arrJticketwaitinglist.count > 0 {
                        
                        self.lblCurrentWaitingperiod.text = content["currentWaitingPeriod"] as? String ?? ""
                        
                        let imageURL = URL(string: self.arrJticketwaitinglist[0]["image"] as? String ?? "")
                        let data = try? Data(contentsOf: imageURL!)
                        self.imgjticket.image = UIImage(data: data!)
                    }
                    
                    print(self.arrJticketwaitinglist)
                    self.tblwaitinglist.reloadData()
                    
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
    //Mark APi For Adding Jticket
    
//
//    @objc func btnredeem(_ sender: Any, event: Any) {
//        let point : CGPoint = (sender as AnyObject).convert(CGPoint.zero, to:tbllisting)
//        var indexPath =  self.tbllisting!.indexPathForRow(at: point)
//        var selectedrow = indexPath!.row
//
//        price = (arrjtickets[selectedrow] as AnyObject).value(forKey: "price") as! Int
//
//        id =  (arrjtickets[selectedrow] as AnyObject).value(forKey: "id") as! Int
//
//        AddJTicket()
    
        
        
        
        
        
        
        
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


extension JticketWaitingListViewController {
   
    func retry() {
        
        let alertController = UIAlertController(title: Define.ERROR_TITLE,
                                                message: Define.ERROR_SERVER,
                                                preferredStyle: .alert)
        let buttonRetry = UIAlertAction(title: "Retry",
                                        style: .default)
        { _ in
            self.getJticketWaitingList()
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

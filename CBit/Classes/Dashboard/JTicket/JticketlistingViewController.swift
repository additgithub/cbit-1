//
//  JticketlistingViewController.swift
//  CBit
//
//  Created by My Mac on 18/12/19.
//  Copyright © 2019 Bhavik Kothari. All rights reserved.
//

import UIKit

import ActionSheetPicker_3_0

class JticketlistingViewController: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    
    
    @IBOutlet weak var lblearningmetre: UILabel!
    @IBOutlet weak var lblearningmeter: UILabel!
    
    @IBOutlet weak var tbllisting: UITableView!
    
    @IBOutlet var JticketPopUp: UIView!
    @IBOutlet var txtqty: UITextField!
    @IBOutlet var lblavailablecc: UILabel!
    @IBOutlet var lblredeemcc: UILabel!
    @IBOutlet var btnredeem: UIButton!
    
    private var isFirstTime = Bool()
    
    private var arrjtickets = [[String: Any]]()
    var timer:Timer?
    var price:Double  = 0.00
    var id = 0
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrjtickets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        let userCell = tableView.dequeueReusableCell(withIdentifier: "Jticketlisting") as! Jticketlisting
        userCell.btnredeem.addTarget(self, action: #selector(btnredeem(_:event:)), for: .touchUpInside)
          userCell.btnwaitinglist.addTarget(self, action: #selector(btnWaitinglist(_:event:)), for: .touchUpInside)
        
        let purchaseprice = arrjtickets[indexPath.row]["price"] as? Double ?? 0.00
        
        
        let boldText = "\(String(format: "%.2f", purchaseprice))"
      
//        let myBlue = UIColor(red: 62.0/255, green: 174.0/255, blue: 206.0/255, alpha: 1.0)
//        let myGreen = UIColor(red: 110.0/255, green: 186.0/255, blue: 64.0/255, alpha: 1.0)
//        let myRed = UIColor(red: 247.0/255, green: 118.0/255, blue: 113.0/255, alpha: 1.0)
//        let myYellow = UIColor(red: 255.0/255, green: 190.0/255, blue: 106.0/255, alpha: 1.0)
//        userCell.lblpurchaseprice.backgroundColor = random(colors: [myBlue, myRed, myGreen, myYellow])
        
        userCell.lblpurchaseprice.text  = boldText
     
        userCell.lblname.text! = arrjtickets[indexPath.row]["name"] as? String ?? ""
        
        
        let redemptionfrom = arrjtickets[indexPath.row]["redenption_from"] as? Double ?? 0.00
        let redemptionto = arrjtickets[indexPath.row]["redenption_to"] as? Double ?? 0.00
  
        let boldtext1 = "₹ " + "\(String(format: "%.2f", redemptionto))"
   
        
        userCell.lblCurrentRedemptionvalue.text = boldtext1
      
        
        
        
        let imageURL = URL(string: arrjtickets[indexPath.row]["image"] as? String ?? "")
        userCell.imgjticket.sd_setImage(with: imageURL, placeholderImage: Define.PLACEHOLDER_PROFILE_IMAGE)
        
      //  userCell.imgjticket.sd_setImage(with:imageURL,
                             //    placeholderImage: Define.PLACEHOLDER_PROFILE_IMAGE1)
        
        return userCell
        
        
        
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        let jticketwaitinglists = self.storyboard?.instantiateViewController(withIdentifier: "MyJticketViewController") as! MyJticketViewController
//        //  gamePlayVC.isFromNotification = true
//        self.present(jticketwaitinglists, animated: true, completion: nil)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        
        isFirstTime = true
        
        let ccAmount = "\(Define.USERDEFAULT.value(forKey:"ccAmount")!)"
        guard let amountCC = Double(ccAmount) else {
            return
        }
        
        lblccvalue.text! =  "CC " + MyModel().getNumbers(value:amountCC)
       
        
        
   //     lblccvalue.text! =   "\(Define.USERDEFAULT.value(forKey:"ccAmount")!)"
        
        
        //    UNUserNotificationCenter.current().delegate = self
        //Set Notification
//
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(handleNotification),
//                                               name: .updateHistory,
//                                               object: nil)
        
        timer = Timer.scheduledTimer(timeInterval:30,
                                     target: self,
                                     selector: #selector(handleTimer),
                                     userInfo: nil,
                                     repeats: true)
        
        getJticket()
        // Do any additional setup after loading the view.
       
    }
    
  
    @IBAction func editingchanged(_ sender: UITextField) {
        
        let ccAmount1 = "\(Define.USERDEFAULT.value(forKey:"ccAmount")!)"
                                         guard let amountCC = Double(ccAmount1) else {
                                             return
                                         }
        let qty =   NumberFormatter().number(from: txtqty.text ?? "0")?.doubleValue ?? 0
        let multi = (price * Double(qty))
         lblredeemcc.text = "Redeem quantity value CC : \(String(format: "%.2f", multi))"
        if (multi <= Double(ccAmount1)!) {
                   lblredeemcc.textColor = #colorLiteral(red: 0.2039215686, green: 0.7803921569, blue: 0.3490196078, alpha: 1)
                   btnredeem.isEnabled = true
                   btnredeem.alpha = 1.0
               }
               else
               {
                  lblredeemcc.textColor = #colorLiteral(red: 0.8901960784, green: 0, blue: 0.0862745098, alpha: 1)
                   btnredeem.isEnabled = false
                   btnredeem.alpha = 0.5
               }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let ccAmount = "\(Define.USERDEFAULT.value(forKey:"ccAmount")!)"
        guard let amountCC = Double(ccAmount) else {
            return
        }
        
        lblccvalue.text! =  "CC " + MyModel().getNumbers(value:amountCC)
        
    }
    @IBOutlet weak var lblccvalue: UILabel!
    @objc func handleTimer() {
        
        getJticket()
    }
    
    
    @objc func handleNotification() {
        if !MyModel().isConnectedToInternet() {
            Alert().showTost(message: Define.ERROR_INTERNET,
                             viewController: self)
        } else {
            getJticket()
        }
    
    }
    
    
    @IBAction func btn_back(_ sender: Any) {
        
          self.dismiss(animated: true)
    }
    
    @IBAction func btnapply_click(_ sender: UIButton) {
        
        
        
        if txtqty.text != "" {
            JticketPopUp.isHidden = true
                  AddJTicket()
              }
              else
              {
                  Alert().showAlert(title: "Error",
                                                       message: "Please select quantity",
                                                       viewController: self)
              }
    }
    @IBAction func btncancel_click(_ sender: UIButton) {
        JticketPopUp.isHidden = true
    }
    @IBAction func btnqty_click(_ sender: UIButton) {
        
//        ActionSheetMultipleStringPicker.show(withTitle: "Multiple String Picker", rows: [
//            ["One", "Two", "A lot"],
//            ["Many", "Many more", "Infinite"]
//            ], initialSelection: [2, 2], doneBlock: {
//                picker, indexes, values in
//
//                print("values = \(values)")
//                print("indexes = \(indexes)")
//                print("picker = \(picker)")
//                return
//        }, cancel: { ActionMultipleStringCancelBlock in return }, origin: sender)
        
        ActionSheetStringPicker.show(withTitle: "Select Quantity", rows: ["1","2","3","4","5"], initialSelection: 0, doneBlock:
            {
         picker, indexes, values in
        
                print("values = \(values ?? "")")
                        print("indexes = \(indexes)")
                print("picker = \(String(describing: picker))")
                self.txtqty.text = (values ?? "") as? String
                        return
                }, cancel: { ActionMultipleStringCancelBlock in return }, origin: sender)
    }
    
}

class Jticketlisting: UITableViewCell {
    
  
    @IBOutlet weak var viewjticket: UIView!
    
    @IBOutlet weak var imgjticket: ImageViewProfile!
    @IBOutlet weak var lblpurchaseprice: UILabel!
    
    @IBOutlet weak var lblCurrentRedemptionvalue: UILabel!
    
    @IBOutlet weak var lblname: UILabel!
    
    @IBOutlet weak var btnredeem: UIButton!
    
    @IBOutlet weak var btnwaitinglist: UIButton!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}
extension JticketlistingViewController {
   // Mark API For Getting ALLJticket
    func getJticket()  {
        if isFirstTime {
            Loading().showLoading(viewController: self)
        }
        let strURL = Define.APP_URL + Define.GET_AllJticket
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
                self.getJticket()
            } else {
                if self.isFirstTime {
                    self.isFirstTime = false
                    Loading().hideLoading(viewController: self)
                }
                print("Result: \(result!)")
                let status = result!["statusCode"] as? Int ?? 0
                if status == 200 {
                 
                 
                    let content = result!["content"] as! [String: Any]
                    let metervalues : NSDictionary = result!["content"] as? NSDictionary ?? [:]
                    
                    
                    self.arrjtickets = content["contest"] as? [[String : Any]] ?? [[:]]
                    
                    let entryfeemeter = "\(metervalues.value(forKey: "TotalEarning") as? NSNumber ?? 0)"
                     let earningmeter = "\(metervalues.value(forKey: "TotalEntry") as? NSNumber ?? 0)"
                    
                    guard let entryfeemeter1 = Double(entryfeemeter) else {
                                                 return
                                             }
                    guard let earningmeter1 = Double(earningmeter) else {
                                                                return
                                                            }
                    
                 self.lblearningmetre.text = MyModel().getCurrncy(value:entryfeemeter1)
                  self.lblearningmeter.text = MyModel().getCurrncy(value:earningmeter1)
                    
                    
//                    self.lblearningmetre.text = "₹" + "\(entryfeemeter)"
//                    self.lblearningmeter.text = "₹" + "\(earningmeter)"
                    
                    print(self.arrjtickets)
                    self.tbllisting.reloadData()
                    
                  
                    
                    
                    
                    
                } else if status == 401 {
                    
               //     Define.APPDELEGATE.handleLogout()
                    
                    
                    
                } else {
                    
                    Alert().showAlert(title: "Error",
                                      message: result!["message"] as! String,
                                      viewController: self)
                }
            }
        }
    }
    //Mark APi For Adding Jticket
    
    func AddJTicket() {
        Loading().showLoading(viewController: self)
        let parameter: [String: Any] = [
            "price": price,
            "id":id,
            "qty":txtqty.text!
          
        ]
        let strURL = Define.APP_URL + Define.ADD_Jticket
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
                    let wallet = content["wallate"] as! [String: Any]
                    let ccAmount = wallet["ccAmount"] as! Double
                      Define.USERDEFAULT.set(wallet["ccAmount"] as? Double ?? 0.0, forKey: "ccAmount")
                    let ccAmount1 = "\(Define.USERDEFAULT.value(forKey:"ccAmount")!)"
                           guard let amountCC = Double(ccAmount1) else {
                               return
                           }
                           
                    self.lblccvalue.text! =  "CC " + MyModel().getNumbers(value:amountCC)
                           
                    let alertController = UIAlertController(title:"Alert",
                                                            message: result!["message"] as! String,
                                                            preferredStyle: .alert)
                    let ok = UIAlertAction(title: "OK", style: .default, handler: { action in   self.OkPressed()})
                        
                  alertController.addAction(ok)
                    self.present(alertController, animated: true, completion: nil)
                    
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
//        let myjticket = self.storyboard?.instantiateViewController(withIdentifier: "MyJticketViewController") as! MyJticketViewController
//        //  gamePlayVC.isFromNotification = true
//        self.present(myjticket, animated: true, completion: nil)
       getJticket()
    }
    @objc func btnredeem(_ sender: Any, event: Any) {
        let point : CGPoint = (sender as AnyObject).convert(CGPoint.zero, to:tbllisting)
        let indexPath =  self.tbllisting!.indexPathForRow(at: point)
        let selectedrow = indexPath!.row
        
        price = (arrjtickets[selectedrow] as AnyObject).value(forKey: "price") as! Double
       
         id =  (arrjtickets[selectedrow] as AnyObject).value(forKey:"id") as! Int
        
        // AddJTicket()
        
       
        
        lblredeemcc.text = "Redeem quantity value CC : \(price)"
        lblavailablecc.text = "Available \(lblccvalue.text ?? "0")"
        
        let ccAmount1 = "\(Define.USERDEFAULT.value(forKey:"ccAmount")!)"
                                  guard let amountCC = Double(ccAmount1) else {
                                      return
                                  }
        
        if (Double(ccAmount1)! - price) > 0 {
            lblredeemcc.textColor = #colorLiteral(red: 0.2039215686, green: 0.7803921569, blue: 0.3490196078, alpha: 1)
            btnredeem.isEnabled = true
            btnredeem.alpha = 1.0
        }
        else
        {
           lblredeemcc.textColor = #colorLiteral(red: 0.8901960784, green: 0, blue: 0.0862745098, alpha: 1)
            btnredeem.isEnabled = false
            btnredeem.alpha = 0.5
        }
        
        txtqty.text = "1"
        JticketPopUp.isHidden = false
    }
    
    @objc func btnWaitinglist(_ sender: Any, event: Any) {
        let point : CGPoint = (sender as AnyObject).convert(CGPoint.zero, to:tbllisting)
        let indexPath =  self.tbllisting!.indexPathForRow(at: point)
        let selectedrow = indexPath!.row
        
        id =  (arrjtickets[selectedrow] as AnyObject).value(forKey: "id") as! Int
        
        let jticketwaitinglists = self.storyboard?.instantiateViewController(withIdentifier: "JticketWaitingListViewController") as! JticketWaitingListViewController
        //  gamePlayVC.isFromNotification = true
        jticketwaitinglists.modalPresentationStyle = .fullScreen
        jticketwaitinglists.id = id
        self.present(jticketwaitinglists, animated: true, completion: nil)
    }
    
    func random(colors: [UIColor]) -> UIColor {
        return colors[Int(arc4random_uniform(UInt32(colors.count)))]
        
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


extension JticketlistingViewController {
    func retry() {
        let alertController = UIAlertController(title: Define.ERROR_TITLE,
                                                message: Define.ERROR_SERVER,
                                                preferredStyle: .alert)
        let buttonRetry = UIAlertAction(title: "Retry",
                                        style: .default)
        { _ in
            self.getJticket()
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

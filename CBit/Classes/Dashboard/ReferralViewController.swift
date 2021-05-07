//
//  ReferralViewController.swift
//  CBit
//
//  Created by My Mac on 16/12/19.
//  Copyright © 2019 Bhavik Kothari. All rights reserved.
//

import UIKit
import UserNotifications




class ReferralViewController: UIViewController,UIGestureRecognizerDelegate {
    
    @IBOutlet weak var btninvite: UIButton!
    private var arrRefferaldetails = [String: Any]()
     private var isFirstTime = Bool()
    private var totalreferrals : Int = 0
   
    @IBOutlet weak var lblTotalReferals: UILabel!
    @IBOutlet weak var lbltotalinrhandouts: UILabel!
    
    @IBOutlet weak var lblrefcode: UILabel!
    private var arrrefferallist  = [[String:Any]]()
    
  
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        lblTotalReferals.isUserInteractionEnabled = true
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self, action: #selector(didTapLabelDemo))
        lblTotalReferals.addGestureRecognizer(tap)
        tap.delegate = self
        
      
        
        
        btninvite.layer.cornerRadius = 15
        
        isFirstTime = true
    //    UNUserNotificationCenter.current().delegate = self
        //Set Notification
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleNotification),
                                               name: .updateHistory,
                                               object: nil)
        getHistoryListAPI()
        // Do any additional setup after loading the view.
    }
    
    
    
    @objc func handleNotification() {
        if !MyModel().isConnectedToInternet() {
            Alert().showTost(message: Define.ERROR_INTERNET,
                             viewController: self)
        } else {
            getHistoryListAPI()
        }
    }
    
    

    @IBAction func btn_Invite(_ sender: Any) {
       
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
        
        
      
        if NSURL(string:"https://cbitoriginal.com/") != nil
                       
                    {
                       
                      
                let url1 =  "Hey there! \n\n"
 

                let url2 = UserDefaults.standard.value(forKey:"Referralcode")! as? String
                       
                let url4 = "Install the ‘CBIT Original’ Gaming App with my referral code - " + "*" + (url2 ?? "") + "*"
                      
                        
                let url3 = "\n\n• Worlds shortest,easiest and original games! \n• Auto apply Cashback on loosing! \n• Refer & Earn Random commission upto 9 levels! \n\nClick on the link to download the app- www.cbitoriginal.com \n\nHurry! Download it now!"

            
                
                        
        
            let appendString  = "\(url1)\(url4)\(url3)"
                        
                        
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
    
    @objc func didTapLabelDemo(sender: UITapGestureRecognizer)
    {
        
        if totalreferrals == 0
        {
        Alert().showTost(message: "List is Empty", viewController: self)
           
        }
        else {
            
            let Referral = self.storyboard?.instantiateViewController(withIdentifier: "ReferrallistingViewController") as! ReferrallistingViewController
            //  gamePlayVC.isFromNotification = true
            Referral.arrUsers = arrrefferallist
            self.present(Referral, animated: true, completion: nil)
            
        }
    }
    
    @IBAction func btn_back(_ sender: UIButton) {

         self.dismiss(animated:true)
        // sideMenuController?.revealMenu()
}
    
    
}
extension ReferralViewController {
    func getHistoryListAPI()  {
        if isFirstTime {
            Loading().showLoading(viewController: self)
        }
        let strURL = Define.APP_URL + Define.GET_REFERRALDETAILS
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
                self.getHistoryListAPI()
            } else {
                if self.isFirstTime {
                    self.isFirstTime = false
                    Loading().hideLoading(viewController: self)
                }
                print("Result: \(result!)")
                let status = result!["statusCode"] as? Int ?? 0
                if status == 200 {
              
                self.arrRefferaldetails = result!["content"] as! [String: Any]
                print(self.arrRefferaldetails)
                    
               
                    self.totalreferrals = self.arrRefferaldetails["ReferralTotal"] as! Int
                    let totalINR = self.arrRefferaldetails["ReferralAmount"] as? String ?? ""
                    self.arrrefferallist = self.arrRefferaldetails["ReferralList"] as! [[String:Any]]
                    print(self.arrrefferallist)
                    
                    self.lblTotalReferals.text! = "Total Referrals - " + "\(self.totalreferrals)"
                    self.lbltotalinrhandouts.text! = "Total INR handouts received - " + totalINR
                    self.lblrefcode.text! = UserDefaults.standard.string(forKey:"Referralcode") ?? "No Refferal"
                    
                
                    
                    
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
extension ReferralViewController {
    func retry() {
        let alertController = UIAlertController(title: Define.ERROR_TITLE,
                                                message: Define.ERROR_SERVER,
                                                preferredStyle: .alert)
        let buttonRetry = UIAlertAction(title: "Retry",
                                        style: .default)
        { _ in
            self.getHistoryListAPI()
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
extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension String {
    func attributedStringWithColor(_ strings: [String], color: UIColor, characterSpacing: UInt? = nil) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        for string in strings {
            let range = (self as NSString).range(of: string)
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        }

        guard let characterSpacing = characterSpacing else {return attributedString}

        attributedString.addAttribute(NSAttributedString.Key.kern, value: characterSpacing, range: NSRange(location: 0, length: attributedString.length))

        return attributedString
    }
}

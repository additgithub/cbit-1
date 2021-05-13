//
//  AutomationViewController.swift
//  CBit
//
//  Created by My Mac on 18/08/20.
//  Copyright © 2020 Bhavik Kothari. All rights reserved.
//

import UIKit
import UserNotifications

class AutomationViewController: UIViewController {
    //MARK: - Properties
    @IBOutlet weak var switchAutoPilot: UISwitch!
    @IBOutlet var switchReedem: UISwitch!
    @IBOutlet weak var textviewinfo: UITextView!
    
    
    //MARK: - Default Method
    override func viewDidLoad() {
        super.viewDidLoad()
        UNUserNotificationCenter.current().delegate = self
        if Define.USERDEFAULT.bool(forKey: "AutoPilot") {
            switchAutoPilot.isOn = true
        } else {
            switchAutoPilot.isOn = false
        }
        
        if Define.USERDEFAULT.bool(forKey: "isRedeem") {
            switchReedem.isOn = true
        } else {
            switchReedem.isOn = false
        }
        
        self.setAutopilotSwitchBackground(isOn: Define.USERDEFAULT.bool(forKey: "AutoPilot"))
        self.setRedeemSwitchBackground(isOn: Define.USERDEFAULT.bool(forKey: "isRedeem"))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //labelVarsion.text = "Version: 3.30"
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        switchAutoPilot.layer.cornerRadius = switchAutoPilot.frame.height / 2
        switchAutoPilot.layer.masksToBounds = true
        
        switchReedem.layer.cornerRadius = switchReedem.frame.height / 2
        switchReedem.layer.masksToBounds = true
        getautopilotcontent()
    }
    //MARK: - Switch Method
    @IBAction func switchNotification(_ sender: UISwitch) {
        AutoPilotModeAPI(isSet: sender.isOn)
    }
    @IBAction func switchredeem(_ sender: UISwitch) {
        REDEEMAPI(isSet: sender.isOn)
    }
    
    //MARK: - Button Method
    @IBAction func buttonMenu(_ sender: Any) {
       // sideMenuController?.revealMenu()
         self.dismiss(animated: true)
    }
    
    func setAutopilotSwitchBackground(isOn: Bool) {
        if isOn {
           switchAutoPilot.backgroundColor = #colorLiteral(red: 0.1019607843, green: 0.3098039216, blue: 0.3647058824, alpha: 1)
        } else {
            switchAutoPilot.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        }
    }
    func setRedeemSwitchBackground(isOn: Bool) {
        if isOn {
           switchReedem.backgroundColor = #colorLiteral(red: 0.1019607843, green: 0.3098039216, blue: 0.3647058824, alpha: 1)
        } else {
            switchReedem.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        }
    }
}

//MARK: - API
extension AutomationViewController {
    func AutoPilotModeAPI(isSet: Bool) {
        Loading().showLoading(viewController: self)
        let parameter: [String: Any] = ["autoPilot": isSet ? "1" : "0"]
        let strURL = Define.APP_URL + Define.API_AUTOPILOTUPDATE
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
                self.switchAutoPilot.isOn = !self.switchAutoPilot.isOn
                print("AutoPilotError: \(error!.localizedDescription)")
                self.retry()
            } else {
                Loading().hideLoading(viewController: self)
                print("AutoPilotResult: \(result!)")
                let status = result!["statusCode"] as? Int ?? 0
                if status == 200 {
                    let dictData = result!["contest"] as! [String: Any]
                    let AutoPilot = dictData["AutoPilot"] as? Bool ?? false
                    Define.USERDEFAULT.set(AutoPilot, forKey: "AutoPilot")
                    
                    let isRedeem = dictData["isRedeem"] as? Bool ?? false
                    Define.USERDEFAULT.set(isRedeem, forKey: "isRedeem")
                    
                          if Define.USERDEFAULT.bool(forKey: "AutoPilot") {
                                                        self.switchAutoPilot.isOn = true
                                                     //   self.switchReedem.isOn = false
                                                    } else {
                                                        self.switchAutoPilot.isOn = false
                                                       // self.switchReedem.isOn = true
                                                    }
                                 
                                 if Define.USERDEFAULT.bool(forKey: "isRedeem") {
                                     self.switchReedem.isOn = true
                                   //  self.switchAutoPilot.isOn = false
                                 } else {
                                     self.switchReedem.isOn = false
                                    // self.switchAutoPilot.isOn = true
                                 }
                    
                    self.setAutopilotSwitchBackground(isOn: AutoPilot)
                    self.setRedeemSwitchBackground(isOn: isRedeem)
                } else if status == 401 {
                    Define.APPDELEGATE.handleLogout()
                } else {
                    self.switchAutoPilot.isOn = !self.switchAutoPilot.isOn
                    Alert().showAlert(title: "Error",
                                      message: result!["message"] as? String ?? Define.ERROR_SERVER,
                                      viewController: self)
                }
            }
        }
    }
    
    func REDEEMAPI(isSet: Bool) {
        Loading().showLoading(viewController: self)
        let parameter: [String: Any] = ["isRedeem": isSet ? "1" : "0"]
        let strURL = Define.APP_URL + Define.API_REDEEMDAILYQOUTAUPDATE
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
                self.switchReedem.isOn = !self.switchReedem.isOn
                print("RedeemError: \(error!.localizedDescription)")
                self.Redeemretry()
            } else {
                Loading().hideLoading(viewController: self)
                print("RedeemResult: \(result!)")
                let status = result!["statusCode"] as? Int ?? 0
                if status == 200 {
                    
                    let dictData = result!["contest"] as! [String: Any]
                    
                        let AutoPilot = dictData["AutoPilot"] as? Bool ?? false
                        Define.USERDEFAULT.set(AutoPilot, forKey: "AutoPilot")
                                  
                        let isRedeem = dictData["isRedeem"] as? Bool ?? false
                        Define.USERDEFAULT.set(isRedeem, forKey: "isRedeem")
                    
                    if Define.USERDEFAULT.bool(forKey: "AutoPilot") {
                                           self.switchAutoPilot.isOn = true
                                        //   self.switchReedem.isOn = false
                                       } else {
                                           self.switchAutoPilot.isOn = false
                                          // self.switchReedem.isOn = true
                                       }
                    
                    if Define.USERDEFAULT.bool(forKey: "isRedeem") {
                        self.switchReedem.isOn = true
                      //  self.switchAutoPilot.isOn = false
                    } else {
                        self.switchReedem.isOn = false
                       // self.switchAutoPilot.isOn = true
                    }
                    
                     self.setAutopilotSwitchBackground(isOn: AutoPilot)
                    self.setRedeemSwitchBackground(isOn: isRedeem)
                    
                } else if status == 401 {
                    Define.APPDELEGATE.handleLogout()
                } else {
                    self.switchReedem.isOn = !self.switchReedem.isOn
                    Alert().showAlert(title: "Error",
                                      message: result!["message"] as? String ?? Define.ERROR_SERVER,
                                      viewController: self)
                }
            }
        }
    }
    
    func getautopilotcontent()  {
      
        let strURL = Define.APP_URL + Define.getautopilotcontent
        print("URL: \(strURL)")
        
        
        SwiftAPI().postMethodSecure(stringURL: strURL,
                                    parameters: nil,
                                    header: Define.USERDEFAULT.value(forKey: "AccessToken") as? String,
                                    auther: Define.USERDEFAULT.value(forKey: "UserID") as? String)
        { (result, error) in
            if error != nil {
        
                print("Error: \(error!)")
                self.getautopilotcontent()
            } else {
         
                print("Result: \(result!)")
                
                let status = result!["statusCode"] as? Int ?? 0
                if status == 200 {
                    
                    let content = result!["content"] as? [String: Any] ?? [:]
                //    let apddict : NSDictionary = result!["content"] as! NSDictionary
                  
                    self.textviewinfo.text = content["contest"] as? String
                    
                    print(content)
                    
                    
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

//MARK: - Alert Contollert
extension AutomationViewController {
    func retry() {
        let alertController = UIAlertController(title: Define.ERROR_TITLE,
                                                message: Define.ERROR_SERVER,
                                                preferredStyle: .alert)
        let buttonRetry = UIAlertAction(title: "Retry",
                                        style: .default)
        { _ in
            self.AutoPilotModeAPI(isSet: !self.switchAutoPilot.isOn)
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
    
    func Redeemretry() {
           let alertController = UIAlertController(title: Define.ERROR_TITLE,
                                                   message: Define.ERROR_SERVER,
                                                   preferredStyle: .alert)
           let buttonRetry = UIAlertAction(title: "Retry",
                                           style: .default)
           { _ in
               self.REDEEMAPI(isSet: !self.switchReedem.isOn)
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

//MARK: - Notifcation Delegate Method
extension AutomationViewController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        switch response.actionIdentifier {
        case Define.PLAYGAME:
            print("Play Game")
            let dictData = response.notification.request.content.userInfo as! [String: Any]
            print(dictData)
            let gamePlayVC = self.storyboard?.instantiateViewController(withIdentifier: "GamePlayVC") as! GamePlayVC
            gamePlayVC.isFromNotification = true
            gamePlayVC.dictContest = dictData
            self.navigationController?.pushViewController(gamePlayVC, animated: true)
        default:
            break
        }
        
    }
}


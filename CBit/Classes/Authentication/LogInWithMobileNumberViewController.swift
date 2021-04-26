//
//  LogInWithMobileNumberViewController.swift
//  CBit
//
//  Created by Mac on 18/06/20.
//  Copyright © 2020 Bhavik Kothari. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit


class LogInWithMobileNumberViewController: UIViewController {

    
       var dictSocialData = [String: Any]()
       var isSocialLogin = Bool()
    
       @IBOutlet weak var viewLogin: UIView!
       @IBOutlet weak var txtmobilenumber: TextFieldwithBorder!
     
       @IBOutlet weak var buttonLogin: UIButton!
        
       
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func buttonSignUp(_ sender: Any) {
           let signUpVC = self.storyboard?.instantiateViewController(withIdentifier: "RegisterVC") as! RegisterVC
           signUpVC.isSocialLogin = false
           signUpVC.modalPresentationStyle = .fullScreen
           self.navigationController?.pushViewController(signUpVC, animated: true)
       }
    
    @IBAction func buttonLogin(_ sender: Any) {
         
        isSocialLogin = false
            if !MyModel().isValidMobileNumber(value: txtmobilenumber.text!) || txtmobilenumber.text!.isEmpty {
                      Alert().showTost(message: "Enter Proper Mobile Number", viewController: self)
                  }else {
              loginMobileNoAPI()
          }
      }
    

    func getFBUserData(){
        if((AccessToken.current) != nil){
            GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                   if (error == nil){
                       //everything works print the user data
                       print("--> Facebook Data: ",result!)
                       
                       let dictResult = result as! [String: Any]
                       
                       self.dictSocialData = [
                           "UserID": dictResult["id"] as? String ?? "",
                           "FullName": dictResult["name"] as? String ?? "",
                           "FirstName": dictResult["first_name"] as? String ?? "",
                           "LastName": dictResult["last_name"] as? String ?? "",
                           "Email": dictResult["email"] as? String ?? "",
                           "ImageData": dictResult["picture"]!
                       ]
                       print("Social Data: \(self.dictSocialData)")
                    
                       self.loginMobileNoAPI()
                   }
               })
           }
       }
    
    @IBAction func buttonFacebook(_ sender: Any) {
        isSocialLogin = true
        let fbLoginManeger: LoginManager = LoginManager()
        fbLoginManeger.logIn(permissions: ["email"], from: self)
        { (result, error) in
            if (error == nil){
                let fbloginresult : LoginManagerLoginResult = result!
                // if user cancel the login
                if (result?.isCancelled)!{
                    return
                }
                if(fbloginresult.grantedPermissions.contains("email"))
                {
                    self.getFBUserData()
                }
            }
        }
    }
    
    @IBAction func buttonHowTOPlay(_ sender: Any) {
        
        
        let storyBoard = UIStoryboard(name: "Dashboard", bundle: nil)
        let tutorialVC = storyBoard.instantiateViewController(withIdentifier: "TutorialVC") as! TutorialVC
        tutorialVC.isFromeDashboard = true
        tutorialVC.modalPresentationStyle = .fullScreen
        self.present(tutorialVC, animated: true)
        {
            
        }
    }
    
    
    @IBAction func btn_LoginWithEmail(_ sender: Any) {
        
        let srotyboard = UIStoryboard(name: "Authentication", bundle: nil)
             let VC = srotyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
             self.navigationController?.pushViewController(VC, animated: true)
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension LogInWithMobileNumberViewController {
    func loginMobileNoAPI() {
        
       
        let appVersion = Define.APP_VERSION

        print(appVersion)
        
       
        
        let parameters:[String: Any] = ["mobile_no": txtmobilenumber.text!,"version":appVersion]
        let strURL = Define.APP_URL + Define.API_MOBILESIGNIN
                print("Parameter: \(parameters)\nURL: \(strURL)")
                
                let jsonString = MyModel().getJSONString(object: parameters)
                let encriptString = MyModel().encrypting(strData: jsonString!, strKey: Define.KEY)
                let strBase64 = encriptString.toBase64()
                
                SwiftAPI().postMethodSecure(stringURL: strURL,
                                            parameters: ["data": strBase64!],
                                            header: nil,
                                            auther: nil)
                { (result, error) in
                    if error != nil {
                        Loading().hideLoading(viewController: self)
                        print("Error: \(error!)")
        //                Alert().showAlert(title: "Error",
        //                                  message: Define.ERROR_SERVER,
        //                                  viewController: self)
                        self.loginMobileNoAPI()
                        
                    } else {
                        Loading().hideLoading(viewController: self)
                        print("Result: \(result!)")
                        let status = result!["statusCode"] as? Int ?? 0
                        if status == 200 {
                            let dictData = result!["content"] as! [String: Any]
                            
                            var parameter:[String: Any] = [
                                "mobile_no": self.txtmobilenumber.text!,
                                    "otp": "\(dictData["otp"]!)",
                                    "otpId": "\(dictData["otpId"]!)",
                                "deviceType" : "ios",
                               "deviceId": Define.USERDEFAULT.value(forKey: "FCMToken") as? String ?? "123",
                                "OneSignalID" : UserDefaults.standard.string(forKey:"OnesignalID") ?? "123456"
                                            ]
                        let srotyboard = UIStoryboard(name: "Authentication", bundle: nil)
                        let VC = srotyboard.instantiateViewController(withIdentifier: "OTPVerifyVC") as! OTPVerifyVC
                            VC.isFromMobile = true
                            VC.parameter = parameter
                        self.navigationController?.pushViewController(VC, animated: true)
                            
                           // self.parameter["otp"] = dictData["otp"]!
                           // self.parameter["otpId"] = dictData["otpId"]!
                            
                           // self.textOTP.text = "\(dictData["otp"]!)";
                            
                        }
                        else if status == 410
                        {
                            let alertController = UIAlertController(title:"Error", message: result!["message"] as? String, preferredStyle:UIAlertController.Style.alert)

                            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
                               { action -> Void in
                                let signUpVC = self.storyboard?.instantiateViewController(withIdentifier: "RegisterVC") as! RegisterVC
                                signUpVC.isSocialLogin = false
                                signUpVC.modalPresentationStyle = .fullScreen
                                self.navigationController?.pushViewController(signUpVC, animated: true)
                               })
                            self.present(alertController, animated: true, completion: nil)
                        }
                        else {
                            Alert().showAlert(title: "Error",
                                              message: result!["message"] as! String,
                                              viewController: self)
                        }
                    }
                }
        
}
    
    
     func loginAPI() {
            Loading().showLoading(viewController: self)
           
            var parameter:[String: Any] = ["deviceId": Define.USERDEFAULT.value(forKey: "FCMToken") as? String ?? "123","deviceType": "ios",
             "OneSignalID" : UserDefaults.standard.string(forKey:"OnesignalID") ?? "123456"]
            
            
            if isSocialLogin {
                parameter["social_Id"] = dictSocialData["UserID"]
                parameter["social_Type"] = "facebook"
            } else {
//                parameter["email"] = textEmail.text!
//                parameter["password"] = textPassword.text!
            }
            
           // let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String

            let appVersion = Define.APP_VERSION
        
            print(appVersion)
            
           
            parameter["version"] = appVersion
        
           
            
            
            let strURL = Define.APP_URL + Define.API_SIGNIN
            print("Parameter: \(parameter)\nURL: \(strURL)")
            
            let jsonString = MyModel().getJSONString(object: parameter)
            let encriptString = MyModel().encrypting(strData: jsonString!, strKey: Define.KEY)
            let strbase64 = encriptString.toBase64()
            
            SwiftAPI().postMethodSecure(stringURL: strURL,
                                        parameters: ["data":strbase64!],
                                        header: nil,
                                        auther: nil)
                
            { (result, error) in
                if error != nil {
                    Loading().hideLoading(viewController: self)
                    print("Error: \(error!.localizedDescription)")
    //                Alert().showAlert(title: "Error",
    //                                  message: Define.ERROR_SERVER,
    //                                  viewController: self)
                    self.loginAPI()
                } else {
                    Loading().hideLoading(viewController: self)
                    print("Result: \(result!)")
                    let status = result!["statusCode"] as? Int ?? 0
                    if status == 200 {
                        let dictData = result!["contest"] as! [String: Any]
                        MyModel().setUserData(userData: dictData)
                        
                        if self.isSocialLogin {
                            Define.USERDEFAULT.set(true, forKey: "isSocialLogin")
                            Define.USERDEFAULT.set(self.dictSocialData["UserID"] as! String, forKey: "SocialID")
                        }
                        let Refferalcode = dictData["ReferralCode"] as! String
                        UserDefaults.standard.set(Refferalcode, forKey: "Referralcode")
                       
                        
                        let storyBoard = UIStoryboard(name: "Dashboard", bundle: nil)
                        let menuVC = storyBoard.instantiateViewController(withIdentifier: "MenuNC")
                        menuVC.modalPresentationStyle = .fullScreen
                        self.present(menuVC,
                                     animated: true,
                                     completion:
                        {
//                            Define.USERDEFAULT.set(self.textPassword.text!, forKey: "Password")
//                            self.textEmail.text = nil
//                            self.textPassword.text = nil
            SocketIOManager.sharedInstance.establisConnection()
                            
                            
                        })
                    } else if status == 423 {
                        Alert().showAlert(title: "Account Locked",message: result!["message"] as? String ?? "No message available",
                        viewController: self)
                    }
                    else {
                        
                        if self.isSocialLogin {
                         
                            let signUpVC = self.storyboard?.instantiateViewController(withIdentifier: "RegisterVC") as! RegisterVC
                            signUpVC.isSocialLogin = self.isSocialLogin
                            signUpVC.dictSocialData = self.dictSocialData
                            signUpVC.modalPresentationStyle = .fullScreen
                            self.navigationController?.pushViewController(signUpVC, animated: true)
                            
                            
                        } else {
                            
                            Alert().showAlert(title: "Error",
                                              message: result!["message"] as? String ?? "No message available",
                                              viewController: self)
                       
                        }
                        
                    }
                }
            }
        }
    
    
}

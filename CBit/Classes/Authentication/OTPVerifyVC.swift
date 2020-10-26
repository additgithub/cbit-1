import UIKit





class OTPVerifyVC: UIViewController {
    //MARK: - Properties
    @IBOutlet weak var labelMobile: UILabel!
    @IBOutlet weak var textOTP: UITextField!
    @IBOutlet weak var buttonVerify: UIButton!
    
    var isFromMobile = Bool()
    var parameter = [String: Any]()
    
    var dictSocialData = [String: Any]()
    var isSocialLogin = Bool()
    
    //MARK: - Default Method
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        labelMobile.text = "Please enter Verification code send to \n +91 \(parameter["mobile_no"] as? String ?? "XXXXXXXXXX")"
        //textOTP.text = parameter["otp"] as? String
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        MyModel().roundCorners(corners: [.bottomLeft, .bottomRight], radius: 5, view: buttonVerify)
    }
    
    //MARK: - Button Method
    @IBAction func buttonBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func buttonVerify(_ sender: Any) {
        if isFromMobile {
        if textOTP.text!.isEmpty {
            Alert().showAlert(title: "Alert",
                              message: "Enter OTP",
                              viewController: self)
        } else {
            parameter["otp"] = textOTP.text!
            
            SignInUsingMobileNo()
        }
        
        }
        else{
            if textOTP.text!.isEmpty {
                Alert().showAlert(title: "Alert",
                                  message: "Enter OTP",
                                  viewController: self)
            } else {
                
                parameter["otp"] = textOTP.text!
                registerAPI()
                
            }
            
            //
            
        }
        
    }
    @IBAction func buttonResendCode(_ sender: Any) {
        if isFromMobile {
            resendOtp()
        }
        else{
        getOTPAPI()
        }
    }
}

//MARK: - API
extension OTPVerifyVC {
    
    func getOTPAPI() {
        let parameters:[String: Any] = ["mobile_no": self.parameter["mobile_no"]!,"email": self.parameter["email"]!]
        let strURL = Define.APP_URL + Define.API_GET_OTP
        print("Parameter: \(parameter)\nURL: \(strURL)")

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
                self.getOTPAPI()
            } else {
                Loading().hideLoading(viewController: self)
                print("Result: \(result!)")
                let status = result!["statusCode"] as? Int ?? 0
                if status == 200 {
                    let dictData = result!["content"] as! [String: Any]
                    self.parameter["otp"] = dictData["otp"]!
                    self.parameter["otpId"] = dictData["otpId"]!

                    self.textOTP.text = "\(dictData["otp"]!)";

                } else {
                    Alert().showAlert(title: "Error",
                                      message: result!["message"] as! String,
                                      viewController: self)
                }
            }
        }
    }
    
     func resendOtp() {
         
    // let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String

        let appVersion = Define.APP_VERSION
        
        
        print(appVersion)
        
        let parameters:[String: Any] = ["mobile_no": self.parameter["mobile_no"]!,"version":appVersion]
    //  , "email": self.parameter["email"]!]
        
            let strURL = Define.APP_URL + Define.API_MOBILESIGNIN
            print("Parameter: \(parameter)\nURL: \(strURL)")
            
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
                    self.getOTPAPI()
                } else {
                    Loading().hideLoading(viewController: self)
                    print("Result: \(result!)")
                    let status = result!["statusCode"] as? Int ?? 0
                    if status == 200 {
                        let dictData = result!["content"] as! [String: Any]
                        self.parameter["otp"] = dictData["otp"]!
                        self.parameter["otpId"] = dictData["otpId"]!
                        
                      //  self.textOTP.text = "\(dictData["otp"]!)";
                        
                    } else {
                        Alert().showAlert(title: "Error",
                                          message: result!["message"] as! String,
                                          viewController: self)
                    }
                }
            }
        }
    
    
    func registerAPI() {
        Loading().showLoading(viewController: self)
        let strURL = Define.APP_URL + Define.API_SIGNUP
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
                print("Error: \(error!)")
//                Alert().showAlert(title: "Error",
//                                  message: Define.ERROR_SERVER,
//                                  viewController: self)
                self.registerAPI()
            } else {
                Loading().hideLoading(viewController: self)
                print("Result: \(result!)")
                let status = result!["statusCode"] as? Int ?? 0
                if status == 200 {
                   
                    let dictData = result!["contest"] as! [String: Any]
                    MyModel().setUserData(userData: dictData)
                    let Refferalcode = dictData["ReferralCode"] as! String
                    UserDefaults.standard.set(Refferalcode, forKey: "Referralcode")
                    
                    if self.isSocialLogin {
                        
                        Define.USERDEFAULT.set(true, forKey: "isSocialLogin")
                        Define.USERDEFAULT.set(self.dictSocialData["UserID"] as! String, forKey: "SocialID")
                    
                    }
                    
                    Define.USERDEFAULT.set("\(self.parameter["password"]!)", forKey: "Password")
                    
                    
                    let kycVC = self.storyboard?.instantiateViewController(withIdentifier: "KYCVerifycationVC") as! KYCVerifycationVC
                    self.navigationController?.pushViewController(kycVC, animated: true)
                } else {
                    Alert().showAlert(title: "Error",
                                      message: result!["message"] as! String,
                                      viewController: self)
                }
            }
        }
    }
    
    
    func SignInUsingMobileNo() {
           
            Loading().showLoading(viewController: self)
            let strURL = Define.APP_URL + Define.API_OTPMOBILEVERIFY
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
                    print("Error: \(error!)")
    //                Alert().showAlert(title: "Error",
    //                                  message: Define.ERROR_SERVER,
    //                                  viewController: self)
                    self.SignInUsingMobileNo()
                } else {
                   Loading().hideLoading(viewController: self)
                           print("Result: \(result!)")
                           let status = result!["statusCode"] as? Int ?? 0
                           if status == 200 {
                               let dictData = result!["contest"] as! [String: Any]
                               
                            
                           Define.USERDEFAULT.set(true, forKey: "isMobileOtpLogin")
                            
                            
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
//                                   Define.USERDEFAULT.set(self.textPassword.text!, forKey: "Password")
//                                   self.textEmail.text = nil
//                                   self.textPassword.text = nil
//                                   SocketIOManager.sharedInstance.establisConnection()
                               })
                            
                           } else if status == 423 {
                               Alert().showAlert(title: "Account Locked",
                                                 message: result!["message"] as? String ?? "No message available",
                                                 viewController: self)
                           } else {
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

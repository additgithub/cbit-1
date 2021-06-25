import UIKit
import FBSDKLoginKit

class SplashVC: UIViewController {

    //MARK: - Default Method
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            
           let isMobileOtpLogin = Define.USERDEFAULT.bool(forKey: "isMobileOtpLogin")
            
            self.CheckVersion()

            
            if MyModel().isLogedIn() {
                
//                SocketIOManager.sharedInstance.establisConnection()
//                let storyBoard = UIStoryboard(name: "Dashboard", bundle: nil)
//                let menuVC = storyBoard.instantiateViewController(withIdentifier: "MenuNC")
//                self.present(menuVC,
//                             animated: true,
//                             completion:
//                    {
//                })
                if isMobileOtpLogin {
                    
               //  self.CheckVersion()
//                    let storyBoard = UIStoryboard(name: "Dashboard", bundle: nil)
//                    let menuVC = storyBoard.instantiateViewController(withIdentifier: "MenuNC")
//                    menuVC.modalPresentationStyle = .fullScreen
//                    self.present(menuVC, animated: true,completion:{})
                    
                }
                else{
                
                let emailID = Define.USERDEFAULT.value(forKey: "Email") as? String ?? ""
                let password = Define.USERDEFAULT.value(forKey: "Password") as? String ?? ""
                
                if emailID.isEmpty && password.isEmpty {
                    let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginNC")
                    loginVC?.modalPresentationStyle = .fullScreen
                    self.present(loginVC!, animated: true, completion: nil)
                } else {
                    
                    self.signUp(email: emailID, password: password)
                }
            }
            }
                else {
               
                let fbLoginManeger: LoginManager = LoginManager();              fbLoginManeger.logOut()
                let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginNC")
                loginVC?.modalPresentationStyle = .fullScreen
                self.present(loginVC!, animated: true, completion: nil)
                
            
            }
        }
        
        
    }
}

//MARK: - API
extension SplashVC {
    func signUp(email: String, password: String) {
        Loading().showLoading(viewController: self)
        var parameter:[String: Any] = ["deviceId": Define.USERDEFAULT.value(forKey: "FCMToken") as? String ?? "123","deviceType": "ios",
            "OneSignalID" : UserDefaults.standard.string(forKey:"OnesignalID") ?? "123456"
        ]
        let isSocialLogin = Define.USERDEFAULT.bool(forKey: "isSocialLogin")
      //  let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String

         let appVersion = Define.APP_VERSION
        
        print(appVersion)
        
        if isSocialLogin {
            parameter["social_Id"] = Define.USERDEFAULT.value(forKey: "SocialID")!
            parameter["social_Type"] = "facebook"
            parameter["version"] = appVersion
        } else {
             parameter["email"] = email
             parameter["password"] = password
            parameter["version"] = appVersion
            parameter["plateform"] = "IOS"
        }
        
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
                
                let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginNC")
                loginVC?.modalPresentationStyle = .fullScreen
                self.present(loginVC!, animated: true, completion: nil)
            } else {
                Loading().hideLoading(viewController: self)
                print("Result: \(result!)")
                let status = result!["statusCode"] as? Int ?? 0
                if status == 200 {
                    let dictData = result!["contest"] as! [String: Any]
                    MyModel().setUserData(userData: dictData)
                    let storyBoard = UIStoryboard(name: "Dashboard", bundle: nil)
                    let menuVC = storyBoard.instantiateViewController(withIdentifier: "MenuNC")
                    menuVC.modalPresentationStyle = .fullScreen
                    self.present(menuVC,
                                 animated: true,
                                 completion:
                    {
                    })
                } else {
                    let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginNC")
                    loginVC?.modalPresentationStyle = .fullScreen
                    self.present(loginVC!, animated: true, completion: nil)
                }
            }
        }
    }
     func CheckVersion() {
            
        let appVersion = Define.APP_VERSION
        print(appVersion)
           
        let parameters:[String: Any] = ["version":appVersion,"plateform" : "IOS"]
                    let strURL = Define.APP_URL + Define.API_CHECKVERSION
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
                            self.CheckVersion()
                            
                        } else {
                            Loading().hideLoading(viewController: self)
                            print("Result: \(result!)")
                            let status = result!["statusCode"] as? Int ?? 0
                            
                            if status == 200 {
                                
                             
                              
                              
                                let storyBoard = UIStoryboard(name: "Dashboard", bundle: nil)
                                let menuVC = storyBoard.instantiateViewController(withIdentifier: "MenuNC")
                                menuVC.modalPresentationStyle = .fullScreen
                                self.present(menuVC, animated: true,completion:{})
                               
                            } else if status == 410 {
                                let current = Define.APP_VERSION
                                let appStore = result!["currentVersion"] as? String ?? "0"
                                let versionCompare = current.compare(appStore, options: .numeric)
                                if versionCompare == .orderedSame {
                                    print("same version")
                                } else if versionCompare == .orderedAscending {
                                    // will execute the code here
                                    print("ask user to update")
                                     //   Define.APPDELEGATE.handleLogout()
                                    let popUpData = result!["popUpData"] as? [[String:Any]] ?? []
                                    
                                    let content = popUpData[0]["content"] as? String ?? ""
                                    let title = popUpData[0]["title"] as? String ?? ""
                                    
                                    let is_cancel = popUpData[0]["is_cancel"] as? Int ?? 0
                                    let btn_name = popUpData[0]["btn_name"] as? String ?? "update"
                                    let link = popUpData[0]["link"] as? String ?? ""
                                    
                                    if is_cancel == 1 {
                                        let alertController = UIAlertController(title: title, message: content, preferredStyle:UIAlertController.Style.alert)

                                        alertController.addAction(UIAlertAction(title: btn_name, style: UIAlertAction.Style.default)
                                          { action -> Void in
                                            // Put your code here
                                            guard let url = URL(string: link) else {
                                                return
                                            }
                                            if #available(iOS 10.0, *) {
                                                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                            } else {
                                                UIApplication.shared.openURL(url)
                                            }
                                          })
                                        
                                        alertController.addAction(UIAlertAction(title: "LATER", style: UIAlertAction.Style.default)
                                          { action -> Void in
                                            if MyModel().isLogedIn() {
                                                let storyBoard = UIStoryboard(name: "Dashboard", bundle: nil)
                                                let menuVC = storyBoard.instantiateViewController(withIdentifier: "MenuNC")
                                                menuVC.modalPresentationStyle = .fullScreen
                                                self.present(menuVC, animated: true,completion:{})
                                            }
                                            else
                                            {
                                                let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginNC")
                                                    loginVC?.modalPresentationStyle = .fullScreen
                                                    self.present(loginVC!, animated: true, completion: nil)
                                            }
                                           
                                          })
                                        self.present(alertController, animated: true, completion: nil)
                                    }
                                    else
                                    {
                                        let alertController = UIAlertController(title: title, message: content, preferredStyle:UIAlertController.Style.alert)

                                        alertController.addAction(UIAlertAction(title: btn_name, style: UIAlertAction.Style.default)
                                          { action -> Void in
                                            // Put your code here
                                            guard let url = URL(string: link) else {
                                                return
                                            }
                                            if #available(iOS 10.0, *) {
                                                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                            } else {
                                                UIApplication.shared.openURL(url)
                                            }
                                          })
                                        self.present(alertController, animated: true, completion: nil)
                                    }
                                } else if versionCompare == .orderedDescending {
                                    // execute if current > appStore
                                    print("don't expect happen...")
                                }
                               
                            }
                            else
                            {
                                let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginNC")
                                    loginVC?.modalPresentationStyle = .fullScreen
                                    self.present(loginVC!, animated: true, completion: nil)
                                Alert().showAlert(title: "Error",message: result!["message"] as! String,viewController: self)
                            }
                        }
                    }
            
    }
    //MARK: - ALERT
    
}



extension SplashVC {
    func showLockAccountMessage(message: String) {
        let alertControll = UIAlertController(title: "Account Locked",
                                              message: message,
                                              preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK",
                                     style: .default)
        { _ in
            let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginNC")
            loginVC?.modalPresentationStyle = .fullScreen
            self.present(loginVC!, animated: true, completion: nil)
        }
        alertControll.addAction(okAction)
        self.present(alertControll, animated: true, completion: nil)
    }
}

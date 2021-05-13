import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class LoginVC: UIViewController {
    //MARK: - Prpperties
    @IBOutlet weak var viewLogin: UIView!
    @IBOutlet weak var textEmail: TextFieldwithBorder!
    @IBOutlet weak var textPassword: TextFieldwithBorder!
    @IBOutlet weak var buttonForgotPassword: UIButton!
    @IBOutlet weak var buttonLogin: UIButton!
    
    var dictSocialData = [String: Any]()
    var isSocialLogin = Bool()
    
    //MARK: - Default Method
    override func viewDidLoad() {
        super.viewDidLoad()
        textEmail.delegate = self
        textPassword.delegate = self
    }
    override func viewWillLayoutSubviews() {
        buttonForgotPassword.layer.cornerRadius = buttonForgotPassword.frame.height / 2
        buttonForgotPassword.layer.masksToBounds = true
        MyModel().setShadow(view: buttonLogin)
    }
    
    //MARK: - Button Method
    @IBAction func buttonSignUp(_ sender: Any) {
        let signUpVC = self.storyboard?.instantiateViewController(withIdentifier: "RegisterVC") as! RegisterVC
        signUpVC.isSocialLogin = false
        signUpVC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(signUpVC, animated: true)
    }
    @IBAction func buttonForgotPassword(_ sender: Any) {
        let forgotPasswordVC = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordVC
        forgotPasswordVC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(forgotPasswordVC, animated: true)
    }
    
    @IBAction func buttonLogin(_ sender: Any) {
        isSocialLogin = false
        if textEmail.text!.isEmpty || !MyModel().isValidEmail(testStr: textEmail.text!) {
            Alert().showTost(message: "Enter Proper Email", viewController: self)
        } else if textPassword.text!.count < 8 {
            Alert().showTost(message: "Enter Proper Password", viewController: self)
        } else if !MyModel().isConnectedToInternet() {
            Alert().showTost(message: Define.ERROR_INTERNET, viewController: self)
        } else {
            loginAPI()
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
                    self.loginAPI()
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
    
    @IBAction func btn_loginwithMobile(_ sender: Any) {
        
        let srotyboard = UIStoryboard(name: "Authentication", bundle: nil)
        let VC = srotyboard.instantiateViewController(withIdentifier: "LogInWithMobileNumberViewController") as! LogInWithMobileNumberViewController
        self.navigationController?.pushViewController(VC, animated: true)
        
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
    
}

//MARK: - TextField Delegate Method
extension LoginVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
         
    }
}

//MARK: - API
extension LoginVC {
    func loginAPI() {
        Loading().showLoading(viewController: self)
       
        
        var parameter:[String: Any] = ["deviceId": Define.USERDEFAULT.value(forKey: "FCMToken") as? String ?? "123","deviceType": "ios",
         "OneSignalID" : UserDefaults.standard.string(forKey:"OnesignalID") ?? "123456"]
        
        
        if isSocialLogin {
            parameter["social_Id"] = dictSocialData["UserID"]
            parameter["social_Type"] = "facebook"
        } else {
            parameter["email"] = textEmail.text!
            parameter["password"] = textPassword.text!
        }
        
       // let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String

        let appVersion = Define.APP_VERSION
        
        print(appVersion)
        
        parameter["version"] = appVersion
        parameter["plateform"] = "IOS"
        
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
                        Define.USERDEFAULT.set(self.textPassword.text!, forKey: "Password")
                        self.textEmail.text = nil
                        self.textPassword.text = nil
                        SocketIOManager.sharedInstance.establisConnection()
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

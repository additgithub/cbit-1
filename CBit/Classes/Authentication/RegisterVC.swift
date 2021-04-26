import UIKit
import Alamofire
import SystemConfiguration
import DropDown


class RegisterVC: UIViewController {
    //MARK: - Properties
    @IBOutlet weak var viewRegister: UIView!
    @IBOutlet weak var textFullName: TextFieldwithBorder!
    @IBOutlet weak var textMiddleName: TextFieldwithBorder!
    @IBOutlet weak var textLastName: TextFieldwithBorder!
    @IBOutlet weak var textEmail: TextFieldwithBorder!
    @IBOutlet weak var textPassword: TextFieldwithBorder!
    @IBOutlet weak var textCountryCode: TextFieldwithBorder!
    @IBOutlet weak var textMobileNumber: TextFieldwithBorder!
    @IBOutlet weak var textUserName: TextFieldwithBorder!
    @IBOutlet weak var labelPassword: UILabel!
    @IBOutlet weak var buttonRegister: UIButton!
    @IBOutlet weak var buttonPolicy: UIButton!
    @IBOutlet weak var lebelAccept: UILabel!
    private var dropDown: MyDropDown?
    private var buttonSelecteDropDown = UIButton()
    
    
    var arrStates = [String]()
    var arrCities = [String]()
    
    var stateid = Int()
    var cityid = Int()
    
    var statearrwithid = [[String:Any]]()
    var cityarrwithid = [[String:Any]]()
    var cityarrwithid1 = [[String:Any]]()
    
    let state = DropDown()
    let city = DropDown()
    
    @IBOutlet weak var txtcity: TextFieldwithBorder!
    @IBOutlet weak var txtstate: TextFieldwithBorder!
    @IBOutlet weak var textRefferalcode: TextFieldwithBorder!
    
    var dictSocialData = [String: Any]()
    var isSocialLogin = Bool()
    
    var isPolicySelected = Bool()
    //MARK: - Default Method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getcity()
        
        textFullName.delegate = self
        textEmail.delegate = self
        textPassword.delegate = self
        textMobileNumber.delegate = self
        textUserName.delegate = self
        textRefferalcode.delegate = self
        
        if isSocialLogin {
            labelPassword.removeFromSuperview()
            textPassword.removeFromSuperview()
            
        }
        
        textEmail.text = dictSocialData["Email"] as? String
        textFullName.text = dictSocialData["FirstName"] as? String
        textLastName.text = dictSocialData["LastName"] as? String
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        MyModel().setShadow(view: buttonRegister)
    }
    
    func setAccept() {
        lebelAccept.text = "I accept Terms & Conditions and Privacy Policy"
        let text = (lebelAccept.text)!
        let underlineAttriString = NSMutableAttributedString(string: text)
        let range1 = (text as NSString).range(of: "Terms & Conditions")
        underlineAttriString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range1)
        let range2 = (text as NSString).range(of: "Privacy Policy")
        underlineAttriString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range2)
        lebelAccept.attributedText = underlineAttriString
    }
    
    @IBAction func tapLabel(gesture: UITapGestureRecognizer) {
        let text = (lebelAccept.text)!
        let termsRange = (text as NSString).range(of: "Terms & Conditions")
        let privacyRange = (text as NSString).range(of: "Privacy Policy")
        
        if gesture.didTapAttributedTextInLabel(label: self.lebelAccept, inRange: termsRange) {
            print("Tapped terms")
        } else if gesture.didTapAttributedTextInLabel(label: self.lebelAccept, inRange: privacyRange) {
            print("Tapped privacy")
        } else {
            print("Tapped none")
        }
    }
    
    
    //MARK: - Button Method
    @IBAction func buttonLogin(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonSignUp(_ sender: Any) {
        if textFullName.text!.count < 3 {
            Alert().showTost(message: "Enter Proper First Name", viewController: self)
        } else if textMiddleName.text!.count < 3 {
            Alert().showTost(message: "Enter Proper Middle Name", viewController: self)
        } else if textLastName.text!.count < 3 {
            Alert().showTost(message: "Enter Proper Surname", viewController: self)
        } else if textUserName.text!.count < 4 {
            Alert().showTost(message: "Enter Proper User Name", viewController: self)
        } else if !MyModel().isValidEmail(testStr: textEmail.text!) || textEmail.text!.isEmpty {
            Alert().showTost(message: "Enter Proper Email", viewController: self)
        } else if stateid == 0 {
                   Alert().showTost(message: "Select State", viewController: self)
               }
        else if cityid == 0 {
                Alert().showTost(message: "Select City", viewController: self)
            }
//        else if !isSocialLogin && (textPassword.text!.count < 8 || textPassword.text!.isEmpty) {
//            Alert().showTost(message: "Password Should 8 Character", viewController: self)
//
//        }
        
        else if !MyModel().isValidMobileNumber(value: textMobileNumber.text!) || textMobileNumber.text!.isEmpty {
            Alert().showTost(message: "Enter Proper Mobile Number", viewController: self)
        } else if !isPolicySelected {
            Alert().showTost(message: "Accept Terms and Condition And Privacy Policy", viewController: self)
        } else if !MyModel().isConnectedToInternet() {
            Alert().showTost(message: Define.ERROR_INTERNET,
                             viewController: self)
        }else {
           getOTPAPI()
        }
    }
    
    @IBAction func buttonBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonPolicy(_ sender: Any) {
        if isPolicySelected {
            isPolicySelected = false
            buttonPolicy.setImage(#imageLiteral(resourceName: "ic_unchecked"), for: .normal)
        } else {
            isPolicySelected = true
            buttonPolicy.setImage(#imageLiteral(resourceName: "ic_checked"), for: .normal)
        }
    }
    
    @IBAction func buttonPrivacyPolicy(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PrivacyPolicyVC") as! PrivacyPolicyVC
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func buttonTermsAndCondition(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TermsAndConditionVC") as! TermsAndConditionVC
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func btnCity(_ sender: Any) {
     
        
        let  dropDown1 = DropDown(frame: CGRect(x: 110, y: 140, width: 200, height: 30))
          
        
        cityarrwithid1 =  cityarrwithid.filter{$0["StateID"] as? Int == stateid} as? [[String:Any]] ?? [[:]]
        
        print(cityarrwithid1)
        
        var i = 0
        
        for i in i..<self.cityarrwithid1.count
                                
                               {
                                
                let string = self.cityarrwithid1[i]["CityName"] as? String ?? ""
                                   
                self.arrStates.append(string)
                                   
                               }
        
        
        
        dropDown1.dataSource = self.cityarrwithid1.compactMap{$0["CityName"] as? String}
        
        dropDown1.anchorView =  txtcity
        
          dropDown1.selectionAction = {
            
            [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
           
            self.cityid =  self.cityarrwithid1[index]["CityID"] as? Int ?? 0
            print(self.cityid)
          
            self.txtcity.text  = item
            
        }
        dropDown1.show()
    }
    
    @IBAction func btn_state(_ sender: Any) {
        
        let  dropDown = DropDown()
        
         dropDown.dataSource = self.statearrwithid.compactMap {$0["StateName"] as? String}
        
        dropDown.anchorView =  txtstate
      
        dropDown.topOffset = CGPoint(x: 250, y:-(dropDown.anchorView?.plainView.bounds.height)!)
       
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
          print("Selected item: \(item) at index: \(index)")
         
            self.stateid =  self.statearrwithid[index]["StateID"] as! Int
            print(self.stateid)
             
            self.txtstate.text  = item
            
            self.txtcity.text = ""
            self.cityid = 0
            
            dropDown.hide()
            
            
            
//          dropDown.dataSource = cityarrwithid.filter {$0.StateID == stateid}
//
//          dropDown.selectionAction = { [weak self] (index, item) in
////              self?.txtsubcategory.text = item
//              let cityid = self?.SubCategories[index]["CityID"] as? String ??  ""
//            print(cityid)
//                 }
            
        }
        
        
        dropDown.show()
    }
    
    
}

//MARK: - TextField Delegate Method
extension RegisterVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == textUserName {
            checkUserNameAPI()
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == textMobileNumber {
            let maxLength = 10
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            
            return newString.length <= maxLength ? true : false
        }
        return true
    }
}

//MARK: - API
extension RegisterVC {
    func getOTPAPI() {
        Loading().showLoading(viewController: self)
        let parameter:[String: Any] = ["mobile_no": textMobileNumber.text!,
                                       "email": self.textEmail.text!,
                                       "ReferralCode":textRefferalcode.text!]
        let strURL = Define.APP_URL + Define.API_GET_OTP
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
                self.getOTPAPI()
            } else {
                Loading().hideLoading(viewController: self)
                print("Result: \(result!)")
                let status = result!["statusCode"] as? Int ?? 0
                if status == 200 {
                    let dictData = result!["content"] as! [String: Any]
                    
//                    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String

                    let appVersion = Define.APP_VERSION

                    
                    
                    print(appVersion)
                    
                    var parameter:[String: Any] = [
                      
                        "firstName": self.textFullName.text!,
                        "middelName": self.textMiddleName.text!,
                        "lastName": self.textLastName.text!,
                        "email": self.textEmail.text!,
                        "StateID" :self.stateid,
                        "CityID" :self.cityid,
                        "mobile_no": self.textMobileNumber.text!,
                        "userName": self.textUserName.text!,
                        "ReferralCode" : self.textRefferalcode.text!,
                        "version" : appVersion,
                        "deviceType": "ios",
                        "deviceId": Define.USERDEFAULT.value(forKey: "FCMToken") as? String ?? "123",
                        "otp": "\(dictData["otp"]!)",
                        "otpId": "\(dictData["otpId"]!)",
                        "OneSignalID" : UserDefaults.standard.string(forKey:"OnesignalID") ?? "123456"
                        
                    ]
                    
                    if self.isSocialLogin {
                        
                        parameter["social_Id"] = self.dictSocialData["UserID"]
                        parameter["social_Type"] = "facebook"
                        parameter["password"] = ""
                        
                    } else {
                       // parameter["password"] = self.textPassword.text!
                        
                        parameter["password"] = "12345678"
                    }
                    
                    let otpVC = self.storyboard?.instantiateViewController(withIdentifier: "OTPVerifyVC") as! OTPVerifyVC
                    otpVC.parameter = parameter
                    otpVC.isSocialLogin = self.isSocialLogin
                    otpVC.dictSocialData = self.dictSocialData
                    self.navigationController?.pushViewController(otpVC, animated: true)
                    
                } else {
                    Alert().showAlert(title: "Error",
                                      message: result!["message"] as! String,
                                      viewController: self)
                }
            }
        }
    }
    
    func checkUserNameAPI() {
        Loading().showLoading(viewController: self)
        let parameter:[String: Any] = ["userName": textUserName.text!]
        let strURL = Define.APP_URL + Define.API_CHECK_USER_NAME
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
                self.checkUserNameAPI()
            } else {
                Loading().hideLoading(viewController: self)
                print("Result: \(result!)")
                let status = result!["statusCode"] as? Int ?? 0
                if status == 200 {
                    Alert().showTost(message: "User Name Accepted", viewController: self)
                } else {
                    self.retry(strMsg: result!["message"] as! String)
                }
            }
        }
    }
    
    func getcity()
    {
          Loading().showLoading(viewController: self)
              
              let strURL = Define.APP_URL + Define.API_GETCITYSTATE
             // print("Parameter: \(parameter)\nURL: \(strURL)")
              
              //let jsonString = MyModel().getJSONString(object: parameter)
              let encriptString = MyModel().encrypting(strData:"", strKey: Define.KEY)
              let strbase64 = encriptString.toBase64()
              
              SwiftAPI().getMethodSecure(stringURL: strURL,
                                          parameters: ["data":strbase64!],
                                          header: Define.USERDEFAULT.value(forKey: "AccessToken") as? String,
                                          auther: Define.USERDEFAULT.value(forKey: "UserID") as? String)
              { (result, error) in
                  if error != nil {
                      Loading().hideLoading(viewController: self)
                      print("Error: \(error!.localizedDescription)")
                    self.retry(strMsg: "")
                  } else {
                      Loading().hideLoading(viewController: self)
                      print("Result: \(result!)")
                      let status = result!["statusCode"] as? Int ?? 0
                      if status == 200 {
                          let dictData = result!["content"] as! [String: Any]
                          
                        self.statearrwithid = dictData["State"] as! [[String: Any]]
                         self.cityarrwithid = dictData["City"] as! [[String: Any]]
                        var i = 0
                        
                        for i in i..<self.statearrwithid.count
                         
                        {
                         
                            let string = self.statearrwithid[i]["StateName"] as? String ?? ""
                            
                            self.arrStates.append(string)
                            
                        }
                        
                        print(self.arrStates)
                        
                      } else if status == 401 {
                          Define.APPDELEGATE.handleLogout()
                      } else {
                          Alert().showAlert(title: "Alert",
                                            message: result!["message"] as? String  ?? Define.ERROR_SERVER,
                                            viewController: self)
                      }
                  }
              }
          }
}

//MARK: - Alert Contollert
extension RegisterVC {
    func retry(strMsg: String) {
        let alertController = UIAlertController(title: "Alert",
                                                message: strMsg,
                                                preferredStyle: .alert)
        let buttonRetry = UIAlertAction(title: "OK",
                                        style: .default)
        { _ in
            self.textUserName.becomeFirstResponder()
        }
        alertController.addAction(buttonRetry)
        self.present(alertController,
                     animated: true,
                     completion: nil)
    }
}



extension UITapGestureRecognizer {
    
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)
        
        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
                                          y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
        
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x,
                                                     y: locationOfTouchInLabel.y - textContainerOffset.y);
        
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
    
}
extension RegisterVC: MyDropDownDelegate {
    func recievedSelectedValue(name: String, index: Int) {
//        if isNumberOfTicket {
//            isNumberOfTicket = false
//            labelNumberOfTickets.text = "\(name)"
//            numberOfTickets = Int(name)!
//        } else if isMaxWinner {
//            isMaxWinner = false
//            labelMaxWinner.text = "\(name)%"
//            maxWinner = Int(name)!
//        } else {
//            labelAnswerRange.text = "\(name)"
//            selectedAnswerRangeIndex = index
//        }
//        dropDown!.hideMyDropDown(sendButton: buttonSelecteDropDown)
//        dropDown = nil
//    }
}
}

func isInternetAvailable() -> Bool
{
    var zeroAddress = sockaddr_in()
    zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
    zeroAddress.sin_family = sa_family_t(AF_INET)
    
    let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
        $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
            SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
        }
    }
    
    var flags = SCNetworkReachabilityFlags()
    if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
        return false
    }
    let isReachable = flags.contains(.reachable)
    let needsConnection = flags.contains(.connectionRequired)
    return (isReachable && !needsConnection)
}

func noInternetConnectionAlert(uiview: UIViewController) {
let alert = UIAlertController(title: "", message: "Please check your internet connection or try again later", preferredStyle: UIAlertController.Style.alert)
   alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
   uiview.present(alert, animated: true, completion: nil)
//
//    let alert = EMAlertController(title: ConstantVariables.Constants.Project_Name, message: "Please check your internet connection or try again later")
//    let action1 = EMAlertAction(title: "Ok", style: .cancel)
//    alert.addAction(action: action1)
//    uiview.present(alert, animated: true, completion: nil)
  }

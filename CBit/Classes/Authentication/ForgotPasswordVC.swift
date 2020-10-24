import UIKit

class ForgotPasswordVC: UIViewController {
    //MARK: - Properties.
    
    @IBOutlet weak var viewNavigation: UIView!
    @IBOutlet weak var imageEmail: ImageViewForTextFieldWight!
    @IBOutlet weak var textEmail: UITextField!
    
    //MARK: - Default Method
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    
    //MARK: - Button Method
    @IBAction func buttonBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonSend(_ sender: Any) {
        if textEmail.text!.isEmpty || !MyModel().isValidEmail(testStr: textEmail.text!) {
            Alert().showTost(message: "Enter Proper Email.", viewController: self)
        } else {
            forgotPasswordAPI()
        }
    }
}

//MARK: - API
extension ForgotPasswordVC {
    func forgotPasswordAPI() {
        self.textEmail.resignFirstResponder()
        Loading().showLoading(viewController: self)
        let parameter: [String: Any] = ["email": textEmail.text!]
        let strURL = Define.APP_URL + Define.API_FORGOT_PASSWORD
        
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
                self.forgotPasswordAPI()
            } else {
                Loading().hideLoading(viewController: self)
                print("Result: \(result!)")
                let status = result!["statusCode"] as? Int ?? 0
                if status == 200 {
                    self.textEmail.text = nil
                    Alert().showAlert(title: "Forgot Password",
                                      message: result!["message"] as! String,
                                      viewController: self)
                } else {
                    Alert().showAlert(title: "Error",
                                      message: result!["message"] as! String,
                                      viewController: self)
                }
            }
        }
    }
}

import UIKit

public protocol LinkBankAccountDelegate {
    func bankAccountAdded()
}
class LinkBankAccountVC: UIViewController {
    //MARK: - Properties
    @IBOutlet weak var textBankName: UITextField!
    @IBOutlet weak var textAccountNumber: UITextField!
    @IBOutlet weak var textIFSCCode: UITextField!
    
    var delegate: LinkBankAccountDelegate?
    
    //MARK: - Default Method
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK: - Button Method
    @IBAction func buttonBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func buttonSubmit(_ sender: Any) {
        if textBankName.text!.isEmpty {
            Alert().showAlert(title: "Alert",
                              message: "Enter Bank Name",
                              viewController: self)
        } else if textAccountNumber.text!.isEmpty {
            Alert().showAlert(title: "Alert",
                              message: "Enter Bank Acount Number",
                              viewController: self)
        } else if textIFSCCode.text!.isEmpty {
            Alert().showAlert(title: "Alert",
                              message: "Enter Bank IFSC Code",
                              viewController: self)
        } else {
            linkBankAccountAPI()
        }
    }
}

//MARK: - API
extension LinkBankAccountVC {
    func linkBankAccountAPI() {
        Loading().showLoading(viewController: self)
        let parameter: [String: Any] = [
            "bank_name": textBankName.text!,
            "account_no": textAccountNumber.text!,
            "ifsc_code": textIFSCCode.text!
        ]
        let strURL = Define.APP_URL + Define.API_LINK_BANK
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
                    NotificationCenter.default.post(name: .BankAccountAdded, object: nil)
                    self.navigationController?.popViewController(animated: true)
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
}

//MARK: - Alert Contollert
extension LinkBankAccountVC {
    func retry() {
        let alertController = UIAlertController(title: Define.ERROR_TITLE,
                                                message: Define.ERROR_SERVER,
                                                preferredStyle: .alert)
        let buttonRetry = UIAlertAction(title: "Retry",
                                        style: .default)
        { _ in
            self.linkBankAccountAPI()
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

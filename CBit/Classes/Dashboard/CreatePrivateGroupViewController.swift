//
//  CreatePrivateGroupViewController.swift
//  CBit
//
//  Created by My Mac on 12/11/20.
//  Copyright © 2020 Bhavik Kothari. All rights reserved.
//

import UIKit

class CreatePrivateGroupViewController: UIViewController {

    @IBOutlet var txtgroupname: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func back_click(_ sender: UIButton) {
        // self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func create_click(_ sender: UIButton) {
        if txtgroupname.text != "" {
            CreateGroup()
        }
        else
        {
            Alert().showAlert(title: "Error",message: "Please select group name",viewController: self)
        }
    }
    
    
    func CreateGroup() {
        Loading().showLoading(viewController: self)
        let parameter: [String: Any] = [
            "group_name": txtgroupname.text ?? "",
            "userID":Define.USERDEFAULT.value(forKey: "UserID") as? String ?? ""
          
        ]
        let strURL = Define.APP_URL + Define.ADD_PRIVATE_GROUP
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
          self.navigationController?.popViewController(animated: true)
        }
    

}



//MARK: - Alert Contollert


extension CreatePrivateGroupViewController {
    func retry() {
        let alertController = UIAlertController(title: Define.ERROR_TITLE,
                                                message: Define.ERROR_SERVER,
                                                preferredStyle: .alert)
        let buttonRetry = UIAlertAction(title: "Retry",
                                        style: .default)
        { _ in
            self.CreateGroup()
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

//
//  JTredingDetailVC.swift
//  CBit
//
//  Created by Nirmal Bodar on 22/09/21.
//  Copyright © 2021 Bhavik Kothari. All rights reserved.
//

import UIKit

class JTredingDetailVC: UIViewController {

    var section_id = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getjtradingchart()
    }
    

    // MARK: - Button Action Method
    
    @IBAction func Back_click(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

}


// MARK: - API
extension JTredingDetailVC
{
    func getjtradingchart() {
        
        Loading().showLoading(viewController: self)
        
        let parameter: [String: Any] = [
            "section_id":section_id,
        ]
        let strURL = Define.APP_URL + Define.jtradingChart
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
            } else {
                Loading().hideLoading(viewController: self)
                print("Result: \(result!)")
                let status = result!["statusCode"] as? Int ?? 0
                if status == 200 {
                    
                    let content = result!["content"] as! [String: Any]
          
                
                    
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

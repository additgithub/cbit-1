//
//  MyPrivateGroupsVC.swift
//  CBit
//
//  Created by Catlina-Ravi on 25/02/21.
//  Copyright © 2021 Bhavik Kothari. All rights reserved.
//

import UIKit

class MyPrivateGroupsVC: UIViewController {
    private var arrUserGroupList = [[String: Any]]()
    @IBOutlet var tbl_userlist: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        MyUserGroupList()
    }
    
    @IBAction func btn_BACK(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func MyUserGroupList() {
        Loading().showLoading(viewController: self)
        let parameter: [String: Any] = [
            "userID":Define.USERDEFAULT.value(forKey: "UserID") as? String ?? ""
        ]
        let strURL = Define.APP_URL + Define.ALL_USER_PRIVATE_GROUP
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
                    self.arrUserGroupList = result!["content"] as? [[String: Any]] ?? [["":""]]
                    
                    self.tbl_userlist.reloadData()
                    
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

extension MyPrivateGroupsVC : UITableViewDelegate , UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrUserGroupList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! MyPrivateGroupsCell
        cell.lbl_name.text = arrUserGroupList[indexPath.row]["private_group_name"] as? String ?? "N/A"
        return cell
    }
    
    
}

extension MyPrivateGroupsVC {
    func retry() {
        let alertController = UIAlertController(title: Define.ERROR_TITLE,
                                                message: Define.ERROR_SERVER,
                                                preferredStyle: .alert)
        let buttonRetry = UIAlertAction(title: "Retry",
                                        style: .default)
        { _ in
            self.MyUserGroupList()
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



class MyPrivateGroupsCell : UITableViewCell
{
    @IBOutlet weak var img_profile: UIImageView!
    @IBOutlet weak var lbl_name: UILabel!
    
    
    
}

//
//  GroupUserAndRequestListVC.swift
//  CBit
//
//  Created by Catlina-Ravi on 09/03/21.
//  Copyright © 2021 Bhavik Kothari. All rights reserved.
//

import UIKit

class GroupUserAndRequestListVC: UIViewController {

    private var arrUserReqList = [AllRequestData]()
    private var arrPrivateUserList = [AllPrivateGroupListData]()
    
    @IBOutlet weak var tbl_grouplist: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        CallRequestList()
        CallGropuList()
    }
    
    @IBAction func btn_BACK(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    func CallGropuList() {
        Loading().showLoading(viewController: self)
        let parameter: [String: Any] = [
           "group_id":"1"
        ]
        let strURL = Define.APP_URL + Define.ALL_Private_Group_User_List
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
                    
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: result!, options: .prettyPrinted)
                        // here "jsonData" is the dictionary encoded in JSON data

                        let allUserListModel = try? JSONDecoder().decode(AllPrivateGroupListModel.self, from: jsonData)
                        
                        self.arrPrivateUserList = (allUserListModel?.content)!
                       // self.usersData.serverArray = self.arrUserGroupList
                        
                        //let decoded = try JSONSerialization.jsonObject(with: jsonData, options: [])
                        // here "decoded" is of type `Any`, decoded from JSON data

                        // you can now cast it with the right type
                        //if let dictFromJSON = decoded as? [String:String] {
                            // use dictFromJSON
                        //}
                    } catch {
                        print(error.localizedDescription)
                    }
                    
                    self.tbl_grouplist.reloadData()
                    
                    
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
    
    func CallRequestList() {
        Loading().showLoading(viewController: self)
        let parameter: [String: Any] = [
           "group_id":"1"
        ]
        let strURL = Define.APP_URL + Define.ALL_REQUEST_PRIVATE_GROUP
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
                    
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: result!, options: .prettyPrinted)
                        // here "jsonData" is the dictionary encoded in JSON data

                        let allUserListModel = try? JSONDecoder().decode(AllRequestListModel.self, from: jsonData)
                        
                        self.arrUserReqList = (allUserListModel?.content?.allRequest)!
                       // self.usersData.serverArray = self.arrUserGroupList
                        
                        //let decoded = try JSONSerialization.jsonObject(with: jsonData, options: [])
                        // here "decoded" is of type `Any`, decoded from JSON data

                        // you can now cast it with the right type
                        //if let dictFromJSON = decoded as? [String:String] {
                            // use dictFromJSON
                        //}
                    } catch {
                        print(error.localizedDescription)
                    }
                    
                    self.tbl_grouplist.reloadData()
                    
                    
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
    
    func CallAcceptDeclineRequest(groupId:Int,userId:Int,acceptDecline:String) {
        Loading().showLoading(viewController: self)
        let parameter: [String: Any] = [
            "group_id":groupId,
            "request_id":acceptDecline,//0=decline,1=accept
            "user_id":userId
        ]
        let strURL = Define.APP_URL + Define.ALL_PRIVATE_GROUP_REQUEST_ACCEPT_DECLINE
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
                    
                    let meg = result!["message"] as? String
                    self.showToast(message: meg!, font: UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.thin))
                    
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

extension GroupUserAndRequestListVC : UITableViewDataSource , UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0
        {
            return arrUserReqList.count
        }
        else
        {
            return arrPrivateUserList.count
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! GroupUserAndRequestListCell
        
        if indexPath.section == 0
        {
            cell.lbl_g_name.text = arrUserReqList[indexPath.row].firstName ?? "" + arrUserReqList[indexPath.row].lastName!
            
            cell.btn_accept.tag = indexPath.row
            cell.btn_accept.addTarget(self, action: #selector(requestAccept), for: .touchUpInside)
            
            cell.btn_decline.tag = indexPath.row
            cell.btn_decline.addTarget(self, action: #selector(requestDecline(sender:)), for: .touchUpInside)
            
            cell.btn_accept.isHidden = false
            cell.btn_decline.isHidden = false
            
        }
        else
        {
            cell.lbl_g_name.text = arrPrivateUserList[indexPath.row].firstName ?? "" + arrUserReqList[indexPath.row].lastName!
            
            cell.btn_accept.isHidden = true
            cell.btn_decline.isHidden = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0
        {
            let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
            headerView.backgroundColor = .white
            
            let label = UILabel()
            label.frame = CGRect.init(x: 20, y: 10, width: headerView.frame.width-10, height: headerView.frame.height-10)
            label.text = "All Request"
            label.font = .systemFont(ofSize: 16)
            label.textColor = .darkGray
            
            headerView.addSubview(label)
            
            return headerView
        }
        else
        {
            let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
            headerView.backgroundColor = .white
            let label = UILabel()
            label.frame = CGRect.init(x: 20, y: 10, width: headerView.frame.width-10, height: headerView.frame.height-10)
            label.text = "Group Member"
            label.font = .systemFont(ofSize: 16)
            label.textColor = .darkGray
            
            headerView.addSubview(label)
            
            return headerView
        }
        
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    @objc func requestAccept(sender: UIButton){
        let buttonTag = sender.tag
        let userId = arrUserReqList[sender.tag].userID!
        let groupId = arrUserReqList[sender.tag].groupID!
            
        CallAcceptDeclineRequest(groupId: groupId,userId:userId, acceptDecline: "1" )
    }
    
    @objc func requestDecline(sender: UIButton){
        let buttonTag = sender.tag
        let userId = arrUserReqList[sender.tag].userID!
        let groupId = arrUserReqList[sender.tag].groupID!
        
        CallAcceptDeclineRequest(groupId: groupId, userId: userId, acceptDecline: "0")
    }
    
}

extension GroupUserAndRequestListVC {
    func retry() {
        let alertController = UIAlertController(title: Define.ERROR_TITLE,
                                                message: Define.ERROR_SERVER,
                                                preferredStyle: .alert)
        let buttonRetry = UIAlertAction(title: "Retry",
                                        style: .default)
        { _ in
            self.CallRequestList()
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

class GroupUserAndRequestListCell : UITableViewCell
{
    @IBOutlet weak var lbl_g_name: UILabel!
    
    @IBOutlet weak var btn_accept: UIButton!
    
    @IBOutlet weak var btn_decline: UIButton!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}


import Foundation

// MARK: - AllRequestListModel
struct AllRequestListModel: Codable {
    let content: AllRequestListData?
    let message: String?
    let statusCode: Int?
}

// MARK: - Content
struct AllRequestListData: Codable {
    let allRequest: [AllRequestData]?
}

// MARK: - AllRequest
struct AllRequestData: Codable {
    let createdAt, firstName: String?
    let groupID, id: Int?
    let lastName, middelName: String?
    let request, status: Int?
    let updatedAt: String?
    let userID: Int?

    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case firstName
        case groupID = "group_id"
        case id, lastName, middelName, request, status
        case updatedAt = "updated_at"
        case userID = "user_id"
    }
}

// MARK: - AllPrivateGroupListModel
struct AllPrivateGroupListModel: Codable {
    let count: Int?
    let content: [AllPrivateGroupListData]?
    let statusCode: Int?
    let message: String?
}

// MARK: - Content
struct AllPrivateGroupListData: Codable {
    let createdAt, firstName: String?
    let groupID, id: Int?
    let lastName, middelName: String?
    let request, status: Int?
    let updatedAt: String?
    let userID: Int?

    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case firstName
        case groupID = "group_id"
        case id, lastName, middelName, request, status
        case updatedAt = "updated_at"
        case userID = "user_id"
    }
}

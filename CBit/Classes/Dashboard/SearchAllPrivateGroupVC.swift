//
//  SearchAllPrivateGroupVC.swift
//  CBit
//
//  Created by Catlina-Ravi on 02/03/21.
//  Copyright © 2021 Bhavik Kothari. All rights reserved.
//

import UIKit
import HSSearchable

class SearchAllPrivateGroupVC: UIViewController {
    private var arrUserGroupList = [AllUserListData]()
    @IBOutlet var tbl_userlist: UITableView!
    
    
    @IBOutlet weak var search_bar: UISearchBar!
    
    var usersData = SearchableWrapper()
    var users: [AllUserListData] { //use this array as you are using array for your tableview controller
       return self.usersData.dataArray as! [AllUserListData]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        MyUserGroupList()
        
        self.search_bar.delegate = self.usersData
        self.usersData.searchingCallBack = { isSearching, searchText in
            print("searching Text:= \(searchText)")
            self.sortedAfterSearch()
            
        }
        
        if #available(iOS 13.0, *) {
            self.search_bar.searchBarStyle = .default
            self.search_bar.searchTextField.backgroundColor = UIColor.clear
            self.search_bar.backgroundImage = UIImage()

        }
        else
        {
            self.search_bar.searchTextField.borderStyle = .none
            self.search_bar.backgroundImage = UIImage()

        }
        
    }
    
    func sortedAfterSearch()
    {
        arrUserGroupList.removeAll()
        
        
        for child in users {
            arrUserGroupList.append(child)
        }
        
       
        tbl_userlist.reloadData()
    }
    
    @IBAction func btn_BACK(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

    func MyUserGroupList() {
        Loading().showLoading(viewController: self)
        let parameter: [String: Any] = [
            :
        ]
        let strURL = Define.APP_URL + Define.ALL_PRIVATE_GROUP
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

                        let allUserListModel = try? JSONDecoder().decode(AllUserListModel.self, from: jsonData)
                        
                        self.arrUserGroupList = allUserListModel?.content ?? [AllUserListData]()
                        self.usersData.serverArray = self.arrUserGroupList
                        
                        //let decoded = try JSONSerialization.jsonObject(with: jsonData, options: [])
                        // here "decoded" is of type `Any`, decoded from JSON data

                        // you can now cast it with the right type
                        //if let dictFromJSON = decoded as? [String:String] {
                            // use dictFromJSON
                        //}
                    } catch {
                        print(error.localizedDescription)
                    }
                    
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

    
    func SendJoinRequest(groupId:String) {
        Loading().showLoading(viewController: self)
        let parameter: [String: Any] = [
            "group_id":groupId
        ]
        let strURL = Define.APP_URL + Define.ALL_PRIVATE_GROUP_REQUEST_JOIN
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

extension AllUserListData: SearchableData {
   
    var searchValue: String{
        //return self.jobTitle!
        return privateGroupName!  //this will search from the name and city both
    }
    
    
}

extension SearchAllPrivateGroupVC : UITableViewDelegate , UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrUserGroupList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SearchAllPrivateGroupCell
        cell.lbl_name.text = arrUserGroupList[indexPath.row].privateGroupName ?? ""
        
        
        cell.btn_join.tag = indexPath.row
        cell.btn_join.addTarget(self, action: #selector(connected(sender:)), for: .touchUpInside)

        
        let user_id = arrUserGroupList[indexPath.row].userID!
        let userId = Define.USERDEFAULT.value(forKey: "UserID") as? String
        
        if userId == "\(user_id)"
        {
            cell.btn_join.isUserInteractionEnabled = false
            cell.btn_join.alpha = 0.7
        }
        else
        {
            cell.btn_join.isUserInteractionEnabled = true
            cell.btn_join.alpha = 1.0
        }
        
        
        
        return cell
    }
    
    @objc func connected(sender: UIButton){
        let buttonTag = sender.tag
        let idd = arrUserGroupList[sender.tag].id!
        self.SendJoinRequest(groupId: "\(idd)")
    }
    
}


extension SearchAllPrivateGroupVC {
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



class SearchAllPrivateGroupCell : UITableViewCell
{
    @IBOutlet weak var img_profile: UIImageView!
    @IBOutlet weak var lbl_name: UILabel!
    
    @IBOutlet weak var btn_join: UIButton!
    
    
}


//   let allUserListModel = try? newJSONDecoder().decode(AllUserListModel.self, from: jsonData)

import Foundation

// MARK: - AllUserListModel
struct AllUserListModel: Codable {
    let content: [AllUserListData]?
    let message: String?
    let statusCode: Int?
}

// MARK: - Content
struct AllUserListData: Codable {
    let count: Int?
    let createdAt: String?
    let id: Int?
    let privateGroupName, updatedAt: String?
    let userID: Int?

    enum CodingKeys: String, CodingKey {
        case count
        case createdAt = "created_at"
        case id
        case privateGroupName = "private_group_name"
        case updatedAt = "updated_at"
        case userID = "user_id"
    }
}

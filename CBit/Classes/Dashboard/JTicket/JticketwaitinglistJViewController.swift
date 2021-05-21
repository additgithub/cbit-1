//
//  JticketwaitinglistJViewController.swift
//  CBit
//
//  Created by My Mac on 27/12/19.
//  Copyright © 2019 Bhavik Kothari. All rights reserved.
//

import UIKit

class JticketwaitinglistJViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
        
        @IBOutlet weak var imgjticket: UIImageView!
        
        private var isFirstTime = Bool()
        
        
        @IBOutlet weak var tblwaitinglist: UITableView!
    
        private var arrJticketwaitinglist = [[String: Any]]()
        var id = 0
    
        override func viewDidLoad() {
            super.viewDidLoad()
            
            isFirstTime = true
            
            getJticketWaitingListJ()
            
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
            return arrJticketwaitinglist.count
            
            
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let userCell = tableView.dequeueReusableCell(withIdentifier: "JticketwaitinglistJ") as! JticketwaitinglistJ
        
            userCell.lblticketno.text! = arrJticketwaitinglist[indexPath.row]["name"] as? String ?? "No Name"
            userCell.lblwaitingno.text! = "Current Waiting : " + "\( arrJticketwaitinglist[indexPath.row]["waiting"] as? Int ?? 00)"
            userCell.btnwaitingno.addTarget(self, action:#selector(btnWaitinglist(_:event:)), for: .touchUpInside)
            let imageURL = URL(string: arrJticketwaitinglist  [indexPath.row]["image"] as? String ?? "")
            userCell.imgjticket.sd_setImage(with: imageURL, placeholderImage: Define.PLACEHOLDER_PROFILE_IMAGE)
            
            userCell.lbl_appliy_count.text = "My J Ticket : \(arrJticketwaitinglist[indexPath.row]["applyCount"] as? Int ?? 00)"
            
            return userCell
            
        }
        

        @IBAction func btn_back(_ sender: Any) {
            self.dismiss(animated: true)
        }
    
    @IBAction func refresh_click(_ sender: UIButton) {
        getJticketWaitingListJ()
    }
    @objc func btnWaitinglist(_ sender: Any, event: Any) {
        
        
        let point : CGPoint = (sender as AnyObject).convert(CGPoint.zero, to:tblwaitinglist)
        var indexPath =  self.tblwaitinglist!.indexPathForRow(at: point)
        var selectedrow = indexPath!.row
        
        
        
        id =  (arrJticketwaitinglist[selectedrow] as AnyObject).value(forKey: "id") as! Int
        
        let jticketwaitinglists = self.storyboard?.instantiateViewController(withIdentifier: "JticketWaitingListViewController") as! JticketWaitingListViewController
        //  gamePlayVC.isFromNotification = true
        jticketwaitinglists.modalPresentationStyle = .fullScreen
        jticketwaitinglists.id = id
        self.present(jticketwaitinglists, animated: true, completion: nil)
        
    }

    
    
    }
    class JticketwaitinglistJ: UITableViewCell {
        
        
        
        @IBOutlet weak var viewjticketlisting: ViewWithShadow!
        @IBOutlet weak var lblusername: UILabel!
        @IBOutlet weak var lblticketno: UILabel!
        @IBOutlet weak var btnwaitingno: UIButton!
        @IBOutlet weak var imgjticket: ImageViewProfile!
        
        @IBOutlet weak var lblwaitingno: UILabel!
        
        
        @IBOutlet weak var lbl_appliy_count: UILabel!
        
        override func awakeFromNib() {
            super.awakeFromNib()
            
        }
        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)
            
        }
}

extension JticketwaitinglistJViewController {
    // Mark API For Getting ALLJticket
    func getJticketWaitingListJ()  {
        if isFirstTime {
            Loading().showLoading(viewController: self)
        }
        let strURL = Define.APP_URL + Define.GET_AllJticket
        print("URL: \(strURL)")
        
        SwiftAPI().postMethodSecure(stringURL: strURL,
                                    parameters: nil,
                                    header: Define.USERDEFAULT.value(forKey: "AccessToken") as? String,
                                    auther: Define.USERDEFAULT.value(forKey: "UserID") as? String)
        { (result, error) in
            if error != nil {
                if self.isFirstTime
                {
                    self.isFirstTime = false
                    Loading().hideLoading(viewController: self)
                }
                print("Error: \(error!)")
                self.getJticketWaitingListJ()
                
            } else
            {
                if self.isFirstTime {
                    self.isFirstTime = false
                    Loading().hideLoading(viewController: self)
                }
                print("Result: \(result!)")
                //applyCount = 0
                let status = result!["statusCode"] as? Int ?? 0
                if status == 200 {
                    
                    let content = result!["content"] as! [String: Any]
                    self.arrJticketwaitinglist = content["contest"] as? [[String : Any]] ?? [[:]]
                    print(self.arrJticketwaitinglist)
                    self.tblwaitinglist.reloadData()
              
                } else if status == 401 {
                    
           //         Define.APPDELEGATE.handleLogout()
                    
                } else {
                    
                    Alert().showAlert(title: "Error",
                                      message: result!["message"] as! String,
                                      viewController: self)
                }
            }
        }
}
}

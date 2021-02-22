//
//  JticketWaitingListViewController.swift
//  CBit
//
//  Created by My Mac on 18/12/19.
//  Copyright © 2019 Bhavik Kothari. All rights reserved.
//

import UIKit

class JticketWaitingListViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var imgjticket: UIImageView!
    
    private var isFirstTime = Bool()
    
    @IBOutlet weak var lblCurrentWaitingperiod: UILabel!
    
    @IBOutlet weak var tblwaitinglist: UITableView!
    
    var id = 0
    private var arrJticketwaitinglist = [[String: Any]]()
    
    var Start = 0
    var Limit = 30
    var ismoredata = false
    
    //APPROACH LIST Vars
    @IBOutlet var vw_approch: UIView!
    @IBOutlet weak var tbl_approch: UITableView!
    @IBOutlet var vw_offers: UIView!
    @IBOutlet weak var txt_approch: UITextField!
    @IBOutlet var vw_deal: UIView!
    
    var selectedIndexpath : IndexPath?
    private var arrJticketuserwaitinglist = [[String: Any]]()
    
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        isFirstTime = true
        getJticketWaitingList()
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tbl_approch
        {
            return arrJticketuserwaitinglist.count
        }
        else
        {
            return arrJticketwaitinglist.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == tbl_approch
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! JticketwaitingApprochlisting
            
            if selectedIndexpath == indexPath
            {
                cell.btn_checkbox.setImage(#imageLiteral(resourceName: "ic_checked"), for: .normal)
            }
            else
            {
                cell.btn_checkbox.setImage(#imageLiteral(resourceName: "ic_unchecked"), for: .normal)
            }
            
            cell.lbl_jticketno.text = arrJticketuserwaitinglist[indexPath.row]["ticket_number"] as? String ?? "N/A"
            cell.lbl_cashback.text = "\(arrJticketuserwaitinglist[indexPath.row]["price"]!)"
            cell.lbl_pos.text = "\(arrJticketuserwaitinglist[indexPath.row]["waiting"]!)"
            
            cell.btn_checkbox.tag = indexPath.row
            cell.btn_checkbox.addTarget(self, action: #selector(checkbox(sender:)), for: .touchUpInside)
            
            
            return cell
        }
        else
        {
            let userCell = tableView.dequeueReusableCell(withIdentifier: "Jticketwaitinglisting") as! Jticketwaitinglisting
            
            userCell.lblusername.text! = arrJticketwaitinglist[indexPath.row]["userName"] as? String ?? "No Name"
            userCell.lbljticketno.text = arrJticketwaitinglist[indexPath.row]["ticket_number"] as? String ?? "Not Available"
            
            
            userCell.jticketwaitingno.text! =  "\(arrJticketwaitinglist[indexPath.row]["waiting"] as? Int ?? 0)"
            
            let date = arrJticketwaitinglist[indexPath.row]["ApplyDate"] as? String ?? ""
            
            if date != ""  {
                
                userCell.lblappliedDate.text! =  MyModel().convertStringDateToString(strDate:date,
                                                                                     getFormate: "yyyy-MM-dd'T'HH:mm:ss.SSSZ",
                                                                                     returnFormat: "h:mm a dd-MM-yyyy")
            }
            
            let isApproch = arrJticketwaitinglist[indexPath.row]["isApproach"]! as! Int
            
            if isApproch > 0
            {
                userCell.btn_offer_approch.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
                userCell.btn_offer_approch.setTitle("Approched", for: .normal)
                userCell.btn_offer_approch.isUserInteractionEnabled = false
            }
            else
            {
                userCell.btn_offer_approch.backgroundColor = #colorLiteral(red: 0.1019607843, green: 0.3098039216, blue: 0.3647058824, alpha: 1)
                userCell.btn_offer_approch.setTitle("Approch & Offer", for: .normal)
                userCell.btn_offer_approch.isUserInteractionEnabled = true
            }
            
            
            
            userCell.btn_offer_approch.tag = indexPath.row
            userCell.btn_offer_approch.addTarget(self, action: #selector(connected(sender:)), for: .touchUpInside)
            
            
            
            if arrJticketwaitinglist.count > 1 {
                let lastElement = arrJticketwaitinglist.count - 1
                if indexPath.row == lastElement && ismoredata{
                    //call get api for next page
                    getJticketWaitingList()
                }
                
            }
            
            
            
            return userCell
        }
        
    }
    
    @objc func checkbox(sender: UIButton){
        let buttonTag = sender.tag
        print(buttonTag)
        
        selectedIndexpath = IndexPath(row: sender.tag, section: 0)
        
        tbl_approch.reloadData()
    }
    
    @objc func connected(sender: UIButton){
        let buttonTag = sender.tag
        print(buttonTag)
        let ticketId = arrJticketwaitinglist[buttonTag]["j_ticket_id"] as? String ?? ""
        getJticketUserWaitingList()
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.tag = 100
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        vw_approch.center = view.center
        vw_approch.alpha = 1
        vw_approch.transform = CGAffineTransform(scaleX: 0.8, y: 1.2)
        
        self.view.addSubview(vw_approch)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [],  animations: {
            //use if you want to darken the background
            //self.viewDim.alpha = 0.8
            //go back to original form
            self.vw_approch.transform = .identity
        })
        
    }
    
    @IBAction func btn_back(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    //APPROCH VIEW ACTION
    @IBAction func btn_CANCEL_APPROCH(_ sender: Any) {
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0, options: [], animations: {
            //use if you wish to darken the background
            //self.viewDim.alpha = 0
            self.vw_approch.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        }) { (success) in
            for view in self.view.subviews {
                if let viewWithTag = view.viewWithTag(100) {
                    viewWithTag.removeFromSuperview()
                }
            }
            self.vw_approch.removeFromSuperview()
            self.vw_offers.removeFromSuperview()
        }
        
        
    }
    @IBAction func btn_APPY_APPROCH(_ sender: UIButton) {
        
        if sender.tag == 1
        {
            let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = view.bounds
            blurEffectView.tag = 100
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            view.addSubview(blurEffectView)
            vw_offers.center = view.center
            vw_offers.alpha = 1
            vw_offers.transform = CGAffineTransform(scaleX: 0.8, y: 1.2)
            
            self.view.addSubview(vw_offers)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [],  animations: {
                //use if you want to darken the background
                //self.viewDim.alpha = 0.8
                //go back to original form
                self.vw_offers.transform = .identity
            })
        }
        else
        {
            getApplyJticketApproach(ticketApproachOd: "\(arrJticketuserwaitinglist[selectedIndexpath!.row]["id"]!)")
        }
        
    }
    
    @IBAction func btn_DEAL(_ sender: Any) {
        
    }
    
}

class JticketwaitingApprochlisting: UITableViewCell {
    
    @IBOutlet weak var lbl_pos: UILabel!
    @IBOutlet weak var lbl_jticketno: UILabel!
    @IBOutlet weak var lbl_cashback: UILabel!
    @IBOutlet weak var btn_checkbox: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}


class Jticketwaitinglisting: UITableViewCell {
    
    @IBOutlet weak var viewjticketlisting: ViewWithShadow!
    @IBOutlet weak var lblusername: UILabel!
    @IBOutlet weak var btn_offer_approch: UIButton!
    @IBOutlet weak var lbljticketno: UILabel!
    
    @IBOutlet weak var lblappliedDate: UILabel!
    
    @IBOutlet weak var jticketwaitingno: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}

extension JticketWaitingListViewController : UITextFieldDelegate
{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

                 let text: NSString = textField.text! as NSString
                 let resultString = text.replacingCharacters(in: range, with: string)


     //Check the specific textField
      if textField == txt_approch {
        
        
          let textArray = resultString.components(separatedBy: ".")
          if textArray.count > 2 { //Allow only one "."
             return false
          }
        if resultString.count > 2
        {
            if textArray.count > 0 { //Allow only one "."
               return false
            }
        }
        if textArray.count == 2 {
           let lastString = textArray.last
          if lastString!.count > 2 { //Check number of decimal places
                return false
            }
         }
       }
        return true
    }
}


extension JticketWaitingListViewController
{
    // Mark API For Getting ALLJticket
    func getJticketWaitingList() {
        
        Loading().showLoading(viewController: self)
        
        let parameter: [String: Any] = [
            
            "id":id,
            "start": Start,
            "limit":Limit
            
        ]
        let strURL = Define.APP_URL + Define.getWaitingroom
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
                    
                    let content = result!["content"] as! [String: Any]
                    //  self.arrJticketwaitinglist = content["contest"] as? [[String : Any]] ?? [[:]]
                    
                    let arr =  content["contest"] as? [[String : Any]] ?? [["":""]]
                    if arr.count > 0 {
                        self.arrJticketwaitinglist.append(contentsOf: arr)
                        self.ismoredata = true
                        self.Start = self.Start + 30
                        self.Limit =  30
                    }
                    else
                    {
                        self.ismoredata = false
                    }
                    
                    if self.arrJticketwaitinglist.count > 0 {
                        
                        self.lblCurrentWaitingperiod.text = content["currentWaitingPeriod"] as? String ?? ""
                        
                        let imageURL = URL(string: self.arrJticketwaitinglist[0]["image"] as? String ?? "")
                        let data = try? Data(contentsOf: imageURL!)
                        self.imgjticket.image = UIImage(data: data!)
                    }
                    
                    print(self.arrJticketwaitinglist)
                    self.tblwaitinglist.reloadData()
                    
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

extension JticketWaitingListViewController
{
    // Mark API For Getting ALLJticket
    func getJticketUserWaitingList() {
        
        Loading().showLoading(viewController: self)
        arrJticketuserwaitinglist.removeAll()
        
        let parameter: [String: Any] = [
            "id":id
        ]
        let strURL = Define.APP_URL + Define.getUserWaitingList
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
                    
                    let content = result!["content"] as! [String: Any]
                    //  self.arrJticketwaitinglist = content["contest"] as? [[String : Any]] ?? [[:]]
                    
                    let arr =  content["contest"] as? [[String : Any]] ?? [["":""]]
                    if arr.count > 0 {
                        self.arrJticketuserwaitinglist.append(contentsOf: arr)
                    }
                    
                    
                    self.tbl_approch.reloadData()
                    
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

extension JticketWaitingListViewController
{
    // Mark API For Getting ALLJticket
    func getApplyJticketApproach(ticketApproachOd:String) {
        
        Loading().showLoading(viewController: self)
        arrJticketuserwaitinglist.removeAll()
        
        let ticketId = "\(arrJticketwaitinglist[selectedIndexpath!.row]["id"]!)"
        
        let parameter: [String: Any] = [
            "ticketId":ticketId,
            "ticketIdApproach":ticketApproachOd,
            "Approach":txt_approch.text!
        ]
        let strURL = Define.APP_URL + Define.ApplyJtciketApproach
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
                    
                    let content = result!["content"] as! [String: Any]
                    //  self.arrJticketwaitinglist = content["contest"] as? [[String : Any]] ?? [[:]]
                    
                    self.btn_CANCEL_APPROCH(UIButton.self)
                    
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


extension JticketWaitingListViewController {
    
    func retry() {
        
        let alertController = UIAlertController(title: Define.ERROR_TITLE,
                                                message: Define.ERROR_SERVER,
                                                preferredStyle: .alert)
        let buttonRetry = UIAlertAction(title: "Retry",
                                        style: .default)
        { _ in
            self.getJticketWaitingList()
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

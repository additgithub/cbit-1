//
//  MyJticketViewController.swift
//  CBit
//
//  Created by My Mac on 19/12/19.
//  Copyright © 2019 Bhavik Kothari. All rights reserved.
//

import UIKit
import DropDown

class MyJticketViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    
    @IBOutlet weak var lblapd: UILabel!
    @IBOutlet weak var lbltap: UILabel!
    @IBOutlet weak var lblbap: UILabel!
    
    
    private var isFirstTime = Bool()
    
    private var arrMyJTicket = [[String: Any]]()
    
    var MainarrMyJTicket = [[String: Any]]()
    var MyJTicketDateArr = [[String: Any]]()
    var MyJTicketNameArr = [[String: Any]]()
    var arrApproachList = [[String:Any]]()
    
    var isasc = true
    private var id = 0
    private var jticketid = 0
    
    var Start = 0
    var Limit = 10
    var ismoredata = false
    
    var status = "0"
    var filterASC = "ASC"
    var filterticketname = ""
    var filterByDate = ""
    var filterByExchange = "1"
    var isfromtab = false
    
    @IBOutlet weak var tbllistingMyjticket: UITableView!
    
    @IBOutlet weak var segment: UISegmentedControl!
    
    @IBOutlet weak var lblApdrefresh: UILabel!
    
    @IBOutlet weak var filtervw: UIView!
    @IBOutlet weak var vw_sortbyexchange_hide: UIView!
    @IBOutlet weak var imgdt: UIImageView!
    @IBOutlet weak var btnsortbydate: UIButton!
    @IBOutlet weak var btnbydate: UIButton!
    @IBOutlet weak var btnbyjticket: UIButton!
    
    @IBOutlet var vw_exchangeoffer: UIView!
    @IBOutlet weak var tbl_offer: UITableView!
    
    @IBOutlet weak var btn_sortbyexchange: UIButton!
    @IBOutlet weak var img_exchange: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getjticketdate()
        getUserJticket()
        getjticketname()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    @IBAction func btn_CLOSE_POPUP(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0, options: [], animations: {
            //use if you wish to darken the background
            //self.viewDim.alpha = 0
            self.vw_exchangeoffer.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        }) { (success) in
            for view in self.view.subviews {
                if let viewWithTag = view.viewWithTag(100) {
                    viewWithTag.removeFromSuperview()
                }
            }
            self.vw_exchangeoffer.removeFromSuperview()
            
        }
    }
    
    @IBAction func btn_HIDE_EXCHANGEPOP(_ sender: Any) {
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0, options: [], animations: {
            //use if you wish to darken the background
            //self.viewDim.alpha = 0
            self.vw_exchangeoffer.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        }) { (success) in
            for view in self.view.subviews {
                if let viewWithTag = view.viewWithTag(100) {
                    viewWithTag.removeFromSuperview()
                }
            }
            self.vw_exchangeoffer.removeFromSuperview()
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tbl_offer
        {
            return arrApproachList.count
        }
        else
        {
            return arrMyJTicket.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tbl_offer
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! MyJticketCell
            
            cell.lbl_username.text = arrApproachList[indexPath.row]["userName"] as? String ?? ""
            cell.lbl_offer.text = "\(arrApproachList[indexPath.row]["offer"] as? Int ?? 0) %"
            cell.txt_offer.tag = indexPath.row
            
            cell.btn_confirm.tag = indexPath.row
            cell.btn_confirm.addTarget(self, action: #selector(checkbox(sender:)), for: .touchUpInside)
            
            
            return cell
        }
        else
        {
            let userCell = tableView.dequeueReusableCell(withIdentifier: "MyJticketlisting") as! MyJticketlisting
            userCell.btnapply.addTarget(self, action: #selector(btnapply(_:event:)), for: .touchUpInside)
            userCell.lbldate.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
            
            userCell.imgjticketbackground.layer.shadowColor = UIColor.black.cgColor
            userCell.imgjticketbackground.layer.shadowOffset = CGSize(width: 0, height: 1)
            userCell.imgjticketbackground.layer.shadowOpacity = 4
            userCell.imgjticketbackground.layer.shadowRadius = 8.0
            userCell.imgjticketbackground.clipsToBounds = false
            
            
            userCell.lbljticketno.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
            
            //         userCell.lblname.text! = arrMyJTicket[indexPath.row]["name"] as? String ?? ""
            //
            let price = arrMyJTicket[indexPath.row]["price"] as? Double ?? 0
            
            
            userCell.lblprice.text! = "Redeemed @ CC \(price)"
            
            userCell.lbljticketno.text! = arrMyJTicket[indexPath.row]["ticket_number"] as? String ?? ""
            // userCell.lblwaitingno.text! = "\(arrMyJTicket[indexPath.row]["waiting"] as? Int ??
            
            let date = arrMyJTicket[indexPath.row]["ApplyDate"] as? String ?? ""
            if date != ""
            {
                userCell.lbldate.text! =   MyModel().convertStringDateToString(strDate:date,
                                                                               getFormate: "dd-MM-yyyy HH:mm:ss a", returnFormat: "dd-MM-yyyy")
                
            }
            else{
                userCell.lbldate.text! =  ""
            }
            let status =  arrMyJTicket[indexPath.row]["status"] as! Int
            print(status)
            if status == 0 {
                
                userCell.btnapply.setTitle("Apply Now", for: .normal)
                userCell.btnapply.isUserInteractionEnabled = true
                //   userCell.lblwon.isHidden = true
                //    userCell.lblwinningprice.isHidden  = true
                userCell.btnapply.backgroundColor = #colorLiteral(red: 0.09803921569, green: 0.3098039216, blue: 0.3647058824, alpha: 1)
                userCell.vwhit.isHidden = true
                userCell.lbldate.isHidden = true
                userCell.stack_view.isHidden = true
                userCell.btnapply.isHidden = false
            }
            else if status == 1 {
                
                let  waiting = arrMyJTicket[indexPath.row]["waiting"] as? Int ?? 0
                let price = arrMyJTicket[indexPath.row]["WinningAmount"] as? Double ?? 0.00
                
                userCell.btnapply.setTitle("Current Waiting : \(waiting)" , for: .normal)
                userCell.btnapply.isUserInteractionEnabled = false
                
                userCell.btnapply.backgroundColor = #colorLiteral(red: 0.9670128226, green: 0.7354109883, blue: 0.1693300009, alpha: 1)
                userCell.vwhit.isHidden = true
                userCell.lbldate.isHidden = true
                
                userCell.stack_view.isHidden = false
                
                userCell.btn_exhange.tag = indexPath.row
                userCell.btn_exhange.addTarget(self, action: #selector(btnExchange(sender:)), for: .touchUpInside)
                
                let tot = arrMyJTicket[indexPath.row]["ApproachList"] as? [[String:Any]] ?? []
                userCell.btn_exhange.setTitle("Exchange Offer:\(tot.count)", for: .normal)
                
                userCell.btn_waiting_no.setTitle("Current Waiting\n No:\(waiting)", for: .normal)
                userCell.btn_cash_back.setTitle("Cashback upto :\n ₹\(price)", for: .normal)
                userCell.btn_waiting_no.titleLabel?.textAlignment = .center
                userCell.btn_cash_back.titleLabel?.textAlignment = .center
                
            }
            else if status == 2 {
                
                userCell.btnapply.setTitle("Cashback Received Rs.\(arrMyJTicket[indexPath.row]["WinningAmount"] as? Double ?? 0)", for: .normal)
                
                userCell.btnapply.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
                
                
                userCell.btnapply.isUserInteractionEnabled = false
                userCell.vwhit.isHidden = false
                userCell.lbldate.isHidden = false
                userCell.lbldt.text = userCell.lbldate.text!
                userCell.stack_view.isHidden = true
            }
            
            let imageURL = URL(string: arrMyJTicket[indexPath.row]["image"] as? String ?? "")
            userCell.imgjticket.sd_setImage(with: imageURL,placeholderImage:Define.PLACEHOLDER_PROFILE_IMAGE)
            
            if arrMyJTicket.count > 1 {
                let lastElement = arrMyJTicket.count - 1
                if indexPath.row == lastElement && ismoredata{
                    //call get api for next page
                    getUserJticket()
                }
                
            }
            return userCell
        }
        
        
    }
    
    @objc func checkbox(sender: UIButton){
        let buttonTag = sender.tag
        print(buttonTag)
        let index = IndexPath(row: buttonTag, section: 0)
        let cell: MyJticketCell = self.tbl_offer.cellForRow(at: index) as! MyJticketCell
        let user_approch_j_ticket_id = arrApproachList[sender.tag]["j_ticket_user_approach_id"] as? Int
        
        if cell.txt_offer.text?.count ?? 0 > 0
        {
            
            let offerPrice = cell.txt_offer.text!
            getApplyJticketApproachNagotiate(ticketApproachOd: "\(String(describing: user_approch_j_ticket_id!))", nagotiatePrice: offerPrice)
        }
        else
        {
            showToast(message: "Plese enter nagotiate.", font: UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.thin))
        }
        
    }
    
    @objc func btnExchange(sender: UIButton){
        let buttonTag = sender.tag
        print(buttonTag)
        
        arrApproachList.removeAll()
        arrApproachList = arrMyJTicket[sender.tag]["ApproachList"] as? [[String:Any]] ?? []
        
        if arrApproachList.count > 0
        {
            let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = view.bounds
            blurEffectView.tag = 100
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            view.addSubview(blurEffectView)
            vw_exchangeoffer.center = view.center
            vw_exchangeoffer.alpha = 1
            vw_exchangeoffer.transform = CGAffineTransform(scaleX: 0.8, y: 1.2)
            
            self.view.addSubview(vw_exchangeoffer)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [],  animations: {
                
                self.vw_exchangeoffer.transform = .identity
            })
            
            tbl_offer.reloadData()
        }
    }
    
    
    @IBAction func btn_SORT_BY_EXCHANGE(_ sender: UIButton) {
        
        if sender.tag == 0
        {
            img_exchange.image = UIImage(named: "ic_send")
            btn_sortbyexchange.tag = 1
            filterByExchange = "1"
        }
        else
        {
            
            img_exchange.image = UIImage(named: "ic_recive")
            btn_sortbyexchange.tag = 0
            filterByExchange = "0"
        }
    }
    
    @IBAction func btn_back(_ sender: Any) {
        self.dismiss(animated: true)
    }
    @IBAction func redeemed_click(_ sender: UIBarButtonItem) {
        
        
    }
    @IBAction func applied_click(_ sender: UIBarButtonItem) {
        
    }
    @IBAction func hit_click(_ sender: UIBarButtonItem) {
        
    }
    
    //    func sortArrayDictDescending(dict: [Dictionary<String, String>], dateFormat: String) -> [Dictionary<String, String>] {
    //                    let dateFormatter = DateFormatter()
    //                    dateFormatter.dateFormat = dateFormat
    //                    return dict.sorted{[dateFormatter] one, two in
    //                        return dateFormatter.date(from: one["date"]! )! > dateFormatter.date(from: two["date"]! )! }
    //                }
    @IBAction func filter_click(_ sender: UIButton) {
        filtervw.isHidden = false
        
        if status == "0"
        {
            vw_sortbyexchange_hide.isHidden = false
        }
        else
        {
            vw_sortbyexchange_hide.isHidden = true
        }
        
        
        
        
    }
    @IBAction func btnsortbydate_click(_ sender: UIButton) {
        
        //        let dateFormatter: DateFormatter = DateFormatter()
        //        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss a"
        //        let tempArray: NSMutableArray = NSMutableArray()
        //        for i in 0..<MainarrMyJTicket.count {
        //            let dic: NSMutableDictionary = (MainarrMyJTicket[i] as NSDictionary).mutableCopy() as! NSMutableDictionary
        //            let dateConverted: NSDate = dateFormatter.date(from: dic["ApplyDate"] as? String ?? "") as NSDate? ?? NSDate()
        //            let strdate = dateFormatter.string(from: dateConverted as Date)
        //            dic["ApplyDate"] = strdate
        //            tempArray.add(dic)
        //        }
        
        
        if isasc {
            imgdt.image = UIImage(named: "ic_recive")
            isasc = false
            filterASC = "DESC"
            //            let descriptor: NSSortDescriptor = NSSortDescriptor(key: "ApplyDate", ascending: false)
            //            let descriptors: NSArray = [descriptor]
            //            let sortedArray: NSArray = tempArray.sortedArray(using: descriptors as! [NSSortDescriptor]) as NSArray
            //            NSLog("%@", sortedArray)
            //            self.arrMyJTicket = sortedArray as! [[String : Any]]
        }
        else
        {
            imgdt.image = UIImage(named: "ic_send")
            isasc = true
            filterASC = "ASC"
            //            let descriptor: NSSortDescriptor = NSSortDescriptor(key: "ApplyDate", ascending: true)
            //            let descriptors: NSArray = [descriptor]
            //            let sortedArray: NSArray = tempArray.sortedArray(using: descriptors as! [NSSortDescriptor]) as NSArray
            //            NSLog("%@", sortedArray)
            //            self.arrMyJTicket = sortedArray as! [[String : Any]]
        }
        if segment.selectedSegmentIndex == 0 {
            //            self.arrMyJTicket = self.arrMyJTicket.filter{($0["status"] as! Int) == 0}
            //            tbllistingMyjticket.reloadData()
        }
        else if segment.selectedSegmentIndex == 1 {
            //            self.arrMyJTicket = self.arrMyJTicket.filter{($0["status"] as! Int) == 1}
            //            tbllistingMyjticket.reloadData()
        }
        else if segment.selectedSegmentIndex == 2 {
            //            self.arrMyJTicket = self.arrMyJTicket.filter{($0["status"] as! Int) == 2}
            //            tbllistingMyjticket.reloadData()
        }
        
        if arrMyJTicket.count > 0 {
            tbllistingMyjticket.isHidden = false
            tbllistingMyjticket.setContentOffset(.zero, animated: true)
            tbllistingMyjticket.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableView.ScrollPosition.top, animated: true)
        }
        else
        {
            tbllistingMyjticket.isHidden = true
        }
        
    }
    @IBAction func btnbydate_click(_ sender: UIButton) {
        let  dropDown1 = DropDown()
        
        //  dropDown1.dataSource = self.MainarrMyJTicket.compactMap{$0["FilterDate"] as? String}.removeDuplicates()
        dropDown1.dataSource = self.MyJTicketDateArr.compactMap{$0["Date"] as? String}
        dropDown1.anchorView =  sender
        
        dropDown1.selectionAction = {
            
            [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            
            
            self.btnbydate.setTitle( item, for: .normal)
            self.filterByDate = item
            
            //  self.arrMyJTicket = self.MainarrMyJTicket.filter{($0["FilterDate"] as! String) == item}
            if self.segment.selectedSegmentIndex == 0 {
                //                        self.arrMyJTicket = self.arrMyJTicket.filter{($0["status"] as! Int) == 0}
                //                        tbllistingMyjticket.reloadData()
            }
            else if self.segment.selectedSegmentIndex == 1 {
                //                        self.arrMyJTicket = self.arrMyJTicket.filter{($0["status"] as! Int) == 1}
                //                        tbllistingMyjticket.reloadData()
            }
            else if self.segment.selectedSegmentIndex == 2 {
                //                        self.arrMyJTicket = self.arrMyJTicket.filter{($0["status"] as! Int) == 2}
                //                        tbllistingMyjticket.reloadData()
            }
            
            if self.arrMyJTicket.count > 0 {
                self.tbllistingMyjticket.isHidden = false
                self.tbllistingMyjticket.setContentOffset(.zero, animated: true)
                self.tbllistingMyjticket.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableView.ScrollPosition.top, animated: true)
            }
            else
            {
                self.tbllistingMyjticket.isHidden = true
            }
        }
        dropDown1.show()
    }
    @IBAction func byjticket_click(_ sender: UIButton) {
        
        let  dropDown2 = DropDown()
        //        let idarr = self.MainarrMyJTicket.compactMap{$0["j_ticket_id"] as? Int}.removeDuplicates()
        //        dropDown2.dataSource = self.MainarrMyJTicket.compactMap{$0["name"] as? String}.removeDuplicates()
        dropDown2.dataSource = self.MyJTicketNameArr.compactMap{$0["name"] as? String}
        
        dropDown2.anchorView =  sender
        
        
        dropDown2.selectionAction = {
            
            [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            
            self.btnbyjticket.setTitle( item, for: .normal)
            self.filterticketname = String(self.MyJTicketNameArr[index]["id"] as! Int)
            //  self.arrMyJTicket = self.MainarrMyJTicket.filter{($0["name"] as! String) == item}
            if self.segment.selectedSegmentIndex == 0 {
                //                        self.arrMyJTicket = self.arrMyJTicket.filter{($0["status"] as! Int) == 0}
                //                        tbllistingMyjticket.reloadData()
            }
            else if self.segment.selectedSegmentIndex == 1 {
                //                        self.arrMyJTicket = self.arrMyJTicket.filter{($0["status"] as! Int) == 1}
                //                        tbllistingMyjticket.reloadData()
            }
            else if self.segment.selectedSegmentIndex == 2 {
                //                        self.arrMyJTicket = self.arrMyJTicket.filter{($0["status"] as! Int) == 2}
                //                        tbllistingMyjticket.reloadData()
            }
            
            if self.arrMyJTicket.count > 0 {
                self.tbllistingMyjticket.isHidden = false
                self.tbllistingMyjticket.setContentOffset(.zero, animated: true)
                self.tbllistingMyjticket.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableView.ScrollPosition.top, animated: true)
            }
            else
            {
                self.tbllistingMyjticket.isHidden = true
            }
        }
        dropDown2.show()
    }
    @IBAction func apply_click(_ sender: UIButton) {
        filtervw.isHidden = true
        if segment.selectedSegmentIndex == 0 {
            status = "0"
        }
        else if segment.selectedSegmentIndex == 1 {
            status = "1"
        }
        else if segment.selectedSegmentIndex == 2 {
            status = "2"
        }
        arrMyJTicket = [[String:Any]]()
        MainarrMyJTicket = [[String:Any]]()
        Start = 0
        Limit = 10
        isfromtab = true
        getUserJticket()
    }
    @IBAction func clear_click(_ sender: UIButton) {
        filtervw.isHidden = true
        segmentchanged(segment)
    }
    @IBAction func close_click(_ sender: UIButton) {
        filtervw.isHidden = true
    }
    
    @IBAction func segmentchanged(_ sender: UISegmentedControl) {
        imgdt.image = UIImage(named: "ic_send")
        isasc = true
        btnbydate.setTitle("By Date", for: .normal)
        btnbyjticket.setTitle("By JTicket", for: .normal)
        
        img_exchange.image = UIImage(named: "ic_send")
        filterByExchange = "1"
        btn_sortbyexchange.tag = 1
        
        isfromtab = true
        filterticketname = ""
        filterByDate = ""
        filterASC = "ASC"
        //                if arrMyJTicket.count > 0 {
        //                    tbllistingMyjticket.isHidden = false
        //                    tbllistingMyjticket.setContentOffset(.zero, animated: true)
        //                    tbllistingMyjticket.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableView.ScrollPosition.top, animated: true)
        //                           }
        //                           else
        //                           {
        //                              tbllistingMyjticket.isHidden = true
        //                           }
        
        arrMyJTicket = [[String:Any]]()
        MainarrMyJTicket = [[String:Any]]()
        Start = 0
        Limit = 10
        
        if segment.selectedSegmentIndex == 0 {
            //            self.arrMyJTicket = self.MainarrMyJTicket.filter{($0["status"] as! Int) == 0}
            //            tbllistingMyjticket.reloadData()
            status = "0"
            filterByExchange = "0"
        }
        else if segment.selectedSegmentIndex == 1 {
            //            self.arrMyJTicket = self.MainarrMyJTicket.filter{($0["status"] as! Int) == 1}
            //            tbllistingMyjticket.reloadData()
            status = "1"
        }
        else if segment.selectedSegmentIndex == 2 {
            //            self.arrMyJTicket = self.MainarrMyJTicket.filter{($0["status"] as! Int) == 2}
            //            tbllistingMyjticket.reloadData()
            status = "2"
        }
        getUserJticket()
        getjticketdate()
        getjticketname()
    }
}
class MyJticketlisting: UITableViewCell {
    
    
    @IBOutlet weak var imgjticketbackground: UIImageView!
    
    
    @IBOutlet weak var imgjticket: UIImageView!
    @IBOutlet weak var lblname: UILabel!
    
    @IBOutlet weak var lblwaitingno: UILabel!
    
    @IBOutlet weak var lbldate: UILabel!
    
    @IBOutlet weak var lbljticketno: UILabel!
    
    @IBOutlet weak var lblprice: UILabel!
    
    @IBOutlet weak var btnapply: UIButton!
    
    @IBOutlet weak var lblwinningprice: UILabel!
    
    @IBOutlet weak var lblwon: UILabel!
    
    @IBOutlet var vwhit: UIView!
    @IBOutlet var lbldt: UILabel!
    
    @IBOutlet weak var stack_view: UIStackView!
    @IBOutlet weak var btn_exhange: UIButton!
    @IBOutlet weak var btn_waiting_no: UIButton!
    @IBOutlet weak var btn_cash_back: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        vwhit.transform = CGAffineTransform(rotationAngle: 125 )
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}

extension MyJticketViewController {
    // Mark API For Getting ALLJticket
    func getUserJticket()  {
        
        if status == "0"
        {
            filterByExchange = "0"
        }
        
        if isFirstTime {
            Loading().showLoading(viewController: self)
        }
        let strURL = Define.APP_URL + Define.getUserJTicket
        print("URL: \(strURL)")
        
        let parameter: [String: Any] = [
            "status":status,
            "start":Start,
            "limit":Limit,
            "filterAscDesc":filterASC,
            "filterTicketName":filterticketname,
            "filterByDate":filterByDate,
            "sortByApproch":filterByExchange
        ]
        
        SwiftAPI().postMethodSecure(stringURL: strURL,
                                    parameters: parameter,
                                    header: Define.USERDEFAULT.value(forKey: "AccessToken") as? String,
                                    auther: Define.USERDEFAULT.value(forKey: "UserID") as? String)
        { (result, error) in
            if error != nil {
                if self.isFirstTime {
                    self.isFirstTime = false
                    Loading().hideLoading(viewController: self)
                }
                print("Error: \(error!)")
                self.getUserJticket()
            } else {
                if self.isFirstTime {
                    
                    self.isFirstTime = false
                    Loading().hideLoading(viewController: self)
                    
                }
                print("Result: \(result!)")
                
                let status = result!["statusCode"] as? Int ?? 0
                if status == 200 {
                    
                    let content = result!["content"] as? [String: Any] ?? [:]
                    let apddict : NSDictionary = result!["content"] as! NSDictionary
                    
                    //  self.arrMyJTicket = content["contest"] as? [[String : Any]] ?? [[:]]
                    //  self.MainarrMyJTicket = content["contest"] as? [[String : Any]] ?? [[:]]
                    
                    // self.arrMyJTicket = self.MainarrMyJTicket.filter{($0["status"] as! Int) == 0}
                    
                    print(self.arrMyJTicket)
                    print(content)
                    
                    
                    let arr =  content["contest"] as! [[String : Any]]
                    if arr.count > 0 {
                        self.arrMyJTicket.append(contentsOf: arr)
                        self.MainarrMyJTicket.append(contentsOf: arr)
                        self.ismoredata = true
                        self.Start = self.Start + 10
                        self.Limit =  10
                    }
                    else
                    {
                        self.ismoredata = false
                    }
                    
                    
                    
                    let APD = "\(apddict.value(forKey:"ADP") as? String ?? "0.00")"
                    
                    guard let amountPB = Double(APD) else {
                        return
                    }
                    self.lblapd.text = MyModel().getCurrncy(value: amountPB)
                    
                    // self.lblapd.text! = "₹" + "\(Double(APD)!.rounded(toPlaces:2))"
                    
                    self.lblApdrefresh.text = "Your APD Cycle refreshes on " + "\(apddict.value(forKey:"DayOfJoin") as? Int ?? 0)th" + " of every month"
                    print(self.lblapd.text!)
                    self.lblbap.text = "CC - \(apddict["BAP"]!)"
                    self.lbltap.text = "CC - \(apddict["TAP"]!)"
                    self.tbllistingMyjticket.reloadData()
                    
                    if self.arrMyJTicket.count > 0 {
                        self.tbllistingMyjticket.isHidden = false
                    }
                    else
                    {
                        self.tbllistingMyjticket.isHidden = true
                    }
                    
                    if self.isfromtab && self.arrMyJTicket.count > 0{
                        self.isfromtab = false
                        self.tbllistingMyjticket.setContentOffset(.zero, animated: true)
                        self.tbllistingMyjticket.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableView.ScrollPosition.top, animated: true)
                    }
                    
                    
                } else if status == 401 {
                    
                    Define.APPDELEGATE.handleLogout()
                } else {
                    
                    Alert().showAlert(title: "Error",
                                      message: result!["message"] as! String,
                                      viewController: self)
                }
            }
        }
    }
    
    
    func getjticketdate() {
        
        Loading().showLoading(viewController: self)
        
        let parameter: [String: Any] = [
            "status":status
        ]
        let strURL = Define.APP_URL + Define.getUserJTicketDate
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
                    
                    let content = result!["content"] as? [String: Any] ?? [:]
                    self.MyJTicketDateArr = content["Dates"] as? [[String: Any]] ?? []
                    
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
    
    func getjticketname() {
        
        Loading().showLoading(viewController: self)
        
        let parameter: [String: Any] = [
            "status":status
        ]
        let strURL = Define.APP_URL + Define.getUserJTicketName
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
                    
                    let content = result!["content"] as? [String: Any] ?? [:]
                    self.MyJTicketNameArr = content["Names"] as? [[String: Any]] ?? []
                    
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
    
    //Mark APi For Applying Jticket
    
    func ApplyJticket() {
        
        Loading().showLoading(viewController: self)
        
        let parameter: [String: Any] = [
            
            "id":id
            
        ]
        let strURL = Define.APP_URL + Define.ApplyJtciket
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
                    
                    
                    self.tbllistingMyjticket.reloadData()
                    let alertController = UIAlertController(title:"Alert",
                                                            message: result!["message"] as! String,
                                                            preferredStyle: .alert)
                    let ok = UIAlertAction(title: "OK", style: .default, handler: { action in   self.OkPressed()})
                    alertController.addAction(ok)
                    self.present(alertController, animated: true, completion: nil)
                    
                    print(self.arrMyJTicket)
                    
                    
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
        //        let jticketwaitinglist = self.storyboard?.instantiateViewController(withIdentifier: "JticketWaitingListViewController") as! JticketWaitingListViewController
        //        //  gamePlayVC.isFromNotification = true
        //        jticketwaitinglist.id = jticketid
        //        self.present(jticketwaitinglist, animated: true, completion: nil)
        
        getUserJticket()
    }
    
    @objc func btnapply(_ sender: Any, event: Any) {
        
        
        let point : CGPoint = (sender as AnyObject).convert(CGPoint.zero, to:tbllistingMyjticket)
        var indexPath =  self.tbllistingMyjticket!.indexPathForRow(at: point)
        var selectedrow = indexPath!.row
        
        
        id =  (arrMyJTicket[selectedrow] as AnyObject).value(forKey:"id") as! Int
        jticketid = (arrMyJTicket[selectedrow] as AnyObject).value(forKey:"j_ticket_id") as! Int
        ApplyJticket()
        
        
    }
    
    func getApplyJticketApproachNagotiate(ticketApproachOd:String,nagotiatePrice:String) {
        
        Loading().showLoading(viewController: self)
        
        let parameter: [String: Any] = [
            "j_ticket_user_approach_id":ticketApproachOd,
            "negotiate":nagotiatePrice
        ]
        
        let strURL = Define.APP_URL + Define.ApplyApproachNegotiate
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
                    //self.arrJticketwaitinglist.removeAll()
                    //self.Start = 0
                    //self.getJticketWaitingList()
                    let btn = UIButton()
                    self.btn_CLOSE_POPUP(btn)
                    
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


//MARK: - TableCell Class
class MyJticketCell :UITableViewCell
{
    @IBOutlet weak var btn_confirm: UIButton!
    @IBOutlet weak var txt_offer: UITextField!
    @IBOutlet weak var lbl_offer: UILabel!
    @IBOutlet weak var lbl_username: UILabel!
    
}

//MARK: - Alert Contollert
extension MyJticketViewController {
    func retry() {
        let alertController = UIAlertController(title: Define.ERROR_TITLE,
                                                message: Define.ERROR_SERVER,
                                                preferredStyle: .alert)
        let buttonRetry = UIAlertAction(title: "Retry",
                                        style: .default)
        { _ in
            self.getUserJticket()
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

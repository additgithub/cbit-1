import UIKit
import SideMenuSwift
import SDWebImage

struct SideMenu {
    var menuTitle = String()
    var arrSubMenu: [String]?
    var isExpande = Bool()
    init(title: String, subMenus: [String]?, isExpand: Bool = false) {
        menuTitle = title
        arrSubMenu = subMenus
        self.isExpande = isExpand
    }
}
class SideMenuVC: UIViewController,UIGestureRecognizerDelegate {
    //MARK: - Propertires
    @IBOutlet weak var viewProfile: UIView!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var tableMenu: UITableView!
    @IBOutlet weak var labelUserName: UILabel!
    
    @IBOutlet weak var lblapd: UILabel!
    @IBOutlet weak var lblefm: UILabel!
    @IBOutlet weak var lblem: UILabel!
    @IBOutlet weak var lblbap: UILabel!
    
    @IBOutlet weak var constratinSideMenuTrailing: NSLayoutConstraint!
    @IBOutlet weak var constraintTableHeight: NSLayoutConstraint!
    
//    let arrMenuList = ["DASHBOARD",
//                       "J Magic ",
//                       "WALLET",
//                       "NOTIFICATION",
//                       "HISTORY",
//                       "TERMS & CONDITION",
//                       "ABOUT US",
//                       "CHANGE PASSWORD",
//                       "SETTINGS",
//                       "LEGALITY"]
    
    var arrSideMenu: [SideMenu] = [
        SideMenu(title: "Home", subMenus: nil, isExpand: false),
        SideMenu(title: "Apply for cashback", subMenus: [
            "Redeem J Tickets",
            "My J Tickets",
            "Waiting Room",
            "Auto Pilot Mode",
            "T & C"
            ], isExpand: false),
        //SideMenu(title: "Private Room", subMenus: [
           // "Create Group",
           // "Join Group",
           // "My Group"
           // ], isExpand: false),
        SideMenu(title: "Referral Network", subMenus: nil, isExpand: false),
        SideMenu(title: "Easy Join", subMenus: nil, isExpand: false),
        //SideMenu(title: "PACKAGES", subMenus: nil, isExpand: false),
        //SideMenu(title: "Horoscope", subMenus: nil, isExpand: false),
        SideMenu(title: "Wallet", subMenus: nil, isExpand: false),
        SideMenu(title: "Notification", subMenus: nil, isExpand: false),
        SideMenu(title: "History", subMenus: nil, isExpand: false),
     //   SideMenu(title: "Invite Friends", subMenus: nil, isExpand: false),
        SideMenu(title: "Settings", subMenus: nil, isExpand: false),
  //      SideMenu(title: "PACKAGES", subMenus: nil, isExpand: false),
        //SideMenu(title: "TERMS & CONDITION", subMenus: nil, isExpand: false),
        //SideMenu(title: "LEGALITY", subMenus: nil, isExpand: false),
        
    SideMenu(title: "How to Play", subMenus: nil, isExpand: false),
    SideMenu(title: "Help Center", subMenus: nil, isExpand: false),
   
  
       SideMenu(title: "FAQ's", subMenus: nil, isExpand: false),
        SideMenu(title: "About Us", subMenus: [
             "About Us",
             "T & C",
             "Privacy Policy",
             "Legality"
         ], isExpand: false),
        //SideMenu(title: "Change Password", subMenus: nil, isExpand: false),
        
        
        
        
    ]
    
    var selectedIndex: Int = 0
    var adp = String()
    var efm = String()
    var em = String()
    var cc = String()
    var DayOfJoin = String()
    
    //MARK: - Default Method.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSideMenu()
        setViewController()
        tableMenu.rowHeight = 60
        tableMenu.sectionHeaderHeight = 60
        
        //Add Notification
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleNotification),
                                               name: .userUnauthorized,
                                               object: nil)
        setData()
        
        let tapGesture1 : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(lblapdClick(tapGesture:)))
        tapGesture1.delegate = self
        tapGesture1.numberOfTapsRequired = 1
        lblapd.tag = 1
        lblapd.isUserInteractionEnabled = true
        lblapd.addGestureRecognizer(tapGesture1)
        
        let tapGesture2 : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(lblapdClick(tapGesture:)))
        tapGesture2.delegate = self
        tapGesture2.numberOfTapsRequired = 1
        lblefm.tag = 2
        lblefm.isUserInteractionEnabled = true
        lblefm.addGestureRecognizer(tapGesture2)
        
        let tapGesture3 : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(lblapdClick(tapGesture:)))
        tapGesture3.delegate = self
        tapGesture3.numberOfTapsRequired = 1
        lblem.tag = 3
        lblem.isUserInteractionEnabled = true
        lblem.addGestureRecognizer(tapGesture3)
        
        let tapGesture4 : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(lblapdClick(tapGesture:)))
        tapGesture4.delegate = self
        tapGesture4.numberOfTapsRequired = 1
        lblbap.tag = 4
        lblbap.isUserInteractionEnabled = true
        lblbap.addGestureRecognizer(tapGesture4)
    }
    
    @objc func lblapdClick(tapGesture:UITapGestureRecognizer){
        let tagindex = tapGesture.view!.tag
       print("Lable tag is:\(tagindex)")
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 1

        let myString1 = formatter.string(from: NSNumber(value: Double(adp)!))
        let myString2 = formatter.string(from: NSNumber(value: Double(efm)!))
        let myString3 = formatter.string(from: NSNumber(value: Double(em)!))
        let myString4 = formatter.string(from: NSNumber(value: Double(cc)!))
        
        
        if tagindex == 1 {
            let alert = UIAlertController(title: "", message: "APD : Average Play Per Day \n ₹ \(myString1 ?? "")\n Your APD cycle refreshes on \(DayOfJoin)th of every month.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if tagindex == 2
        {
            let alert = UIAlertController(title: "", message: "EFM : Entry fee metre \n  ₹ \(myString2 ?? "") \n EFM marks a count of your till date entry fee amount paid to join contests.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if tagindex == 3
        {
            let alert = UIAlertController(title: "", message: "EM : Earning Metre \n ₹ \(myString3 ?? "") \n Earning metre marks a count of your till date earnings in this app which includes : Winnings , J Hits ( Cashback on J ticket ) and Overall Referral Commission credited.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if tagindex == 4
        {
            let alert = UIAlertController(title: "", message: "BAP : Balance Apply Potential \n CC \(myString4 ?? "") \n You can apply J tickets worth CC \(myString4 ?? "") until midnight . Increase your APD to extend the BAP limit.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
       
       
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        labelUserName.text = Define.USERDEFAULT.value(forKey: "UserName") as? String ?? "No Name"
        
        //let imageURL = URL(string: Define.USERDEFAULT.value(forKey: "ProfileImage") as? String ?? "")
        //imageProfile.sd_setImage(with: imageURL,
                                 //placeholderImage: Define.PLACEHOLDER_PROFILE_SIDE_IMAGE)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        //MyModel().roundCorners(corners: [.bottomLeft], radius: self.viewProfile.frame.height, view: viewProfile)
        //MyModel().roundCorners(corners: [.bottomLeft], radius: self.imageProfile.frame.height, view: imageProfile)
        setSideMenuHeight()
        
    }
    
    func setSideMenuHeight() {
        self.tableMenu.layoutIfNeeded()
        if arrSideMenu[1].isExpande {
            constraintTableHeight.constant = CGFloat((60 * arrSideMenu.count) + (arrSideMenu[1].arrSubMenu!.count * 60))
        }
        /*else if arrSideMenu[2].isExpande {
            constraintTableHeight.constant = CGFloat((60 * arrSideMenu.count) + (arrSideMenu[2].arrSubMenu!.count * 60))
        }*/
        else if arrSideMenu[11].isExpande {
            constraintTableHeight.constant = CGFloat((60 * arrSideMenu.count) + (arrSideMenu[11].arrSubMenu!.count * 60))
        }
        else {
            constraintTableHeight.constant = CGFloat(60 * arrSideMenu.count)
        }
        self.tableMenu.layoutIfNeeded()
    }
    
    @objc func handleNotification() {
        Define.APPDELEGATE.handleLogout()
    }
    
    func setSideMenu() {
        constratinSideMenuTrailing.constant = 0
        let showPlaceTableOnLeft = (SideMenuController.preferences.basic.position == .under) != (SideMenuController.preferences.basic.direction == .right)
        
        if showPlaceTableOnLeft {
            
            constratinSideMenuTrailing.constant = SideMenuController.preferences.basic.menuWidth - view.frame.width
            
        }
        
        SideMenuController.preferences.basic.enableRubberEffectWhenPanning = false
        //SideMenuController.preferences.basic.enablePanGesture = false
        
        sideMenuController?.delegate = self as? SideMenuControllerDelegate
    }
    
    func setViewController() {
        //        sideMenuController?.cache(viewControllerGenerator: {
        //            self.storyboard?.instantiateViewController(withIdentifier: "DashboardNC")
        //        }, with: "0")
        //        sideMenuController?.cache(viewControllerGenerator: {
        //            self.storyboard?.instantiateViewController(withIdentifier: "RedeemJTicketNC")
        //        }, with: "1")
        //        sideMenuController?.cache(viewControllerGenerator: {
        //            self.storyboard?.instantiateViewController(withIdentifier: "PrivateModeNC")
        //        }, with: "2")
        //        sideMenuController?.cache(viewControllerGenerator: {
        //            self.storyboard?.instantiateViewController(withIdentifier: "WalletNC")
        //        }, with: "3")
        //        sideMenuController?.cache(viewControllerGenerator: {
        //            self.storyboard?.instantiateViewController(withIdentifier: "NotificationNC")
        //        }, with: "4")
        //        sideMenuController?.cache(viewControllerGenerator: {
        //            self.storyboard?.instantiateViewController(withIdentifier: "HistoryNC")
        //        }, with: "5")
        //        // Terms & Condition TermsAndConditionNC
        ////        sideMenuController?.cache(viewControllerGenerator: {
        ////            self.storyboard?.instantiateViewController(withIdentifier: "TermsAndConditionNC")
        ////        }, with: "5")
        ////        sideMenuController?.cache(viewControllerGenerator: {
        ////            self.storyboard?.instantiateViewController(withIdentifier: "PrivacyPolicyNC")
        ////        }, with: "6")
        //        sideMenuController?.cache(viewControllerGenerator: {
        //            self.storyboard?.instantiateViewController(withIdentifier: "TutorialNC")
        //        }, with: "6")
        //        sideMenuController?.cache(viewControllerGenerator: {
        //            self.storyboard?.instantiateViewController(withIdentifier: "AboutUsNC")
        //        }, with: "7")
        //        sideMenuController?.cache(viewControllerGenerator: {
        //            self.storyboard?.instantiateViewController(withIdentifier: "ResetPasswordNC")
        //        }, with: "8")
        //        sideMenuController?.cache(viewControllerGenerator: {
        //            self.storyboard?.instantiateViewController(withIdentifier: "SettingNC")
        //        }, with: "9")
        //
        //        sideMenuController?.cache(viewControllerGenerator: {
        //            self.storyboard?.instantiateViewController(withIdentifier: "CreateContestVC") as! CreateContestVC
        //        }, with: "Zero")
        //
        // deep for hidfing packages
        //        sideMenuController?.cache(viewControllerGenerator: {
        //            self.storyboard?.instantiateViewController(withIdentifier: "PackageNC")
        //        }, with: "One")
        
        
        //
        //        sideMenuController?.cache(viewControllerGenerator: {
        //            self.storyboard?.instantiateViewController(withIdentifier: "OrganizeNC")
        //
        //        }, with: "Two")
        //
        //        sideMenuController?.cache(viewControllerGenerator: {
        //            self.storyboard?.instantiateViewController(withIdentifier: "JoinByCodeNC")
        //        }, with: "Three")
        //
        
        
        
        //
        //            sideMenuController?.cache(viewControllerGenerator: {
        //                   self.storyboard?.instantiateViewController(withIdentifier: "OrganizeNC")
        //
        //               }, with: "One")
        //
        //              sideMenuController?.cache(viewControllerGenerator: {
        //                  self.storyboard?.instantiateViewController(withIdentifier: "JoinByCodeNC")
        //              }, with: "Two")
        
        
        
        
        sideMenuController?.cache(viewControllerGenerator: {
            self.storyboard?.instantiateViewController(withIdentifier: "DashboardNC")
        }, with: "0")
        
        sideMenuController?.cache(viewControllerGenerator: {
            self.storyboard?.instantiateViewController(withIdentifier: "IDsNC")
        }, with: "1")
        
        sideMenuController?.cache(viewControllerGenerator: {
            self.storyboard?.instantiateViewController(withIdentifier: "EasyJoinNC")
        }, with: "3")
        
        /*sideMenuController?.cache(viewControllerGenerator: {
            self.storyboard?.instantiateViewController(withIdentifier: "OrganizeNC")
        }, with: "4")*/
        
        /*sideMenuController?.cache(viewControllerGenerator: {
            self.storyboard?.instantiateViewController(withIdentifier: "HoroscopeNC")
        }, with: "5")*/
        
        sideMenuController?.cache(viewControllerGenerator: {
            self.storyboard?.instantiateViewController(withIdentifier: "WalletNC")
        }, with: "4")
        
        sideMenuController?.cache(viewControllerGenerator: {
            self.storyboard?.instantiateViewController(withIdentifier: "NotificationNC")
        }, with: "5")
        
        sideMenuController?.cache(viewControllerGenerator: {
            self.storyboard?.instantiateViewController(withIdentifier: "HistoryNC")
        }, with: "6")
        
//        sideMenuController?.cache(viewControllerGenerator: {
//            self.storyboard?.instantiateViewController(withIdentifier: "ReferralViewController")
//        }, with: "6")
        
        sideMenuController?.cache(viewControllerGenerator: {
            self.storyboard?.instantiateViewController(withIdentifier: "SettingNC")
        }, with: "7")
        
        sideMenuController?.cache(viewControllerGenerator: {
            self.storyboard?.instantiateViewController(withIdentifier: "TutorialNC")
        }, with: "8")
        
       /* sideMenuController?.cache(viewControllerGenerator: {
            self.storyboard?.instantiateViewController(withIdentifier: "AboutUsNC")
        }, with: "9")*/
        
        
        
        //               sideMenuController?.cache(viewControllerGenerator: {
        //                   self.storyboard?.instantiateViewController(withIdentifier: "TutorialNC")
        //               }, with: "5")
        
        sideMenuController?.cache(viewControllerGenerator: {
            self.storyboard?.instantiateViewController(withIdentifier: "CreateContestVC") as! CreateContestVC
        }, with: "Zero")
        
        //                sideMenuController?.cache(viewControllerGenerator: {
        //                       self.storyboard?.instantiateViewController(withIdentifier: "OrganizeNC")
        //
        //                   }, with: "One")
        
        sideMenuController?.cache(viewControllerGenerator: {
            self.storyboard?.instantiateViewController(withIdentifier: "JoinByCodeNC")
        }, with: "Two")
        
    }
    
    
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        let showPlaceTableOnLeft = (SideMenuController.preferences.basic.position == .under) != (SideMenuController.preferences.basic.direction == .right)
        constratinSideMenuTrailing.constant = showPlaceTableOnLeft ? SideMenuController.preferences.basic.menuWidth - size.width : 0
        view.layoutIfNeeded()
    }
    
    //MARK: - Button Method.
    @IBAction func buttonCamera(_ sender: Any) {
        let profileVC = self.storyboard?.instantiateViewController(withIdentifier: "ProfileNC")
        profileVC!.modalPresentationStyle = .fullScreen
        self.present(profileVC!, animated: true) {
            self.sideMenuController?.hideMenu()
        }
    }
    
    @IBAction func buttonLogout(_ sender: Any) {
        showLogoutAlert()
    }
}
//MARK: - TableView Delegate Method
extension SideMenuVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrSideMenu.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrSideMenu[section].isExpande {
            return arrSideMenu[section].arrSubMenu!.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "SideMenuHeaderTVC") as! SideMenuHeaderTVC
        
        headerCell.labelMenuTitle.text = arrSideMenu[section].menuTitle
        
        if section == 1 || section == 11 //|| section == 2
        {
            headerCell.imageMenuArrow.isHidden = false
        } else {
            headerCell.imageMenuArrow.isHidden = true
        }
        
        if selectedIndex == section {
            headerCell.viewSelected.backgroundColor = #colorLiteral(red: 0.9921568627, green: 0.7764705882, blue: 0.09803921569, alpha: 1)
            headerCell.labelMenuTitle.textColor = #colorLiteral(red: 0.1221796647, green: 0.3820681274, blue: 0.4405243397, alpha: 1)
            headerCell.imageMenuArrow.image = #imageLiteral(resourceName: "ic_down_arrow")
        } else {
            headerCell.viewSelected.backgroundColor = UIColor.clear
            headerCell.labelMenuTitle.textColor = UIColor.white
            headerCell.imageMenuArrow.image = #imageLiteral(resourceName: "ic_right_arrow-1")
        }
        
        headerCell.buttonMenu.addTarget(self,
                                        action: #selector(self.buttonHeaderClick(_:)),
                                        for: .touchUpInside)
        headerCell.buttonMenu.tag = section
        
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let menuCell = tableView.dequeueReusableCell(withIdentifier: "SideMenuTVC") as! SideMenuTVC
        if indexPath.section == 1 ||  indexPath.section == 2 || indexPath.section == 11{
            menuCell.labelMenuTitle.text = arrSideMenu[indexPath.section].arrSubMenu![indexPath.row]
        }
        
        return menuCell
    }
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 1 {
 
           if indexPath.row == 0 {
                let createVC = self.storyboard?.instantiateViewController(withIdentifier: "JticketlistingViewController")
                createVC!.modalPresentationStyle = .fullScreen
                self.navigationController?.present(createVC!, animated: true, completion: nil)
           } else if indexPath.row == 1  {
                let createVC = self.storyboard?.instantiateViewController(withIdentifier: "MyJticketViewController")
                createVC!.modalPresentationStyle = .fullScreen
                self.navigationController?.present(createVC!, animated: true, completion: nil)
            } else if indexPath.row == 2 {
                let createVC = self.storyboard?.instantiateViewController(withIdentifier: "JticketwaitinglistJViewController")
                createVC!.modalPresentationStyle = .fullScreen
                self.navigationController?.present(createVC!,animated: true, completion: nil)
            }
           else if indexPath.row == 3 {
                let createVC = self.storyboard?.instantiateViewController(withIdentifier: "AutomationViewController")
                createVC!.modalPresentationStyle = .fullScreen
                self.navigationController?.present(createVC!,animated: true, completion: nil)
            
//            sideMenuController?.cache(viewControllerGenerator: {
//                              self.storyboard?.instantiateViewController(withIdentifier: "AutomationNC")
//                          }, with: "6")
            }
            else if indexPath.row == 4 {
               let authStoryboard = UIStoryboard(name: "Authentication", bundle: nil)
             let vc = authStoryboard.instantiateViewController(withIdentifier: "T_CJTicketViewController") as! T_CJTicketViewController
                               vc.modalPresentationStyle = .fullScreen
                               self.present(vc, animated: true, completion: nil)
            }
        }
       /* else if indexPath.section == 2 {
               let authStoryboard = UIStoryboard(name: "Dashboard", bundle: nil)
               if indexPath.row == 0 {
                   let vc = authStoryboard.instantiateViewController(withIdentifier: "CreatePrivateGroupViewController") as! CreatePrivateGroupViewController
                  // vc.modalPresentationStyle = .fullScreen
                   self.present(vc, animated: true, completion: nil)
               } else if indexPath.row == 1 {
                   let vc = authStoryboard.instantiateViewController(withIdentifier: "JoinGroupVC") as! JoinGroupVC
                   vc.modalPresentationStyle = .fullScreen
                   self.present(vc, animated: true, completion: nil)
               } else if indexPath.row == 2 {
                   let vc = authStoryboard.instantiateViewController(withIdentifier: "MyPrivateGroupsVC") as! MyPrivateGroupsVC
                   vc.modalPresentationStyle = .fullScreen
                   self.present(vc, animated: true, completion: nil)
               }
            
           }*/
     else if indexPath.section == 11 {
            let authStoryboard = UIStoryboard(name: "Authentication", bundle: nil)
            if indexPath.row == 0 {
                let vc = authStoryboard.instantiateViewController(withIdentifier: "AboutUsVC") as! AboutUsVC
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            } else if indexPath.row == 1 {
                let vc = authStoryboard.instantiateViewController(withIdentifier: "TermsAndConditionVC") as! TermsAndConditionVC
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            } else if indexPath.row == 2 {
                let vc = authStoryboard.instantiateViewController(withIdentifier: "PrivacyPolicyVC") as! PrivacyPolicyVC
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            } else if indexPath.row == 3 {
                let vc = authStoryboard.instantiateViewController(withIdentifier: "PolicyVC") as! PolicyVC
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
        }
        
        sideMenuController?.hideMenu()
    }
    
    //MARK: -  TableView Header Button
    @objc func buttonHeaderClick(_ sender: UIButton) {
        let index = sender.tag
        if index == 1 {
            selectedIndex = index
           // arrSideMenu[1].isExpande = false
            arrSideMenu[2].isExpande = false
            arrSideMenu[11].isExpande = false
            arrSideMenu[index].isExpande = !arrSideMenu[index].isExpande
            setSideMenuHeight()
            tableMenu.reloadData()
        }
      /*  else if index == 2 {
            selectedIndex = index
            arrSideMenu[1].isExpande = false
        //    arrSideMenu[2].isExpande = false
            arrSideMenu[11].isExpande = false
            arrSideMenu[index].isExpande = !arrSideMenu[index].isExpande
            setSideMenuHeight()
            tableMenu.reloadData()
        }*/
        else if index == 11 {
            selectedIndex = index
            arrSideMenu[1].isExpande = false
            arrSideMenu[2].isExpande = false
           // arrSideMenu[11].isExpande = false
            arrSideMenu[index].isExpande = !arrSideMenu[index].isExpande
            setSideMenuHeight()
            tableMenu.reloadData()
        }
        else if index == 2 {
            let IDsVC = self.storyboard?.instantiateViewController(withIdentifier: "IDsVC") as! IDsVC
            IDsVC.modalPresentationStyle = .fullScreen
            self.present(IDsVC, animated: true){
                self.sideMenuController?.hideMenu()
            }
        }
        else if index == 3 {
            let EasyJoinVC = self.storyboard?.instantiateViewController(withIdentifier: "EasyJoinVC") as! EasyJoinVC
            EasyJoinVC.modalPresentationStyle = .fullScreen
            self.present(EasyJoinVC, animated: true){
                self.sideMenuController?.hideMenu()
            }
        }
        /*else if index == 5 {
            let IDsVC = self.storyboard?.instantiateViewController(withIdentifier: "HoroscopeVC") as! HoroscopeVC
            IDsVC.modalPresentationStyle = .fullScreen
            self.present(IDsVC, animated: true){
                self.sideMenuController?.hideMenu()
            }
        }*/
        else if index == 5 {
            let notificationVC = self.storyboard?.instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
            notificationVC.modalPresentationStyle = .fullScreen
            self.present(notificationVC, animated: true){
                self.sideMenuController?.hideMenu()
            }
        }
            //else if index == 7 {
//
//            let passwordVC = self.storyboard?.instantiateViewController(withIdentifier: "ResetPasswordNC")
//            passwordVC!.modalPresentationStyle = .fullScreen
//            self.present(passwordVC!, animated: true) {
//                self.sideMenuController?.hideMenu()
//            }
//
//        }
        else if index == 9 {
            
            let whatsappURL = URL(string: Define.whatsappapi)
            if UIApplication.shared.canOpenURL(whatsappURL!) {
                UIApplication.shared.open(whatsappURL!, options: [:], completionHandler: nil)
                }
            
            
        }
        else if index == 10 {
            
            let authStoryboard = UIStoryboard(name: "Authentication", bundle: nil)
            let vc = authStoryboard.instantiateViewController(withIdentifier: "FAQsVC") as! FAQsVC
           vc.modalPresentationStyle = .fullScreen
          self.present(vc, animated: true, completion: nil)
            
            
        }

            
//            else if index == 9 {
//
//                        let PackegaListVC = self.storyboard?.instantiateViewController(withIdentifier: "PackegaListVC") as! PackegaListVC
//                       PackegaListVC.modalPresentationStyle = .fullScreen
//                       self.present(PackegaListVC, animated: true, completion: nil)
//
//
//
//                   }
    //    else if index == arrSideMenu.count - 1 {
            // 12/16 deep
            
            
            
//            if let urlStr = NSURL(string: "https://cbitoriginal.com/") {
//                let objectsToShare = [urlStr]
//                let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
//
//                if UI_USER_INTERFACE_IDIOM() == .pad {
//                    if let popup = activityVC.popoverPresentationController {
//                        popup.sourceView = self.view
//                        popup.sourceRect = CGRect(x: self.view.frame.size.width / 2, y: self.view.frame.size.height / 4, width: 0, height: 0)
//                    }
//                }
//
//                self.present(activityVC, animated: true, completion: nil)
            
//       // }
//            let Referral = self.storyboard?.instantiateViewController(withIdentifier: "ReferralViewController") as! ReferralViewController
//            Referral.modalPresentationStyle = .fullScreen
//            present(Referral, animated: true) {
//                self.sideMenuController?.hideMenu()
            
            
//
//            let Referral = self.storyboard?.instantiateViewController(withIdentifier: "JticketlistingViewController") as! JticketlistingViewController
//            Referral.modalPresentationStyle = .fullScreen
//            present(Referral, animated: true) {
//                self.sideMenuController?.hideMenu()
         //   }
    //    }
          else {
            selectedIndex = index
            sideMenuController?.setContentViewController(with: "\(index)")
            sideMenuController?.hideMenu()
        }
        tableMenu.reloadData()
    }
}
//MARK: - Set Profile

extension SideMenuVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func chooseOption() {
        let alertControllser = UIAlertController(title: "Select Option",
                                                 message: nil,
                                                 preferredStyle: .actionSheet)
        let galary = UIAlertAction(title: "Photos",
                                   style: .default)
        { _ in
            self.gatPhotoFromGalary()
        }
        let camera = UIAlertAction(title: "Take Photo",
                                   style: .default)
        { _ in
            self.takePhotoFromCamera()
        }
        let cancel = UIAlertAction(title: "Cancel",
                                   style: .cancel,
                                   handler: nil)
        alertControllser.addAction(galary)
        alertControllser.addAction(camera)
        alertControllser.addAction(cancel)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            alertControllser.popoverPresentationController?.sourceView = self.view
            alertControllser.popoverPresentationController?.sourceRect = self.imageProfile.bounds
        }
        present(alertControllser, animated: true, completion: nil)
    }
    
    func gatPhotoFromGalary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .photoLibrary
            present(imagePicker, animated: true, completion: nil)
        } else {
            Alert().showTost(message: "Photo Library Not Found", viewController: self)
        }
    }
    
    func takePhotoFromCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .camera
            present(imagePicker, animated: true, completion: nil)
        } else {
            Alert().showTost(message: "Camera Not Found", viewController: self)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let chhosenImage = info[.editedImage] as! UIImage
        
        imageProfile.image = chhosenImage
        
        setProfileImage()
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
//MARK: - API
extension SideMenuVC {
    func setProfileImage() {
        Loading().showLoading(viewController: self)
        let strURL = Define.APP_URL + Define.API_UPLOAD_PROFILE_IMAGE
        print("URL: \(strURL)")
        let imageData = imageProfile.image!.jpegData(compressionQuality: 0.8)
        
        SwiftAPI().postImageUplodSecure(stringURL: strURL,
                                  parameters: nil,
                                  header: Define.USERDEFAULT.value(forKey: "AccessToken") as? String,
                                  auther: Define.USERDEFAULT.value(forKey: "UserID") as? String,
                                  imageName: "profile_image",
                                  imageData: imageData)
        { (result, error) in
            if error != nil {
                Loading().hideLoading(viewController: self)
                print("Error: \(error!)")
                Alert().showAlert(title: "Error",
                                  message: Define.ERROR_SERVER,
                                  viewController: self)
            } else {
                Loading().hideLoading(viewController: self)
                print("Result: \(result!)")
                let status = result!["statusCode"] as? Int ?? 0
                if status == 200 {
                    let dictData = result!["content"] as! [String: Any]
                    Define.USERDEFAULT.set(dictData["profile_image"]!, forKey: "ProfileImage")
                } else if status == 401 {
                    MyModel().removeUserData()
                    self.dismiss(animated: true, completion: nil)
                } else {
                    Alert().showAlert(title: "Error",
                                      message: result!["message"] as? String ?? Define.ERROR_SERVER,
                                      viewController: self)
                }
            }
        }
    }
    
    func setData() {
        Loading().showLoading(viewController: self)
        let strURL = Define.APP_URL + Define.API_ALLJTICKETDATAS
        print("URL: \(strURL)")
        let imageData = imageProfile.image!.jpegData(compressionQuality: 0.8)
        
        SwiftAPI().postImageUplodSecure(stringURL: strURL,
                                  parameters: nil,
                                  header: Define.USERDEFAULT.value(forKey: "AccessToken") as? String,
                                  auther: Define.USERDEFAULT.value(forKey: "UserID") as? String,
                                  imageName: "profile_image",
                                  imageData: imageData)
        { (result, error) in
            if error != nil {
                Loading().hideLoading(viewController: self)
                print("Error: \(error!)")
                Alert().showAlert(title: "Error",
                                  message: Define.ERROR_SERVER,
                                  viewController: self)
            } else {
                Loading().hideLoading(viewController: self)
                print("Result: \(result!)")
                let status = result!["statusCode"] as? Int ?? 0
                if status == 200 {
                    let dictData = result!["content"] as! [String: Any]
                    
                    let imageURL = URL(string:dictData["referral_image"] as! String)
                    self.imageProfile.sd_setImage(with: imageURL,placeholderImage: Define.PLACEHOLDER_PROFILE_SIDE_IMAGE)
                    
                    self.adp = dictData["ADP"]! as? String ?? "0.0"
                    self.efm = "\(dictData["TotalEntry"]! as! Int)"
                    self.em = "\(dictData["TotalEarning"]! as! Double)"
                    self.cc = dictData["BAP"]! as? String ?? "0.0"
                    self.DayOfJoin = String(dictData["DayOfJoin"]! as? Int ?? 0)
                    
                    let formatter = NumberFormatter()              // Cache this, NumberFormatter creation is expensive.
                    formatter.locale = Locale(identifier: "en_IN") // Here indian locale with english language is used
                    formatter.numberStyle = .decimal               // Change to `.currency` if needed

                     
                    
                    
                    //let asd = formatter.string(for: <#T##Any?#>)
                    
                    
//                    self.lblapd.text = "₹\(String(describing: formatter.string(from: NSNumber(value: Double(adp)!))!))"
//                    self.lblefm.text = "₹\(String(describing: formatter.string(from: NSNumber(value: efm))!))"
//                    self.lblem.text = "₹\(String(describing: formatter.string(from: NSNumber(value: em))!))"
//                    self.lblbap.text = "CC \(String(describing: formatter.string(from: NSNumber(value: Double(cc)!))!))"
                    
                    self.lblapd.text = "₹\(Double(self.adp)?.shorted() ?? "0")"
                    self.lblefm.text = "₹\(Double(self.efm)?.shorted() ?? "0" )"
                    self.lblem.text = "₹\(Double(self.em)?.shorted() ?? "0" )"
                    self.lblbap.text = "CC \(Double(self.cc)?.shorted() ?? "0")"
                    
                } else if status == 401 {
                   
                    self.dismiss(animated: true, completion: nil)
                } else {
                    Alert().showAlert(title: "Error",
                                      message: result!["message"] as? String ?? Define.ERROR_SERVER,
                                      viewController: self)
                }
            }
        }
    }
    
    func logOutAPI() {
        Loading().showLoading(viewController: self)
        let strURL = Define.APP_URL + Define.API_LOGOUT
        print("URL: \(strURL)")
        
        SwiftAPI().postMethodSecure(stringURL: strURL,
                                    parameters: nil,
                                    header: Define.USERDEFAULT.value(forKey: "AccessToken") as? String,
                                    auther: Define.USERDEFAULT.value(forKey: "UserID") as? String)
        { (result, error) in
            if error != nil {
                Loading().hideLoading(viewController: self)
                print("Error: \(error!.localizedDescription)")
                Alert().showAlert(title: "Error",
                                  message: Define.ERROR_SERVER,
                                  viewController: self)
            } else {
                Loading().hideLoading(viewController: self)
                print("Result: \(result!)")
                let status = result!["statusCode"] as? Int ?? 0
                if status == 200 {
                    Define.APPDELEGATE.handleLogout()
                } else {
                    Alert().showAlert(title: "Error",
                                      message: result!["message"] as? String ?? Define.ERROR_SERVER,
                                      viewController: self)
                }
            }
        }
    }
}

//MARK: - ALERT LOGOUT
extension SideMenuVC {
    func showLogoutAlert() {
        let alertController = UIAlertController(title: "Logout",
                                               message: "Are you sure want to logout?",
                                               preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel",
                                   style: .cancel,
                                   handler: nil)
        let logout = UIAlertAction(title: "Logout",
                                   style: .default) { _ in
                                    self.logOutAPI()
        }
        
        alertController.addAction(cancel)
        alertController.addAction(logout)
        self.present(alertController,
                     animated: true,
                     completion: nil)
    }
}

//MARK: - Cell Class
class SideMenuTVC: UITableViewCell {
    
    @IBOutlet weak var viewSelected: UIView!
    @IBOutlet weak var labelMenuTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewSelected.layer.cornerRadius = viewSelected.frame.height / 2
        viewSelected.layer.masksToBounds = true
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
    }
}

class SideMenuHeaderTVC: UITableViewCell {
    @IBOutlet weak var viewSelected: UIView!
    @IBOutlet weak var labelMenuTitle: UILabel!
    @IBOutlet weak var buttonMenu: UIButton!
    @IBOutlet weak var imageMenuArrow: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewSelected.layer.cornerRadius = viewSelected.frame.height / 2
        viewSelected.layer.masksToBounds = true
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
    }
}

extension Int {
    func withCommas() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value:self))!
    }
}

extension Double {
     func shorted() -> String {
        if self >= 1000 && self < 10000 {
             return String(format: "%.1fK", Double(self/100)/10).replacingOccurrences(of: ".0", with: "")
         }

         if self >= 10000 && self < 100000 {
            return String(format: "%.1fK", Double(self/1000)).replacingOccurrences(of: ".0", with: "")
          //   return "\(self/1000)k"
         }

         if self >= 100000 && self < 1000000 {
             return String(format: "%.1fL", Double(self/10000)/10).replacingOccurrences(of: ".0", with: "")
         }

         if self >= 1000000 && self < 10000000 {
             return String(format: "%.1fM", Double(self/100000)/10).replacingOccurrences(of: ".0", with: "")
         }

         if self >= 10000000 {
             return "\(self/1000000)M"
         }

         return String(self)
    }
  //  var shortStringRepresentation: String {
        
        
 
        
        
//        if self.isNaN {
//            return "NaN"
//        }
//        if self.isInfinite {
//            return "\(self < 0.0 ? "-" : "+")Infinity"
//        }
//        let units = ["", "k", "M"]
//        var interval = self
//        var i = 0
//        while i < units.count - 1 {
//            if abs(interval) < 1000.0 {
//                break
//            }
//            i += 1
//            interval /= 1000.0
//        }
//        // + 2 to have one digit after the comma, + 1 to not have any.
//        // Remove the * and the number of digits argument to display all the digits after the comma.
//        return "\(String(format: "%0.*g", Int(log10(abs(interval))) + 2, interval))\(units[i])"
 //   }
}


struct Number {
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
      //  formatter.groupingSeparator = " " // or possibly "." / ","
        formatter.numberStyle = .decimal
        return formatter
    }()
}
extension Double {
    var stringWithSepator: String {
        return Number.withSeparator.string(from: NSNumber(value: hashValue)) ?? ""
    }
}

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
class SideMenuVC: UIViewController {
    //MARK: - Propertires
    @IBOutlet weak var viewProfile: UIView!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var tableMenu: UITableView!
    @IBOutlet weak var labelUserName: UILabel!
    
    
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
        SideMenu(title: "Dashboard", subMenus: nil, isExpand: false),
        SideMenu(title: "J Magic ", subMenus: [
            "Redeem J Tickets",
            "My J Tickets",
            "Waiting Room",
            "Automation",
            "T & C"
            ], isExpand: false),
         SideMenu(title: "PACKAGES", subMenus: nil, isExpand: false),
        SideMenu(title: "Wallet", subMenus: nil, isExpand: false),
        SideMenu(title: "Notification", subMenus: nil, isExpand: false),
        SideMenu(title: "History", subMenus: nil, isExpand: false),
        SideMenu(title: "Invite Friends", subMenus: nil, isExpand: false),
        SideMenu(title: "Settings", subMenus: nil, isExpand: false),
  //      SideMenu(title: "PACKAGES", subMenus: nil, isExpand: false),
        //SideMenu(title: "TERMS & CONDITION", subMenus: nil, isExpand: false),
        //SideMenu(title: "LEGALITY", subMenus: nil, isExpand: false),
        
    SideMenu(title: "How to Play", subMenus: nil, isExpand: false),
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        labelUserName.text = Define.USERDEFAULT.value(forKey: "UserName") as? String ?? "No Name"
        
        let imageURL = URL(string: Define.USERDEFAULT.value(forKey: "ProfileImage") as? String ?? "")
        imageProfile.sd_setImage(with: imageURL,
                                 placeholderImage: Define.PLACEHOLDER_PROFILE_SIDE_IMAGE)
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
        }   else if arrSideMenu[9].isExpande {
            constraintTableHeight.constant = CGFloat((60 * arrSideMenu.count) + (arrSideMenu[9].arrSubMenu!.count * 60))
        } else {
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
                 self.storyboard?.instantiateViewController(withIdentifier: "RedeemJTicketNC")
             }, with: "1")
        sideMenuController?.cache(viewControllerGenerator: {
                self.storyboard?.instantiateViewController(withIdentifier: "OrganizeNC")
            }, with: "2")
        sideMenuController?.cache(viewControllerGenerator: {
                        self.storyboard?.instantiateViewController(withIdentifier: "WalletNC")
                    }, with: "3")
             sideMenuController?.cache(viewControllerGenerator: {
                 self.storyboard?.instantiateViewController(withIdentifier: "NotificationNC")
             }, with: "4")
             sideMenuController?.cache(viewControllerGenerator: {
                 self.storyboard?.instantiateViewController(withIdentifier: "HistoryNC")
             }, with: "5")
        sideMenuController?.cache(viewControllerGenerator: {
                          self.storyboard?.instantiateViewController(withIdentifier: "ReferralViewController")
                      }, with: "6")
        sideMenuController?.cache(viewControllerGenerator: {
            self.storyboard?.instantiateViewController(withIdentifier: "SettingNC")
        }, with: "7")
       sideMenuController?.cache(viewControllerGenerator: {
                 self.storyboard?.instantiateViewController(withIdentifier: "TutorialNC")
               }, with: "8")
      
               sideMenuController?.cache(viewControllerGenerator: {
                   self.storyboard?.instantiateViewController(withIdentifier: "AboutUsNC")
               }, with: "9")
              
               
        
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
        
        if section == 1 || section == 9 {
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
        if indexPath.section == 1 ||  indexPath.section == 9 {
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
     else if indexPath.section == 9 {
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
            arrSideMenu[2].isExpande = false
            arrSideMenu[index].isExpande = !arrSideMenu[index].isExpande
            setSideMenuHeight()
            tableMenu.reloadData()
        }
        else if index == 9 {
            selectedIndex = index
            arrSideMenu[2].isExpande = false
            arrSideMenu[index].isExpande = !arrSideMenu[index].isExpande
            setSideMenuHeight()
            tableMenu.reloadData()
        } else if index == 3 {
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
        else if index == 8 {
            
            let authStoryboard = UIStoryboard(name: "Authentication", bundle: nil)
            let vc = authStoryboard.instantiateViewController(withIdentifier: "FAQsVC") as! FAQsVC
           vc.modalPresentationStyle = .fullScreen
          self.present(vc, animated: true, completion: nil)
            
            
        }
            
//            else if index == 10 {
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


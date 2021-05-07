import UIKit
import SDWebImage

public protocol ProfileDelegate {
    func backButtonFire()
}
class ProfileVC: UIViewController {
    //MARK: - Properties
    @IBOutlet weak var imageProfile: ImageViewProfile!
    @IBOutlet weak var tableBanks: UITableView!
    @IBOutlet weak var labelUserName: UILabel!
    @IBOutlet weak var labelFullName: UILabel!
    @IBOutlet weak var labelEmailAddress: UILabel!
    @IBOutlet weak var imageIsEmailValid: UIImageView!
    @IBOutlet weak var labelIsEmailValid: UILabel!
    @IBOutlet weak var labelMobileNumber: UILabel!
    @IBOutlet weak var labelPanNumber: UILabel!
    @IBOutlet weak var imagePanVerification: UIImageView!
    @IBOutlet weak var buttonEdit: UIButton!
    @IBOutlet weak var labelPanCardStatus: UILabel!
    
    @IBOutlet weak var constrainTableViewHeight: NSLayoutConstraint!
    
    var dictProfileData = [String: Any]()
    var arrBanks = [[String: Any]]()
    
    var selectedImage: UIImage?
    var delegate: ProfileDelegate?
    
    //MARK: - Default Method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableBanks.rowHeight = 80
        tableBanks.sectionFooterHeight = 50
        
        getProfileDetails()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: - Set Data
    func setData() {
        labelUserName.text = dictProfileData["userName"] as? String ?? "User Name"
        labelFullName.text = "\(dictProfileData["firstName"] as? String ?? "") \(dictProfileData["middelName"] as? String ?? "") \(dictProfileData["lastName"] as? String ?? "")"
        labelEmailAddress.text = dictProfileData["email"] as? String ?? "Email Address"
        labelMobileNumber.text = dictProfileData["mobile_no"] as? String ?? "MobileNumber"
        let panNumber = dictProfileData["pan_number"] as? String ?? "Pan Number"
        
        let isEmailVerify = dictProfileData["verify_email"] as? Bool ?? false
        Define.USERDEFAULT.set(isEmailVerify, forKey: "IsEmailVerify")
        if isEmailVerify {
            imageIsEmailValid.isHidden = false
            labelIsEmailValid.text = nil
            labelIsEmailValid.isHidden = true
        } else {
            imageIsEmailValid.isHidden = true
            labelIsEmailValid.text = "Email address verification pending."
            labelIsEmailValid.textColor = UIColor.red
            labelIsEmailValid.isHidden = false
        }
        
        if panNumber.isEmpty {
            labelPanNumber.text = "XXXXXXXXXX"
        } else {
            labelPanNumber.text = panNumber
        }
        
        
        
        let imageURL = URL(string: "\(dictProfileData["referral_image"] as? String ?? "")")
        imageProfile.sd_setImage(with: imageURL, placeholderImage: Define.PLACEHOLDER_PROFILE_IMAGE)
        
        arrBanks = dictProfileData["bank_account"] as! [[String: Any]]
        
        let strIsPanVerify = "\(dictProfileData["verify_pan"]!)"
        if strIsPanVerify == "0" {
            
            buttonEdit.isHidden = false
            imagePanVerification.isHidden = true
            labelPanCardStatus.isHidden = true
            labelPanCardStatus.isHidden = true
            labelPanCardStatus.text = nil
            labelPanCardStatus.textColor = UIColor.red
            
        } else if strIsPanVerify == "2" {
            
            buttonEdit.isHidden = false
            imagePanVerification.isHidden = true
            labelPanCardStatus.isHidden = false
            labelPanCardStatus.text = "KYC Verification Rejected"
            labelPanCardStatus.textColor = UIColor.red
            
        } else if strIsPanVerify == "3" {
            
            buttonEdit.isHidden = true
            imagePanVerification.isHidden = true
            labelPanCardStatus.isHidden = false
            labelPanCardStatus.text = "KYC Verification Pending."
            labelPanCardStatus.textColor = UIColor.red
            
        } else if strIsPanVerify == "1" {
            
            buttonEdit.isHidden = true
            imagePanVerification.isHidden = false
            labelPanCardStatus.isHidden = true
        }
        
        setBanks()
    }
    func setBanks() {
        tableBanks.reloadData()
        
        constrainTableViewHeight.constant = CGFloat((Float(arrBanks.count) * 80.0) + 50.0)
    }
    
    //MARK: - Button Mehtod
    @IBAction func buttonBack(_ sender: UIButton) {
        self.delegate?.backButtonFire()
        self.dismiss(animated: true)
    }
    @IBAction func buttonCamera(_ sender: Any) {
        chooseOption()
    }
    @IBAction func buttonEdit(_ sender: Any) {
        
    }
    
    @IBAction func buttonEditPanCard(_ sender: Any) {
        let srotyboard = UIStoryboard(name: "Authentication", bundle: nil)
        let panVC = srotyboard.instantiateViewController(withIdentifier: "KYCVerifycationVC") as! KYCVerifycationVC
        panVC.isFromWallet = true
        panVC.delegate = self
        self.navigationController?.pushViewController(panVC, animated: true)
    }
}

//MARK: - KYC Delegate Method
extension ProfileVC: KYCVerifycationDelegate {
    func processAdded() {
//        Alert().showAlert(title: "CBit",
//                          message: "Your PAN card added successfully, Wail for the verification.",
//                          viewController: self)
        getProfileDetails()
    }
    
}

//MARK: - Set Profile
extension ProfileVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
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
            alertControllser.popoverPresentationController?.sourceView = self.imageProfile
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
        selectedImage = chhosenImage
        
        setProfileImage()
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

//MARK: - API
extension ProfileVC {
    func getProfileDetails() {
        Loading().showLoading(viewController: self)
        let strURL = Define.APP_URL + Define.API_PROFILE
        print("URL: \(strURL)")
        
        SwiftAPI().postMethodSecure(stringURL: strURL,
                                    parameters: nil,
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
                    
                    self.dictProfileData = result!["content"] as! [String: Any]
                    self.setData()
                } else if status == 401 {
                    Define.APPDELEGATE.handleLogout()
                } else {
                    Alert().showAlert(title: "Error",
                                      message: result!["message"] as? String ?? Define.ERROR_SERVER,
                                      viewController: self)
                }
            }
        }
    }
    
    func setProfileImage() {
        Loading().showLoading(viewController: self)
        let strURL = Define.APP_URL + Define.API_UPLOAD_PROFILE_IMAGE
        print("URL: \(strURL)")
        let imageData = selectedImage!.jpegData(compressionQuality: 0.8)
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
                } else {
                    Alert().showAlert(title: "Error",
                                      message: result!["message"] as? String ?? Define.ERROR_SERVER,
                                      viewController: self)
                }
            }
        }
    }
    
    func deleteBankAPI(strBankID: String) {
        Loading().showLoading(viewController: self)
        let parameter: [String: Any] = [
            "bank_id": strBankID
        ]
        let strURL = Define.APP_URL + Define.API_DELETE_BANK
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
                Alert().showAlert(title: "Error",
                                  message: Define.ERROR_SERVER,
                                  viewController: self)
            } else {
                Loading().hideLoading(viewController: self)
                print("Result: \(result!)")
                let status = result!["statusCode"] as? Int ?? 0
                if status == 200 {
                    self.arrBanks = result!["content"] as! [[String: Any]]
                    self.setBanks()
                } else {
                    Alert().showAlert(title: "Alert",
                                      message: result!["message"] as? String ?? "",
                                      viewController: self)
                }
            }
        }
    }
}

//MARK: - TableView Delegate Method
extension ProfileVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrBanks.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let bankCell = tableView.dequeueReusableCell(withIdentifier: "BankTVC") as! BankTVC
        
        bankCell.labelBankName.text = arrBanks[indexPath.row]["bank_name"] as? String
        bankCell.labelAccountNumber.text = arrBanks[indexPath.row]["account_no"] as? String
        bankCell.labelIFSCCode.text = arrBanks[indexPath.row]["ifsc_code"] as? String
        
        return bankCell
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerCell = tableView.dequeueReusableCell(withIdentifier: "AddBankFooterView") as! AddBankFooterView
        
        if arrBanks.count < 1 {
            footerCell.buttonAddAcount.setTitle("Link Bank Account",
                                                for: .normal)
        } else {
            footerCell.buttonAddAcount.setTitle("Add Another Account",
                                                for: .normal)
        }
        footerCell.buttonAddAcount.addTarget(self,
                                             action: #selector(buttonAddAccount(_:)),
                                             for: .touchUpInside)
        footerCell.buttonAddAcount.tag = section
        return footerCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //let strBankId = "\(arrBanks[indexPath.row]["bank_id"]!)"
        //showDeleteAlert(strBankId: "\(strBankId)")
    }
    
    //MARK: - TableView Button Method
    @objc func buttonAddAccount(_ sender: UIButton) {
        let addVC = self.storyboard?.instantiateViewController(withIdentifier: "LinkBankAccountVC") as! LinkBankAccountVC
        addVC.delegate = self
        self.navigationController?.pushViewController(addVC, animated: true)
    }
}

//MARK: - Link Account Delegate Method
extension ProfileVC: LinkBankAccountDelegate {
    func bankAccountAdded() {
        getProfileDetails()
    }
}

//MARK: - Alert Controller
extension ProfileVC {
    func showDeleteAlert(strBankId: String) {
        let alertController = UIAlertController(title: "Delete Account",
                                                message: "Are you sure want to delete this account?",
                                                preferredStyle: .alert)
        let cancelOption = UIAlertAction(title: "Cancel",
                                         style: .cancel, handler: nil)
        let deleteOption = UIAlertAction(title: "Delete",
                                         style: .default) { action in
                                            self.deleteBankAPI(strBankID: strBankId)
        }
        alertController.addAction(cancelOption)
        alertController.addAction(deleteOption)
        
        present(alertController,
                animated: true,
                completion: nil)
    }
}

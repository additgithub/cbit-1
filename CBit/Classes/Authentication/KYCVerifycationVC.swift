import UIKit
import IGRPhotoTweaks
import ActionSheetPicker_3_0

public protocol KYCVerifycationDelegate {
    func processAdded()
}

class KYCVerifycationVC: UIViewController {
    //MARK: - Properties
    @IBOutlet weak var imagePanCard: UIImageView!
    @IBOutlet weak var labelPanCard: UILabel!
    @IBOutlet weak var imageCamera: UIImageView!
    @IBOutlet weak var textName: UITextField!
    @IBOutlet weak var textPanCardNumber: UITextField!
    @IBOutlet weak var textDateOfBirth: UITextField!
    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var buttonSkip: UIButton!
    @IBOutlet weak var labelSkip: UILabel!
    @IBOutlet weak var buttonSubmit: UIButton!
    
    private var datePicker: DatePickerDialog?
    private var selectedDate = Date()
    
    var isFromWallet = Bool()
    var delegate: KYCVerifycationDelegate?
    
    lazy var imageTapper: UITapGestureRecognizer = {
        let imageTapper = UITapGestureRecognizer()
        imageTapper.numberOfTapsRequired = 1
        imageTapper.addTarget(self,
                              action: #selector(handleImageTapper(_:)))
        return imageTapper
    }()
    
    //MARK: - Default Method
    override func viewDidLoad() {
        super.viewDidLoad()
        setDatePicker()
        imagePanCard.addGestureRecognizer(imageTapper)
        
        if isFromWallet {
            buttonBack.isHidden = false
            buttonSkip.isHidden = true
            labelSkip.isHidden = true
        } else {
            buttonBack.isHidden = true
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        MyModel().roundCorners(corners: [.allCorners],
                               radius: 10,
                               view: imagePanCard)
        MyModel().setShadow(view: buttonSubmit)
    }
    
    //MARK: - Gesture Method
    @objc func handleImageTapper(_ tapper: UITapGestureRecognizer) {
        chooseOption()
    }
    
    private func setDatePicker() {
        datePicker = DatePickerDialog(textColor: Define.MAINVIEWCOLOR,
                                      buttonColor: Define.MAINVIEWCOLOR,
                                      font: UIFont(name: "Ubuntu-Medium", size: 14)!,
                                      locale: nil,
                                      showCancelButton: true)
    }
    
    //MARK: - BUtton Method
    @IBAction func buttonBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func buttonSkip(_ sender: UIButton) {
        SocketIOManager.sharedInstance.establisConnection()

                let storyBoard = UIStoryboard(name: "Dashboard", bundle: nil)
        let menuVC = storyBoard.instantiateViewController(withIdentifier: "TutorialNC")
        menuVC.modalPresentationStyle = .fullScreen
        self.present(menuVC,
                     animated: true, completion:
            {
                self.navigationController?.popToRootViewController(animated: true)
        })
        
//        let storyBoard = UIStoryboard(name: "Dashboard", bundle: nil)
//              let menuVC = storyBoard.instantiateViewController(withIdentifier: "MenuNC")
//              menuVC.modalPresentationStyle = .fullScreen
//              self.present(menuVC,
//                           animated: true, completion:
//                  {
//                      self.navigationController?.popToRootViewController(animated: true)
//              })
        
    }
    @IBAction func buttonSubmit(_ sender: Any) {
        if imagePanCard.image == nil {
            Alert().showAlert(title: "Alert",
                              message: "upload PAN Card",
                              viewController: self)
        } else if textName.text!.isEmpty {
            Alert().showAlert(title: "Alert",
                              message: "Enter Name As Per PAN Card.",
                              viewController: self)
        } else if textPanCardNumber.text!.isEmpty {
            Alert().showAlert(title: "Alert",
                              message: "Enter PAN Card Number.",
                              viewController: self)
        } else if textDateOfBirth.text!.isEmpty {
            Alert().showAlert(title: "Alert",
                              message: "Select Date Of Birth",
                              viewController: self)
        } else {
            updateKYCAPI()
        }
    }

    @IBAction func buttonDateOfBirth(_ sender: Any) {
        
                let calendar = Calendar(identifier: .gregorian)
                let currentDate = Date()
                var dateComponent = DateComponents()
                dateComponent.calendar = calendar
                dateComponent.year = -18
                let minimumDate = calendar.date(byAdding: dateComponent, to: currentDate)
        
        let datePicker = ActionSheetDatePicker(title: "Select Date",
                                               datePickerMode: UIDatePicker.Mode.date,
                                               
                                               selectedDate: Date(),
                                               doneBlock: { picker, date, origin in
                                                    print("picker = \(String(describing: picker))")
                                                    print("date = \(String(describing: date))")
                                                    print("origin = \(String(describing: origin))")
//                                                let dateFormater: DateFormatter = DateFormatter()
//                                                dateFormater.dateFormat = "dd-MM-yyyy"
//                                                let stringFromDate: String = dateFormater.string(from: date as! Date) as String
//                                                sender.setTitle(stringFromDate, for: .normal)
                                                
                                                if let selectedDate = date {
                                                    if (selectedDate as! Date) <= minimumDate! {
                                                                let dateFormater = DateFormatter()
                                                                dateFormater.dateFormat = "dd-MM-yyyy"
                                                        print("Date: ", dateFormater.string(from: selectedDate as! Date))
                                                        self.textDateOfBirth.text = dateFormater.string(from: selectedDate as! Date)
                                                        self.selectedDate = selectedDate as! Date
                                                            } else {
                                                                Alert().showAlert(title: "",
                                                                                  message: "You must be 18 years and above to play this game.",
                                                                                  viewController: self)
                                                            }
                                                        }
                                                
                                                    return
                                                },
                                               cancel: { picker in
                                                    return
                                               },
                                               origin: (sender as AnyObject).superview!.superview)
//        let secondsInWeek: TimeInterval = 7 * 24 * 60 * 60;
//        datePicker?.minimumDate = Date(timeInterval: -secondsInWeek, since: Date())
//        datePicker?.maximumDate = Date(timeInterval: secondsInWeek, since: Date())
        if #available(iOS 14.0, *) {
          //  datePicker?.datePickerStyle = .inline
        }
        datePicker?.maximumDate =  Date()
        datePicker?.show()
        
//        let calendar = Calendar(identifier: .gregorian)
//        let currentDate = Date()
//        var dateComponent = DateComponents()
//        dateComponent.calendar = calendar
//        dateComponent.year = -18
//        let minimumDate = calendar.date(byAdding: dateComponent, to: currentDate)
//
//        datePicker!.show("Select Date",
//                         doneButtonTitle: "Select",
//                         cancelButtonTitle: "Cancel",
//                         defaultDate: Date(),
//                         minimumDate: nil,
//                         maximumDate: Date(),
//                         datePickerMode: .date)
//        { (date) in
//            if let selectedDate = date {
//                if selectedDate <= minimumDate! {
//                    let dateFormater = DateFormatter()
//                    dateFormater.dateFormat = "dd-MM-yyyy"
//                    print("Date: ", dateFormater.string(from: selectedDate))
//                    self.textDateOfBirth.text = dateFormater.string(from: selectedDate)
//                    self.selectedDate = selectedDate
//                } else {
//                    Alert().showAlert(title: "CBit",
//                                      message: "You must be 18 years and above to play this game.",
//                                      viewController: self)
//                }
//            }
//        }
    }
}

//MARK: - API
extension KYCVerifycationVC {
    func  updateKYCAPI() {
        Loading().showLoading(viewController: self)
        let parameter: [String: Any] = [
            "pan_name": textName.text!,
            "pan_number": textPanCardNumber.text!,
            "dob": MyModel().convertDateToString(date: selectedDate, returnFormate: "yyyy-MM-dd")
        ]
        
        let strURL = Define.APP_URL + Define.API_UPDATE_KYC
        print("Parameter: \(parameter)\nURL: \(strURL)")
        
        let imageData = imagePanCard.image!.jpegData(compressionQuality: 0.8)
        
//        let jsonString = MyModel().getJSONString(object: parameter)
//        let encriptString = MyModel().encrypting(strData: jsonString!, strKey: Define.KEY)
//        let strbase64 = encriptString.toBase64()
        
        SwiftAPI().postImageUplodSecure(stringURL: strURL,
                                        parameters: parameter, //["data": strbase64!],
                                        header: Define.USERDEFAULT.value(forKey: "AccessToken") as? String,
                                        auther: Define.USERDEFAULT.value(forKey: "UserID") as? String,
                                        imageName: "pan_image",
                                        imageData: imageData)
        { (result, error) in
            if error != nil {
                Loading().hideLoading(viewController: self)
                print("Error: \(error!.localizedDescription)")
                self.updateKYCAPI()
            } else {
                Loading().hideLoading(viewController: self)
                print("Result: \(result!)")
                
                let status =  result!["statusCode"] as? Int ?? 0
                
                if status == 200 {
                    let dictData = result!["content"] as! [String: Any]
                    Define.USERDEFAULT.set(dictData["verify_pan"]!, forKey: "IsPanVerify")
                    
                    if self.isFromWallet {
                        self.navigationController?.popViewController(animated: true)
                        self.delegate?.processAdded()
                    } else {
                        SocketIOManager.sharedInstance.establisConnection()
                        let storyBoard = UIStoryboard(name: "Dashboard", bundle: nil)
                        let menuVC = storyBoard.instantiateViewController(withIdentifier: "TutorialNC")
                        menuVC.modalPresentationStyle = .fullScreen
                        self.present(menuVC,
                                     animated: true, completion:
                            {
                                self.navigationController?.popToRootViewController(animated: true)
                        })
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
}

//MARK: - Image Picker Method
extension KYCVerifycationVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func chooseOption() {
        let alertContoller = UIAlertController(title: "PAN Card",
                                               message: "Select Option",
                                               preferredStyle: .actionSheet)
        let photosAction = UIAlertAction(title: "Photos",
                                         style: .default) { action in
                                            self.photosOption()
        }
        let cameraAction = UIAlertAction(title: "Camera",
                                         style: .default) { action in
                                            self.cameraOption()
        }
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel,
                                         handler: nil)
        alertContoller.addAction(photosAction)
        alertContoller.addAction(cameraAction)
        alertContoller.addAction(cancelAction)
        
        if UI_USER_INTERFACE_IDIOM() == .pad {
            let popOverView = alertContoller.popoverPresentationController
            popOverView?.sourceView = imagePanCard
            popOverView?.sourceRect = imagePanCard.bounds
        }
        present(alertContoller,
                animated: true,
                completion: nil)
    }
    func cameraOption() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .camera
            imagePicker.delegate = self
            present(imagePicker, animated: true, completion: nil)
        } else {
            Alert().showAlert(title: "Alert",
                              message: "No Camera Availabel",
                              viewController: self)
        }
        
    }
    func photosOption() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            present(imagePicker, animated: true, completion: nil)
        } else {
            Alert().showAlert(title: "Alert",
                              message: "No Photos Availabel",
                              viewController: self)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let selectedImage = info[.originalImage] as! UIImage
        
        picker.dismiss(animated: false) {
            let imageCropVC = self.storyboard?.instantiateViewController(withIdentifier: "ImageCropVC") as! ImageCropVC
            imageCropVC.image = selectedImage
            imageCropVC.delegate = self
            self.navigationController?.pushViewController(imageCropVC, animated: true)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

//MARK: - Image Crop Delegate Method
extension KYCVerifycationVC: IGRPhotoTweakViewControllerDelegate {
    func photoTweaksController(_ controller: IGRPhotoTweakViewController,
                               didFinishWithCroppedImage croppedImage: UIImage) {
        
        controller.navigationController?.popViewController(animated: true)
        
        if imagePanCard.image == nil {
            labelPanCard.removeFromSuperview()
            imageCamera.removeFromSuperview()
        }
        
        imagePanCard.image = croppedImage
    }
    func photoTweaksControllerDidCancel(_ controller: IGRPhotoTweakViewController) {
        controller.navigationController?.popViewController(animated: true)
    }
}

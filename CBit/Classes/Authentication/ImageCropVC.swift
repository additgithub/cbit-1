import UIKit
import IGRPhotoTweaks

class ImageCropVC: IGRPhotoTweakViewController {
    //MARK: - Properties
    @IBOutlet weak var viewOption: UIView!
    
    //MARK: - Defualt Method
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCropView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        view.backgroundColor = UIColor.black
        
    }
    //MARK: - Set Method
    fileprivate func setUpCropView(){
        self.setCropAspectRect(aspect: "16:9")
        self.lockAspectRatio(false)
    }
    
    //MARK: - Button Method
    @IBAction func buttonCancel(_ sender: Any) {
        self.dismissAction()
    }
    @IBAction func buttonCrop(_ sender: Any) {
        self.cropAction()
    }
}

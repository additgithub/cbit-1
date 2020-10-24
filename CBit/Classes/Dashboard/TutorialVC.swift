import UIKit

class TutorialVC: UIViewController {
    //MARK: - Properties
    @IBOutlet weak var collectionViewTutorial: UICollectionView!
    @IBOutlet weak var buttonGotIt: ButtonWithBlueColor!
    @IBOutlet weak var buttonSkip: UIButton!
    
    var isFromeDashboard = Bool()
    
    var arrTutorialImages = [
        
        UIImage(named: "1.png"),
        UIImage(named: "2.png"),
        UIImage(named: "3.png"),
        UIImage(named: "4.png"),
        UIImage(named: "5.png"),
        UIImage(named: "6.png"),
        UIImage(named: "7.png"),
        UIImage(named: "8.png"),
        UIImage(named: "9.png"),
        UIImage(named: "10.png"),
        UIImage(named: "11.png"),
        UIImage(named: "12.png"),
        UIImage(named: "13.png"),
        UIImage(named: "14.png"),
        UIImage(named: "15.png"),
        UIImage(named: "16.png")
       
        
    ]
    
    var currentIndex = Int()
    
    
    //MARK: - Default Method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonSkip.isHidden = false
    }
    
    //MARK: - Button Method
    @IBAction func buttonSkip(_ sender: UIButton) {
        if isFromeDashboard {
            self.dismiss(animated: true, completion: nil)
        } else {
            let storyBoard = UIStoryboard(name: "Dashboard", bundle: nil)
            let menuVC = storyBoard.instantiateViewController(withIdentifier: "MenuNC")
            menuVC.modalPresentationStyle = .fullScreen
            self.present(menuVC,
                         animated: true, completion:
                {
                    self.navigationController?.popToRootViewController(animated: true)
            })
        }
    }
    
    @IBAction func buttonGotIt(_ sender: UIButton) {
        if isFromeDashboard {
            self.dismiss(animated: true, completion: nil)
        } else {
            let storyBoard = UIStoryboard(name: "Dashboard", bundle: nil)
            let menuVC = storyBoard.instantiateViewController(withIdentifier: "MenuNC")
            menuVC.modalPresentationStyle = .fullScreen
            self.present(menuVC,
                         animated: true, completion:
                {
                    self.navigationController?.popToRootViewController(animated: true)
            })
        }
    }
}
//MARK: - Collection View Delegate Method
extension TutorialVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrTutorialImages.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionViewTutorial.frame.width, height: self.collectionViewTutorial.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionViewTutorial.dequeueReusableCell(withReuseIdentifier: "TutorialCVC", for: indexPath) as! TutorialCVC
        cell.imageTutorial.image = arrTutorialImages[indexPath.row]
        
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = collectionViewTutorial.frame.width
        let currentPage = collectionViewTutorial.contentOffset.x / pageWidth
        
        if (0.0 != fmodf(Float(currentPage), 1.0))
        {
            currentIndex = Int(currentPage + 1);
        }
        else
        {
            currentIndex = Int(currentPage);
        }
        
        if currentIndex == (arrTutorialImages.count - 1) {
            self.buttonGotIt.isHidden = false
            self.buttonSkip.isHidden = true
        } else {
            self.buttonGotIt.isHidden = true
            self.buttonSkip.isHidden = false
        }
    }
}

//MARK: - Collection View Cell Class
class TutorialCVC: UICollectionViewCell {
    
    @IBOutlet weak var imageTutorial: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}

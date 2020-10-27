import UIKit
import Parchment

class OrganizeVC: UIViewController {
    
    @IBOutlet weak var labelTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setPageMenu()
    }
    
    func setPageMenu() {
        let myPackageVC = self.storyboard?.instantiateViewController(withIdentifier: "MyPackageVC") as! MyPackageVC
//        let organizeHistoryVC = self.storyboard?.instantiateViewController(withIdentifier: "OrganizeHistoryVC") as! OrganizeHistoryVC
         let PackegaListVC = self.storyboard?.instantiateViewController(withIdentifier: "PackegaListVC") as! PackegaListVC
        
        let pagingViewController = FixedPagingViewController(viewControllers: [
            PackegaListVC,
            myPackageVC]
        )
        
        pagingViewController.textColor = #colorLiteral(red: 0, green: 0, blue: 0.2666666667, alpha: 1)
        pagingViewController.selectedTextColor = #colorLiteral(red: 0.2666666667, green: 0.2666666667, blue: 0.2666666667, alpha: 1)
        pagingViewController.indicatorColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        pagingViewController.menuBackgroundColor = #colorLiteral(red: 0.9921568627, green: 0.7764705882, blue: 0.09803921569, alpha: 1)
        pagingViewController.font = UIFont(name: labelTitle.font.fontName, size: 13)!
        pagingViewController.selectedFont = UIFont(name: labelTitle.font.fontName, size: 15)!
        pagingViewController.menuItemSize = .fixed(width: view.frame.width / 2, height: 50)
        pagingViewController.indicatorOptions = .visible(height: 3,
                                                         zIndex: Int.max,
                                                         spacing: UIEdgeInsets.zero,
                                                         insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        pagingViewController.borderOptions = .visible(height: 0,
                                                      zIndex: 0,
                                                      insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        addChild(pagingViewController)
        view.addSubview(pagingViewController.view)
        pagingViewController.didMove(toParent: self)
        
        pagingViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pagingViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            pagingViewController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            pagingViewController.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            pagingViewController.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
            ])
    }
    
    //MARK: - Button Method
    @IBAction func buttonMenu(_ sender: Any) {
        sideMenuController?.revealMenu()
        //self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonHowToPLay(_ sender: Any) {
        let gameInfo = GamePlayInfo.instanceFromNib() as! GamePlayInfo
        gameInfo.frame = view.bounds
        view.addSubview(gameInfo)
    }
}

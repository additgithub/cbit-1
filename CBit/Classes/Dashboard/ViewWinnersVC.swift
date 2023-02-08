import UIKit
import UserNotifications

class ViewWinnersVC: UIViewController {
    //MARK: - Properties
    @IBOutlet weak var labelContestName: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelAmount: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var tableWinners: UITableView!
    @IBOutlet weak var viewNoData: UIView!
    @IBOutlet weak var viewBottom: UIView!
    
    var dictTicket = [String: Any]()
    var dictContest = [String: Any]()
    var startDate = Date()
    
    var Start = 0
    var Limit = 10
    var ismoredata = false
    var isfromanytime = false
    private var arrWinners = [[String: Any]]()
    
    //MARK: - Default Method
    override func viewDidLoad() {
        super.viewDidLoad()
        tableWinners.rowHeight = UITableView.automaticDimension
        tableWinners.tableFooterView = UIView()
       // UNUserNotificationCenter.current().delegate = self
        if !MyModel().isConnectedToInternet() {
            Alert().showTost(message: Define.ERROR_INTERNET,
                             viewController: self)
        } else {
            getWinnersAPI()
        }
        viewBottom.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        labelContestName.text = dictContest["name"] as? String ?? "No Name"
        labelDate.text = "Data: \(MyModel().convertDateToString(date: startDate, returnFormate: "dd-MM-yyyy"))"
        labelTime.text = "Time: \(MyModel().convertDateToString(date: startDate, returnFormate: "hh:mm a"))"
    }
    
    func setData() {
        if arrWinners.count > 0 {
            let dictData = arrWinners[0]
            labelAmount.text = "Winning amount ₹\(dictData["winAmount"]!)/Person"
        }
    }
    
    //MARK: - Button Method
    @IBAction func buttonBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

//MARK: - TableVeiw Delegate Method
extension ViewWinnersVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrWinners.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let winnerCell = tableView.dequeueReusableCell(withIdentifier: "ViewWinnersTVC") as! ViewWinnersTVC
        
        winnerCell.labelUserName.text = arrWinners[indexPath.row]["name"] as? String ?? "No Name"
        
        let img = self.loadImageFromDocumentDirectory(nameOfImage: arrWinners[indexPath.row]["ItemImage"] as? String ?? "")
        if isfromanytime {
            winnerCell.imgtick.isHidden = true
            winnerCell.lblslotselected.isHidden = true
        }
        else
        {
            if self.imageIsNullOrNot(imageName: img) {
                winnerCell.imgtick.image = img
                winnerCell.imgtick.isHidden = false
                winnerCell.lblslotselected.isHidden = true
            }
            else
            {
                winnerCell.imgtick.isHidden = true
                winnerCell.lblslotselected.isHidden = false
                winnerCell.lblslotselected.text = arrWinners[indexPath.row]["displayValue"] as? String ?? ""
            }
        }
        let game_type = arrWinners[indexPath.row]["game_type"] as! String
        if game_type == "spinning-machine" {
               
        }
        else
        {
            winnerCell.imgtick.isHidden = true
            winnerCell.lblslotselected.isHidden = true
           // winnerCell.lblslotselected.text = arrWinners[indexPath.row]["displayValue"] as? String ?? "No Slot Selected"
        }

        
          
        let winstatus  =  arrWinners[indexPath.row]["winStatus"] as? Int ?? 5
            print(winstatus)
        winnerCell.labelUserName.textColor = UIColor.red

//        if winstatus == 0 {
//            winnerCell.imgselected.isHidden = true
//        }
//        else
//        {
//            winnerCell.imgselected.isHidden = false
//        }
        
         if winstatus == 1
        {
             winnerCell.labelUserName.textColor = #colorLiteral(red: 0.4795994759, green: 0.7768470645, blue: 0.3392369151, alpha: 1)
            winnerCell.imgselected.image = UIImage(named: "winner")
            winnerCell.imgselected.tintColor = #colorLiteral(red: 0.4795994759, green: 0.7768470645, blue: 0.3392369151, alpha: 1)
        }
        else if winstatus == 2
        {
            winnerCell.imgselected.image = UIImage(named: "right")
            winnerCell.imgselected.tintColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
        }
        else //if winstatus == 3
        {
            winnerCell.imgselected.image = UIImage(named: "cross")
            winnerCell.imgselected.tintColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
        }
            
        winnerCell.labelTime.text = arrWinners[indexPath.row]["lockTime"] as? String ?? "00:00:00"
      
        
                    let imageURL = URL(string: arrWinners[indexPath.row]["referral_image"] as? String ?? "")
                    winnerCell.imageUser.sd_setImage(with: imageURL,placeholderImage: Define.PLACEHOLDER_PROFILE_IMAGE)
        
        if arrWinners.count > 1 {
            let lastElement = arrWinners.count - 1
            if indexPath.row == lastElement && ismoredata && arrWinners.count > Limit{
                //call get api for next page
                getWinnersAPI()
            }

        }

        
        return winnerCell
    }
    func imageIsNullOrNot(imageName : UIImage)-> Bool
    {

       let size = CGSize(width: 0, height: 0)
       if (imageName.size.width == size.width)
        {
            return false
        }
        else
        {
            return true
        }
    }
    func loadImageFromDocumentDirectory(nameOfImage : String) -> UIImage {
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        if let dirPath = paths.first{
            let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent(nameOfImage)
            let image    = UIImage(contentsOfFile: imageURL.path) ?? UIImage()
            return image
        }
        return UIImage.init(named: "default.png")!
    }
}

//MARK: - API
extension ViewWinnersVC {
    func getWinnersAPI() {
        Loading().showLoading(viewController: self)
        var parameter = [String: Any]()
        var strURL = String()
        if isfromanytime {
             strURL = Define.APP_URL + Define.API_ANYTIMEWINNER_LIST
            parameter = ["contestPriceId": dictTicket["contestPriceId"]!,"start": Start,"limit":Limit,"game_no":dictTicket["game_no"]!]
        }
        else
        {
             strURL = Define.APP_URL + Define.API_WINNER_LIST
            parameter = ["contestPriceId": dictTicket["contestPriceId"]!,"start": Start,"limit":Limit]
        }
        print("Parameter: \(parameter)\nURL: \(strURL)")
        
        let jsonString = MyModel().getJSONString(object: parameter)
        let encriptString = MyModel().encrypting(strData: jsonString!, strKey: Define.KEY)
        let strbase64 = encriptString.toBase64()
        
        SwiftAPI().postMethodSecure(stringURL: strURL,
                                    parameters: ["data":strbase64!],
                                    header: Define.USERDEFAULT.value(forKey: "AccessToken") as? String,
                                    auther: Define.USERDEFAULT.value(forKey: "UserID") as? String)
        { (result, error) in
            if error != nil {
                Loading().hideLoading(viewController: self)
                print("Error: \(error!)")
                //self.retry()
                self.getWinnersAPI()
            } else {
                Loading().hideLoading(viewController: self)
                print("Result: \(result!)")
                let status = result!["statusCode"] as? Int ?? 0
                if status == 200 {
                   // self.arrWinners = result!["content"] as! [[String: Any]]
                    
                    let arr =  result!["content"] as! [[String: Any]]
                      if arr.count > 0 {
                          self.arrWinners.append(contentsOf: arr)
                          self.ismoredata = true
                          self.Start = self.Start + self.Limit
                      }
                      else
                      {
                          self.ismoredata = false
                      }
                    
                    
                    self.tableWinners.reloadData()
                    if self.arrWinners.count > 0 {
                        self.viewNoData.isHidden = true
                        self.viewBottom.isHidden = false
                    } else {
                        self.viewNoData.isHidden = false
                        self.viewBottom.isHidden = true
                    }
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
}

//MARK: - Notifcation Delegate Method
//extension ViewWinnersVC: UNUserNotificationCenterDelegate {
//    func userNotificationCenter(_ center: UNUserNotificationCenter,
//                                willPresent notification: UNNotification,
//                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        completionHandler([.alert, .sound])
//    }
//    func userNotificationCenter(_ center: UNUserNotificationCenter,
//                                didReceive response: UNNotificationResponse,
//                                withCompletionHandler completionHandler: @escaping () -> Void) {
//        switch response.actionIdentifier {
//        case Define.PLAYGAME:
//            print("Play Game")
//            let dictData = response.notification.request.content.userInfo as! [String: Any]
//            print(dictData)
//            let gamePlayVC = self.storyboard?.instantiateViewController(withIdentifier: "GamePlayVC") as! GamePlayVC
//            gamePlayVC.isFromNotification = true
//            gamePlayVC.dictContest = dictData
//            self.navigationController?.pushViewController(gamePlayVC, animated: true)
//        default:
//            break
//        }
//        
//    }
//}

//MARK: - Alert Contollert
extension ViewWinnersVC {
    func retry() {
        let alertController = UIAlertController(title: Define.ERROR_TITLE,
                                                message: Define.ERROR_SERVER,
                                                preferredStyle: .alert)
        let buttonRetry = UIAlertAction(title: "Retry",
                                        style: .default)
        { _ in
            self.getWinnersAPI()
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

//MARK: - TableViewCell Class
class ViewWinnersTVC: UITableViewCell {
    @IBOutlet weak var imageUser: UIImageView!
    @IBOutlet weak var labelUserName: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    
    @IBOutlet weak var imgtick: UIImageView!
    @IBOutlet weak var lblslotselected: UILabel!
    @IBOutlet weak var imgselected: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}

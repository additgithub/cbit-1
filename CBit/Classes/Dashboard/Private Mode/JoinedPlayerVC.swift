import UIKit
import UserNotifications

class JoinedPlayerVC: UIViewController {
    //MARK: - Properties
    @IBOutlet weak var tableUserList: UITableView!
    @IBOutlet weak var labelContestName: UILabel!
    @IBOutlet weak var viewNoData: UIView!
    
    var dictContest = [String: Any]()
    
    var arrUsers = [[String: Any]]()
    
    //MARK: - Default Method
    override func viewDidLoad() {
        super.viewDidLoad()
        tableUserList.rowHeight = UITableView.automaticDimension
        tableUserList.tableFooterView = UIView()
      //  UNUserNotificationCenter.current().delegate = self
        
        if arrUsers.count == 0 {
            viewNoData.isHidden = false
        } else {
            viewNoData.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        labelContestName.text = dictContest["name"] as? String ?? "No Name"
    }
    
    //MARK: - Button Method
    @IBAction func buttonBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: - TableView Delegate Method
extension JoinedPlayerVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userCell = tableView.dequeueReusableCell(withIdentifier: "JoinedPlayerTVC") as! JoinedPlayerTVC
        
        let imageURL = URL(string: arrUsers[indexPath.row]["profile_image"] as? String ?? "")
        userCell.imageUser.sd_setImage(with: imageURL,
                                         placeholderImage: Define.PLACEHOLDER_PROFILE_SIDE_IMAGE)
        userCell.labelUserName.text = arrUsers[indexPath.row]["name"] as? String ?? "No name"
        
        return userCell
    }
}

//MARK: - Notifcation Delegate Method
//extension JoinedPlayerVC: UNUserNotificationCenterDelegate {
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

//MARK: - Cell Class
class JoinedPlayerTVC: UITableViewCell {
    
    @IBOutlet weak var imageUser: ImageViewProfile!
    @IBOutlet weak var labelUserName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}

import UIKit
import SDWebImage

class UserListVC: UIViewController {

    //MARK: - Properties
    @IBOutlet weak var labelContestName: UILabel!
    @IBOutlet weak var tableUserList: UITableView!
    @IBOutlet weak var viewNoData: UIView!
    
    var arrUserList = [[String: Any]]()
    var dictContestData = [String: Any]()
    var dictTicketData = [String: Any]()
    
    var isfromanytimegame = false
    
    
    //MARK: -  Default Method
    override func viewDidLoad() {
        super.viewDidLoad()
        print("--> Contest Data: \(dictContestData)")
        print("--> Ticket Data: \(dictTicketData)")
        
        tableUserList.rowHeight = UITableView.automaticDimension
        tableUserList.tableFooterView = UIView()
        
        getUserListVC()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        labelContestName.text = dictContestData["name"] as? String ?? "No Name"
    }
    
    //MARK: - Button Method
    @IBAction func buttonBack(_ sender: UIButton) {
        self
        .navigationController?.popViewController(animated: true)
    }
    
}

//MARK: - API
extension  UserListVC {
    func getUserListVC() {
        Loading().showLoading(viewController: self)
        var parameter = [String: Any]()
        if isfromanytimegame {
           parameter = [
               "contestPriceId": dictTicketData["contestPriceId"]!,
            "GameNo":dictTicketData["game_no"]!
           ]
        }
        else
        {
            parameter = [
                "contestPriceId": dictTicketData["contestPriceId"]!
            ]
        }
        
        
        let strURL = Define.APP_URL + Define.API_JOIN_USER_LIST
        print("Parameter: \(parameter)\nURL: \(strURL)")
        
        let jsonString = MyModel().getJSONString(object: parameter)
        let encriptString = MyModel().encrypting(strData: jsonString!, strKey: Define.KEY)
        let strbase64 = encriptString.toBase64()
        
        SwiftAPI().postMethodSecure(stringURL: strURL,
                                    parameters: ["data": strbase64!],
                                    header: Define.USERDEFAULT.value(forKey: "AccessToken") as? String,
                                    auther: Define.USERDEFAULT.value(forKey: "UserID") as? String)
        { (result, error) in
            if error != nil {
                Loading().hideLoading(viewController: self)
                print("Error: \(error!.localizedDescription)")
                self.getUserListVC()
            } else {
                Loading().hideLoading(viewController: self)
                print("Result: \(result!)")
                
                let status = result!["statusCode"] as? Int ?? 0
                if status == 200 {
                    self.arrUserList = result!["content"] as! [[String: Any]]
                    if self.arrUserList.count <= 0 {
                        self.viewNoData.isHidden = false
                    } else {
                        self.viewNoData.isHidden = true
                    }
                    self.tableUserList.reloadData()
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

//MARK: - TableView Delegate Method
extension UserListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrUserList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserListTVC") as! UserListTVC
        
        cell.labelUserName.text = arrUserList[indexPath.row]["name"] as? String ?? "No Name"
        
        let imageURL = URL(string: arrUserList[indexPath.row]["referral_image"] as? String ?? "")
        cell.imageUser.sd_setImage(with: imageURL,
                                   placeholderImage: Define.PLACEHOLDER_PROFILE_IMAGE)
        
        return cell
    }
}


//MARK: - Cell Class
class UserListTVC: UITableViewCell {
    
    @IBOutlet weak var imageUser: ImageViewProfile!
    @IBOutlet weak var labelUserName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
    }
}

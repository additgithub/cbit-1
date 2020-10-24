import UIKit

class PrivateModeVC: UIViewController {
    
    //MARK: - Properties
    @IBOutlet weak var tablePrivateMode: UITableView!
    
    private let arrPrivateMode = [
        "Host a contest",
        "Packages",
        "My contest & Packages",
        "Join By Code"
    ]
    
    //MARK: - Default Method
    override func viewDidLoad() {
        super.viewDidLoad()
        tablePrivateMode.rowHeight = 60
        tablePrivateMode.tableFooterView = UIView()
        
    }
    
    //MARK: - Button Method
    @IBAction func buttonBack(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

//MARK: - TableView Delgate Method
extension PrivateModeVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrPrivateMode.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PrivateModeTVC") as! PrivateModeTVC
        cell.labelMenuName.text = arrPrivateMode[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let createVC = self.storyboard?.instantiateViewController(withIdentifier: "CreateNC")
            createVC!.modalPresentationStyle = .fullScreen
            self.navigationController?.present(createVC!, animated: true, completion: nil)
        } else if indexPath.row == 1 {
            let packageVC = self.storyboard?.instantiateViewController(withIdentifier: "PackegaListVC") as! PackegaListVC
            self.navigationController?.pushViewController(packageVC, animated: true)
        } else if indexPath.row == 2 {
            let organizeVC = self.storyboard?.instantiateViewController(withIdentifier: "OrganizeVC") as! OrganizeVC
            self.navigationController?.pushViewController(organizeVC, animated: true)
        } else if indexPath.row == 3 {
            let joinVC  = self.storyboard?.instantiateViewController(withIdentifier: "JoinByCodeVC") as! JoinByCodeVC
            self.navigationController?.pushViewController(joinVC, animated: true)
        }
    }
}

//MARK: - TableView Cell Class
class PrivateModeTVC: UITableViewCell {
    
    @IBOutlet weak var labelMenuName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
    }
}

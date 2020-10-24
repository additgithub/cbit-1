import UIKit
import UserNotifications

class PrivateContestResultVC: UIViewController {

    @IBOutlet weak var collectionBracket: UICollectionView!
    @IBOutlet weak var labelTotalAmount: LabelComman!
    @IBOutlet weak var labelComission: UILabel!
    @IBOutlet weak var constraintColletionHeight: NSLayoutConstraint!
    @IBOutlet weak var labelContestName: UILabel!
    
    @IBOutlet weak var tableTickets: UITableView!
    
    var dictContest = [String: Any]()
    var arrBrackets = [[String: Any]]()
    var dictContestDetail = [String: Any]()
    var arrTickets = [[String: Any]]()
    
    
    var gamelevel = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableTickets.rowHeight = 50
        tableTickets.sectionHeaderHeight = 60
        tableTickets.tableFooterView = UIView()
        UNUserNotificationCenter.current().delegate = self
        arrBrackets = dictContestDetail["boxJson"] as! [[String: Any]]
        arrTickets = dictContestDetail["ticket"] as! [[String: Any]]
        
        gamelevel = dictContest["level"] as? Int ?? 1
        SetRandomNumber()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        labelContestName.text = dictContest["name"] as? String ?? "No Name"
        labelTotalAmount.text = "₹\(dictContestDetail["totalAmount"]!)"
        labelComission.text = "Your Commission ₹\(dictContestDetail["totalCommision"]!)"
    }
    
    func SetRandomNumber() {
        self.view.layoutIfNeeded()
        if gamelevel == 1 {
            constraintColletionHeight.constant = 50
        } else if gamelevel == 2 {
            constraintColletionHeight.constant = 100
        } else if gamelevel == 3 {
            constraintColletionHeight.constant = 200
        }
        self.view.layoutIfNeeded()
    }
    
    //MARK: - Button Method
    @IBAction func buttonBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

//MAKR: - Collection View Delegate Mehtod
extension PrivateContestResultVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrBrackets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width / 4, height: 25)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BracketCVC", for: indexPath) as! BracketCVC
        
        cell.labelNumber.text = "\(arrBrackets[indexPath.row]["number"] as? Int ?? 0)"
        
        let strColor = arrBrackets[indexPath.row]["color"] as? String ?? "red"
        if strColor == "red" {
            cell.viewColor.backgroundColor = UIColor.red
        } else if strColor == "green" {
            cell.viewColor.backgroundColor = UIColor.green
        } else if strColor == "blue" {
            cell.viewColor.backgroundColor = UIColor.blue
        }
        
        return cell
    }
}

//MARK: - TableView Delegate Method
extension PrivateContestResultVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrTickets.count
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "PrivateContestResultHeaderTVC") as! PrivateContestResultHeaderTVC
        
        return headerCell
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PrivateContestResultDetailTVC") as! PrivateContestResultDetailTVC
        
        let strAmonut = "\(arrTickets[indexPath.row]["amount"] as? Double ?? 0.0)"
        cell.labelEntryFees.text = "₹\(MyModel().getNumbers(value: Double(strAmonut)!))"
        cell.labelJoin.text = "\(arrTickets[indexPath.row]["totalJoin"]!)"
        cell.labelWinner.text = "\(arrTickets[indexPath.row]["winners"]!)"
        cell.buttonWinner.addTarget(self,
                                  action: #selector(buttonView(_:)),
                                  for: .touchUpInside)
        cell.buttonWinner.tag = indexPath.row
        
        return cell
    }
    
    //MARK: - TableView Button
    @objc func buttonView(_ sender: UIButton) {
        let index = sender.tag
        let winnerVC = self.storyboard?.instantiateViewController(withIdentifier: "PrivateContesrWinnerVC") as! PrivateContesrWinnerVC
        winnerVC.dictContest = dictContest
        winnerVC.dictTickets = arrTickets[index]
        self.navigationController?.pushViewController(winnerVC, animated: true)
    }
}

//MARK: - Notifcation Delegate Method
extension PrivateContestResultVC: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        switch response.actionIdentifier {
        case Define.PLAYGAME:
            print("Play Game")
            let dictData = response.notification.request.content.userInfo as! [String: Any]
            print(dictData)
            let gamePlayVC = self.storyboard?.instantiateViewController(withIdentifier: "GamePlayVC") as! GamePlayVC
            gamePlayVC.isFromNotification = true
            gamePlayVC.dictContest = dictData
            self.navigationController?.pushViewController(gamePlayVC, animated: true)
        default:
            break
        }
        
    }
}


//MARK: - Cell Class
class PrivateContestResultDetailTVC: UITableViewCell {
    
    @IBOutlet weak var labelEntryFees: UILabel!
    @IBOutlet weak var labelJoin: UILabel!
    @IBOutlet weak var labelWinner: UILabel!
    @IBOutlet weak var buttonWinner: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        MyModel().roundCorners(corners: [.allCorners], radius: 5, view: buttonWinner)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}

class PrivateContestResultHeaderTVC: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}

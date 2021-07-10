import UIKit
import UserNotifications

struct SelectedFixTickets {
    var entryFees = String()
    var numberOfSlot = String()
    init(fees: String, sloat: String = "2") {
        entryFees = fees
        numberOfSlot = sloat
    }
    
}
struct SelectedFlexiTickets {
    var entryFees = String()
    var barRange = String()
    
    init(fees: String, range: String = "10") {
        entryFees = fees
        barRange = range
    }
}

class CreateContestContinueVC: UIViewController {
    //MARK: - Properties
    @IBOutlet weak var tableTickets: UITableView!
    
    var selectedIndexPath = CreateContestContinueFlexiTVC()
    var selectedFixIndexPath = CreateContestContinueFixTVC()
    
    var isType = Bool()
    var isNotify = Bool()
    
    
    var arrFixTickets = [SelectedFixTickets]()
    var arrFlexiTickets = [SelectedFlexiTickets]()
    
    var selectedIndex = Int()
    var numberOfTikets = Int()
    var dictContestData = [String: String]()
    
    var arrTicketData = [[String: Any]]()
    
    var gameMode = String()
    var selectedAnswerRangeIndex = Int()
    
    
    //MARK: - Default Method
    override func viewDidLoad() {
        super.viewDidLoad()
        tableTickets.rowHeight = UITableView.automaticDimension
        tableTickets.tableFooterView = UIView()
      //  UNUserNotificationCenter.current().delegate = self
        
        print("➥ Contest Data: \(dictContestData)")
        gameMode = dictContestData["GameMode"]!
        selectedAnswerRangeIndex = Int(dictContestData["selectedAnswerRangeIndex"]!)!
        
        if isType {
            arrFixTickets = [SelectedFixTickets](repeating: SelectedFixTickets.init(fees: "", sloat: "2"), count: numberOfTikets)
        } else {
            if selectedAnswerRangeIndex == 0 {
                arrFlexiTickets = [SelectedFlexiTickets](repeating: SelectedFlexiTickets.init(fees: "", range: "80"), count: numberOfTikets)
            } else if selectedAnswerRangeIndex == 1 {
                arrFlexiTickets = [SelectedFlexiTickets](repeating: SelectedFlexiTickets.init(fees: "", range: "8"), count: numberOfTikets)
            } else if selectedAnswerRangeIndex == 2 {
                arrFlexiTickets = [SelectedFlexiTickets](repeating: SelectedFlexiTickets.init(fees: "", range: "4"), count: numberOfTikets)
            }
        }
        tableTickets.reloadData()
    }
    
    //MARK: - Buttin Method
    @IBAction func buttonBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonSave(_ sender: Any) {
        view.endEditing(true)
        if isType {
            if !checkEntryFees() {
                Alert().showTost(message: "Enter entry fees or must be grater ₹0", viewController: self)
            } else {
                createContestAPI()
            }
        } else {
            if !checkFlexiEntryFees() {
                Alert().showTost(message: "Enter entry fees or must be grater ₹0", viewController: self)
            } else {
               createContestAPI()
            }
        }
    }
    
    func checkFlexiEntryFees() -> Bool {
        for itme in arrFlexiTickets {
            let strFees = itme.entryFees
            if strFees.isEmpty {
                return false
            } else if Double(strFees)! < 0 {
                return false
            } else {
                var dictTicketsData = [String: Any]()
                dictTicketsData["amount"] = itme.entryFees
                dictTicketsData["bracketSize"] = itme.barRange
                arrTicketData.append(dictTicketsData)
            }
        }
        return true
    }
    
    func checkEntryFees() -> Bool {
        for itme in arrFixTickets {
            let strFees = itme.entryFees
            if strFees.isEmpty {
                return false
            } else if Double(strFees)! < 0 {
                return false
            } else {
                var dictTicketsData = [String: Any]()
                let slotNumber = Int(itme.numberOfSlot)!
                dictTicketsData["amount"] = itme.entryFees
                dictTicketsData["slots"] = self.getSlots(index: slotNumber)
                //dictTicketsData["displayValue"] =
                arrTicketData.append(dictTicketsData)
            }
        }
        return true
    }
    
    func getSlots(index: Int) -> [[String: String]] {
        var arrSetSlotData = [[String: String]]()
        var arrsloatData = [SloatData]()
        
        if index == 2 {
            if selectedAnswerRangeIndex == 0 {
                arrsloatData = PrivateContest.arr2Sloats
            } else if selectedAnswerRangeIndex == 1 {
                arrsloatData = PrivateContest.arr2SloatsFor1
            } else if selectedAnswerRangeIndex == 2 {
                arrsloatData = PrivateContest.arr2SloatsFor2
            }
        } else if index == 3 {
            if selectedAnswerRangeIndex == 0 {
                arrsloatData = PrivateContest.arr3Sloats
            } else if selectedAnswerRangeIndex == 1 {
                arrsloatData = PrivateContest.arr3SloatsFor1
            } else if selectedAnswerRangeIndex == 2 {
                arrsloatData = PrivateContest.arr3SloatsFor2
            }
        } else if index == 4 {
            if selectedAnswerRangeIndex == 0 {
                arrsloatData = PrivateContest.arr4Sloats
            } else if selectedAnswerRangeIndex == 1 {
                arrsloatData = PrivateContest.arr4SloatsFor1
            } else if selectedAnswerRangeIndex == 2 {
                arrsloatData = PrivateContest.arr4SloatsFor2
            }
        } else if index == 5 {
            if selectedAnswerRangeIndex == 0 {
                arrsloatData = PrivateContest.arr5Sloats
            } else if selectedAnswerRangeIndex == 1 {
                arrsloatData = PrivateContest.arr5SloatsFor1
            } else if selectedAnswerRangeIndex == 2 {
                arrsloatData = PrivateContest.arr5SloatsFor2
            }
        } else if index == 6 {
            if selectedAnswerRangeIndex == 0 {
                arrsloatData = PrivateContest.arr6Sloats
            } else if selectedAnswerRangeIndex == 1 {
                arrsloatData = PrivateContest.arr6SloatsFor1
            } else if selectedAnswerRangeIndex == 2 {
                arrsloatData = PrivateContest.arr6SloatsFor2
            }
        } else if index == 7 {
            if selectedAnswerRangeIndex == 0 {
                arrsloatData = PrivateContest.arr7Sloats
            } else if selectedAnswerRangeIndex == 1 {
                arrsloatData = PrivateContest.arr7SloatsFor1
            } else if selectedAnswerRangeIndex == 2 {
                arrsloatData = PrivateContest.arr7SloatsFor2
            }
        } else if index == 8 {
            if selectedAnswerRangeIndex == 0 {
                arrsloatData = PrivateContest.arr8Sloats
            } else if selectedAnswerRangeIndex == 1 {
                arrsloatData = PrivateContest.arr7SloatsFor1
            } else if selectedAnswerRangeIndex == 2 {
                arrsloatData = PrivateContest.arr8SloatsFor2
            }
        } else if index == 9{
            if selectedAnswerRangeIndex == 0 {
                arrsloatData = PrivateContest.arr9Sloats
            } else if selectedAnswerRangeIndex == 1 {
                arrsloatData = PrivateContest.arr9SloatsFor1
            } else if selectedAnswerRangeIndex == 2 {
                arrsloatData = PrivateContest.arr9SloatsFor2
            }
        } else if index == 10{
            if selectedAnswerRangeIndex == 0 {
                arrsloatData = PrivateContest.arr10Sloats
            } else if selectedAnswerRangeIndex == 1 {
                arrsloatData = PrivateContest.arr10SloatsFor1
            } else if selectedAnswerRangeIndex == 2 {
                arrsloatData = PrivateContest.arr10SloatsFor2
            }
        }
        
        for itme in arrsloatData {
            var dictSlotData = [String: String]()
            dictSlotData["startValue"] = itme.startValue
            dictSlotData["endValue"] = itme.endValue
            dictSlotData["displayValue"] = itme.displayValue
            arrSetSlotData.append(dictSlotData)
        }
        return arrSetSlotData
    }
}

//MARK: - TableView Delegate Method
extension CreateContestContinueVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isType {
            return arrFixTickets.count
        } else {
            return arrFlexiTickets.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isType {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CreateContestContinueFixTVC") as! CreateContestContinueFixTVC
            cell.layoutIfNeeded()
            
            cell.textEntryFees.text = arrFixTickets[indexPath.row].entryFees
            cell.labelNoOfTickets.text = arrFixTickets[indexPath.row].numberOfSlot
            
            cell.gameMode = dictContestData["GameMode"]!
            cell.selectedAnswerRangeIndex = Int(dictContestData["selectedAnswerRangeIndex"]!)!
            
            let strSlot = arrFixTickets[indexPath.row].numberOfSlot
            let slot = Int(strSlot)
            
            cell.constrintSlotTableHeight.constant = CGFloat(slot! * 50)
            
            cell.slotNo = nil
            cell.slotNo = slot
            
            cell.tableSlots.reloadData()
            
            cell.buttonSelectTicket.addTarget(self,
                                             action: #selector(buttonFixCellSelection(_:)),
                                             for: .touchUpInside)
            cell.buttonSelectTicket.tag = indexPath.row
            
            cell.textEntryFees.addTarget(self,
                                         action: #selector(textValueChange(_:)),
                                         for: .editingDidEnd)
            cell.textEntryFees.tag = indexPath.row
            cell.layoutIfNeeded()
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CreateContestContinueFlexiTVC") as! CreateContestContinueFlexiTVC
            cell.textEntryFees.text = arrFlexiTickets[indexPath.row].entryFees
            cell.labelRange.text = arrFlexiTickets[indexPath.row].barRange
            
            cell.textEntryFees.addTarget(self,
                                         action: #selector(flexiTextValueChange(_:)),
                                         for: .editingDidEnd)
            cell.textEntryFees.tag = indexPath.row
            
            cell.buttonSelectRange.addTarget(self,
                                             action: #selector(buttonSelection(_:)),
                                             for: .touchUpInside)
            cell.buttonSelectRange.tag = indexPath.row
            return cell
        }
    }
    //MARK: - TableView Button Method
    @objc func buttonSelection(_ sender: UIButton) {
        let index = sender.tag
        selectedIndex = index
        //let indexPath = IndexPath(row: index, section: 0)
        view.endEditing(true)
        var arrRangeBracket = [String]()
        
        if selectedAnswerRangeIndex == 0 {
            arrRangeBracket = PrivateContest.arrBracketSize
        } else if selectedAnswerRangeIndex == 1 {
            arrRangeBracket = PrivateContest.arrBracketSizeFor1
        } else if selectedAnswerRangeIndex == 2 {
            arrRangeBracket = PrivateContest.arrBracketSizeFor2
        }
        
        let viewSelection = SelectionView.instanceFromNib() as! SelectionView
        viewSelection.delegate = self
        viewSelection.frame = view.bounds
        viewSelection.arrData = arrRangeBracket
        view.addSubview(viewSelection)
    }
    
    @objc func buttonFixCellSelection(_ sender: UIButton) {
        let index = sender.tag
        selectedIndex = index
        view.endEditing(true)
        
        let viewSelection = SelectionView.instanceFromNib() as! SelectionView
        viewSelection.delegate = self
        viewSelection.frame = view.bounds
        viewSelection.arrData = PrivateContest.arrOfSlots
        view.addSubview(viewSelection)
        
    }
    
    //MARK: - TestField Action
    @objc func textValueChange(_ sender: UITextField) {
        let index = sender.tag
        
        let indexPath = IndexPath(row: index, section: 0)
        selectedFixIndexPath = tableTickets.cellForRow(at: indexPath) as! CreateContestContinueFixTVC
        
        if let fees = selectedFixIndexPath.textEntryFees.text {
            if let feesValue = Double(fees) {
                if feesValue < 0 {
                    Alert().showTost(message: "Entery fees must be grater ₹0", viewController: self)
                } else {
                    if feesValue.truncatingRemainder(dividingBy: 1.0) != 0.0 {
                        selectedFixIndexPath.textEntryFees?.text = String(format: "%.2f", feesValue)
                    }
                    arrFixTickets[index].entryFees = selectedFixIndexPath.textEntryFees.text!
                }
            } else {
                Alert().showTost(message: "Enter proper value", viewController: self)
                selectedFixIndexPath.textEntryFees?.text = nil
            }
        }
    }
    
    @objc func flexiTextValueChange(_ sender: UITextField) {
        let index = sender.tag
        
        let indexPath = IndexPath(row: index, section: 0)
        selectedIndexPath = tableTickets.cellForRow(at: indexPath) as! CreateContestContinueFlexiTVC
        if let fees =  selectedIndexPath.textEntryFees.text {
            if let feesValue = Double(fees) {
                if feesValue < 0 {
                    Alert().showTost(message: "Entery fees must be grater ₹0", viewController: self)
                } else {
                    if feesValue.truncatingRemainder(dividingBy: 1.0) != 0.0 {
                        selectedIndexPath.textEntryFees?.text = String(format: "%.2f", feesValue)
                    }
                    arrFlexiTickets[index].entryFees = selectedIndexPath.textEntryFees.text!
                }
            } else {
                Alert().showTost(message: "Enter proper value", viewController: self)
                selectedIndexPath.textEntryFees?.text = nil
            }
        }
    }
}

//MARK: - Selection View Delegate
extension CreateContestContinueVC: SelectionViewDelegate {
    func getSelectionValue(strValue: String, index: Int) {
        if isType {
            view.layoutIfNeeded()
            self.arrFixTickets[self.selectedIndex].numberOfSlot = strValue
            let indexPath = IndexPath(row: selectedIndex, section: 0)
            tableTickets.reloadRows(at: [indexPath], with: .automatic)
            view.layoutIfNeeded()
        } else {
            self.arrFlexiTickets[selectedIndex].barRange = strValue
            let indexPath = IndexPath(row: self.selectedIndex, section: 0)
            tableTickets.reloadRows(at: [indexPath], with: .automatic)
        }
        print("Arr Selected \(arrFlexiTickets)")
        print("Arr Fix \(arrFixTickets)")
    }
}

//MARK: - API
extension CreateContestContinueVC {
    func createContestAPI() {
        Loading().showLoading(viewController: self)
        let strJosnString = MyModel().getJSONString(object: arrTicketData)!
        print("➥",strJosnString)
        let parameter: [String: Any] = [
            "name": dictContestData["ContestName"]!,
            "level": dictContestData["GameMode"]!,
            "startDate": dictContestData["ContestDate"]!,
            "startTime": dictContestData["ContestTime"]!,
            "maxWinner": dictContestData["MaxWinner"]!,
            "type": dictContestData["GameType"]!,
            "ticketJson": strJosnString,
            "isNotify": isNotify ? "true" : "false",
            "rangeMin": dictContestData["rangeMin"]!,
            "rangeMax": dictContestData["rangeMax"]!
        ]
        
        
        let strURL = Define.APP_URL + Define.API_ADD_PRIVATE_CONTEST
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
                print("Error: \(error!.localizedDescription)")
                self.retry()
            } else {
                Loading().hideLoading(viewController: self)
                print("Result: \(result!)")
                let status = result!["statusCode"] as? Int ?? 0
                if status == 200 {
                    let dictData = result!["content"] as! [String: Any]
                    NotificationCenter.default.post(name: .hostContest, object: nil)
                    let shareVC = self.storyboard?.instantiateViewController(withIdentifier: "ShareContestCodeVC") as! ShareContestCodeVC
                    shareVC.strContestCode = dictData["contestId"] as! String
                    self.navigationController?.pushViewController(shareVC, animated: true)
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

//MARK: - TableView Cell Class
class CreateContestContinueFlexiTVC: UITableViewCell {
    
    @IBOutlet weak var textEntryFees: UITextField!
    @IBOutlet weak var labelRange: UILabel!
    @IBOutlet weak var buttonSelectRange: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}

class CreateContestContinueFixTVC: UITableViewCell {
    
    @IBOutlet weak var textEntryFees: UITextField!
    @IBOutlet weak var labelNoOfTickets: UILabel!
    @IBOutlet weak var buttonSelectTicket: UIButton!
    @IBOutlet weak var tableSlots: UITableView!
    @IBOutlet weak var constrintSlotTableHeight: NSLayoutConstraint!
    
    var numberOfSloat = Int()
    var arrsloatData = [SloatData]()
    
    var gameMode = String()
    var selectedAnswerRangeIndex = Int()
    
    
    var slotNo: Int? {
        didSet {
            guard let item = slotNo else {
                return
            }
            numberOfSloat = item
            getSlotArray(index: numberOfSloat)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tableSlots.delegate = self
        tableSlots.dataSource = self
        tableSlots.rowHeight = 50
        textEntryFees.delegate = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func getSlotArray(index: Int) {
        
        if index == 2 {
            if selectedAnswerRangeIndex == 0 {
                arrsloatData = PrivateContest.arr2Sloats
            } else if selectedAnswerRangeIndex == 1 {
                arrsloatData = PrivateContest.arr2SloatsFor1
            } else if selectedAnswerRangeIndex == 2 {
                arrsloatData = PrivateContest.arr2SloatsFor2
            }
        } else if index == 3 {
            if selectedAnswerRangeIndex == 0 {
                arrsloatData = PrivateContest.arr3Sloats
            } else if selectedAnswerRangeIndex == 1 {
                arrsloatData = PrivateContest.arr3SloatsFor1
            } else if selectedAnswerRangeIndex == 2 {
                arrsloatData = PrivateContest.arr3SloatsFor2
            }
        } else if index == 4 {
            if selectedAnswerRangeIndex == 0 {
                arrsloatData = PrivateContest.arr4Sloats
            } else if selectedAnswerRangeIndex == 1 {
                arrsloatData = PrivateContest.arr4SloatsFor1
            } else if selectedAnswerRangeIndex == 2 {
                arrsloatData = PrivateContest.arr4SloatsFor2
            }
        } else if index == 5 {
            if selectedAnswerRangeIndex == 0 {
                arrsloatData = PrivateContest.arr5Sloats
            } else if selectedAnswerRangeIndex == 1 {
                arrsloatData = PrivateContest.arr5SloatsFor1
            } else if selectedAnswerRangeIndex == 2 {
                arrsloatData = PrivateContest.arr5SloatsFor2
            }
        } else if index == 6 {
            if selectedAnswerRangeIndex == 0 {
                arrsloatData = PrivateContest.arr6Sloats
            } else if selectedAnswerRangeIndex == 1 {
                arrsloatData = PrivateContest.arr6SloatsFor1
            } else if selectedAnswerRangeIndex == 2 {
                arrsloatData = PrivateContest.arr6SloatsFor2
            }
        } else if index == 7 {
            if selectedAnswerRangeIndex == 0 {
                arrsloatData = PrivateContest.arr7Sloats
            } else if selectedAnswerRangeIndex == 1 {
                arrsloatData = PrivateContest.arr7SloatsFor1
            } else if selectedAnswerRangeIndex == 2 {
                arrsloatData = PrivateContest.arr7SloatsFor2
            }
        } else if index == 8 {
            if selectedAnswerRangeIndex == 0 {
                arrsloatData = PrivateContest.arr8Sloats
            } else if selectedAnswerRangeIndex == 1 {
                arrsloatData = PrivateContest.arr8SloatsFor1
            } else if selectedAnswerRangeIndex == 2 {
                arrsloatData = PrivateContest.arr8SloatsFor2
            }
        } else if index == 9{
            if selectedAnswerRangeIndex == 0 {
                arrsloatData = PrivateContest.arr9Sloats
            } else if selectedAnswerRangeIndex == 1 {
                arrsloatData = PrivateContest.arr9SloatsFor1
            } else if selectedAnswerRangeIndex == 2 {
                arrsloatData = PrivateContest.arr9SloatsFor2
            }
        } else if index == 10{
            if selectedAnswerRangeIndex == 0 {
                arrsloatData = PrivateContest.arr10Sloats
            } else if selectedAnswerRangeIndex == 1 {
                arrsloatData = PrivateContest.arr10SloatsFor1
            } else if selectedAnswerRangeIndex == 2 {
                arrsloatData = PrivateContest.arr10SloatsFor2
            }
        }
    }
}

//MARK: - TableView Delegate Method
extension CreateContestContinueFixTVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfSloat
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FixSlotTVC",
                                                 for: indexPath) as! FixSlotTVC
        cell.labelSlotNumber.text = "\(indexPath.row + 1)"
        
        cell.labelStartValue.text = arrsloatData[indexPath.row].startValue
        cell.labelEndValue.text = arrsloatData[indexPath.row].endValue
        
        return cell
    }
}

extension CreateContestContinueVC {
    func retry() {
        let alertController = UIAlertController(title: Define.ERROR_TITLE,
                                                message: Define.ERROR_SERVER,
                                                preferredStyle: .alert)
        let buttonRetry = UIAlertAction(title: "Retry",
                                        style: .default)
        { _ in
            self.createContestAPI()
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

//MARK: - TextField Delegate Method
extension CreateContestContinueFixTVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
}

//MARK: - Notifcation Delegate Method
//extension CreateContestContinueVC: UNUserNotificationCenterDelegate {
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
class FixSlotTVC: UITableViewCell {
    
    @IBOutlet weak var labelSlotNumber: UILabel!
    @IBOutlet weak var viewStartValue: UIView!
    @IBOutlet weak var viewEndValue: UIView!
    @IBOutlet weak var labelStartValue: UILabel!
    @IBOutlet weak var labelEndValue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setView(view: viewStartValue)
        setView(view: viewEndValue)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func setView(view: UIView) {
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1
    }
}

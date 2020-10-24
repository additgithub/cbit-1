import UIKit
import UserNotifications

class CreateContestVC: UIViewController {
    //MARK: - Properties
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var buttonNotify: UIButton!
    @IBOutlet weak var textContestName: UITextField!
    @IBOutlet weak var textDate: UITextField!
    @IBOutlet weak var textTime: UITextField!
    
    @IBOutlet weak var buttonModeEasy: UIButton!
    @IBOutlet weak var buttonModeMedium: UIButton!
    @IBOutlet weak var buttonModePro: UIButton!
    @IBOutlet weak var buttonTypeFlexibar: UIButton!
    @IBOutlet weak var buttonTypeFixbar: UIButton!
    
    @IBOutlet weak var labelNumberOfTickets: UILabel!
    @IBOutlet weak var labelMaxWinner: UILabel!
    @IBOutlet weak var buttonNumberOfTickets: UIButton!
    @IBOutlet weak var buttonMaxWinner: UIButton!
    @IBOutlet weak var buttonAnswerRange: UIButton!
    @IBOutlet weak var labelAnswerRange: UILabel!
    
    private var isNotify = Bool()
    private var datePicker: DatePickerDialog?
    
    private var isModeEasy = true
    private var isModeMedium = false
    private var isModePro = false
    
    private var isTypeFlexibar = true
    private var isTypeFixbar = false
    
    private var isNumberOfTicket = Bool()
    private var isMaxWinner = Bool()
    
    private var dropDown: MyDropDown?
    private var buttonSelecteDropDown = UIButton()
    
    private var contestDate: Date?
    private var cintestTime: Date?
    
    private var numberOfTickets = 1
    private var maxWinner = 10
    private var strStartDate = String()
    private var strStartTime = String()
    private var dictSelectedData = [String: String]()
    
    private var selectedAnswerRangeIndex = 0
    
    //MARK: - Default Method
    override func viewDidLoad() {
        super.viewDidLoad()
        UNUserNotificationCenter.current().delegate = self
        setDatePicker()
    }
    
    private func setDatePicker() {
        datePicker = DatePickerDialog(textColor: Define.MAINVIEWCOLOR,
                                      buttonColor: Define.MAINVIEWCOLOR,
                                      font: UIFont(name: labelTitle.font.fontName, size: 14)!,
                                      locale: nil,
                                      showCancelButton: true)
    }
    
    private func showDatePicker() {
        datePicker!.show("Select Date",
                         doneButtonTitle: "Select",
                         cancelButtonTitle: "Cancel",
                         defaultDate: Date(),
                         minimumDate: Date(),
                         maximumDate: nil,
                         datePickerMode: .date)
        { (date) in
            if let selectedDate = date {
                let dateFormater = DateFormatter()
                dateFormater.dateFormat = "dd-MM-yyyy"
                self.contestDate = selectedDate
                print("Date: ", dateFormater.string(from: selectedDate))
                self.textDate.text = dateFormater.string(from: selectedDate)
                self.textTime.text = nil
                self.strStartDate = dateFormater.string(from: selectedDate)
            }
        }
    }
    
    private func showTimePicker() {
        var timeLimit: Date?
        
        if contestDate != nil {
            if Calendar.current.isDate(contestDate!, inSameDayAs: Date()) {
                timeLimit = Calendar.current.date(byAdding: .minute, value: 10, to: Date())
            } else {
                timeLimit = nil
            }
        } else {
            timeLimit = Calendar.current.date(byAdding: .minute, value: 10, to: Date())
        }
        datePicker!.show("Select Time",
                         doneButtonTitle: "Select",
                         cancelButtonTitle: "Cancel",
                         defaultDate: Date(),
                         minimumDate: timeLimit,
                         maximumDate: nil,
                         datePickerMode: .time)
        { (date) in
            if let selectedDate = date {
                let dateFormater = DateFormatter()
                dateFormater.dateFormat = "hh:mm a"
                print("Time: ", dateFormater.string(from: selectedDate))
                self.textTime.text = dateFormater.string(from: selectedDate)
                self.strStartTime = MyModel().convertDateToString(date: selectedDate, returnFormate: "HH:mm:ss")
            }
        }
    }
    
    //MARK: - Button Method
    @IBAction func buttonBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func buttonSelectDate(_ sender: Any) {
        showDatePicker()
    }
    @IBAction func buttonTextSelectDate(_ sender: Any) {
        showDatePicker()
    }
    
    @IBAction func buttonTextSelectTime(_ sender: Any) {
        showTimePicker()
    }
    @IBAction func buttonSelectTime(_ sender: Any) {
        showTimePicker()
    }
    
    @IBAction func buttonNotify(_ sender: Any) {
        if isNotify {
            isNotify = false
            buttonNotify.setImage(#imageLiteral(resourceName: "ic_unchecked"), for: .normal)
        } else {
            isNotify = true
            buttonNotify.setImage(#imageLiteral(resourceName: "ic_checked"), for: .normal)
        }
    }
    //TODO: Next Button
    @IBAction func buttonNext(_ sender: Any) {
        
        if textContestName.text!.isEmpty {
            Alert().showTost(message: "Enter Contest Name",
                             viewController: self)
        } else if textDate.text!.isEmpty {
            Alert().showTost(message: "Select Contest Date",
                             viewController: self)
        } else if textTime.text!.isEmpty {
            Alert().showTost(message: "Select Contest Time",
                             viewController: self)
        } else {
            dictSelectedData["ContestName"] = textContestName.text!
            dictSelectedData["ContestDate"] = strStartDate
            dictSelectedData["ContestTime"] = strStartTime
            dictSelectedData["NumberOfTickets"] = "\(numberOfTickets)"
            dictSelectedData["MaxWinner"] = "\(maxWinner)"
            dictSelectedData["GameMode"] = getGameMode()
            dictSelectedData["GameType"] = getGameType()
            dictSelectedData["rangeMin"] = "\(PrivateContest.arrRangeData[selectedAnswerRangeIndex].minValue)"
            dictSelectedData["rangeMax"] = "\(PrivateContest.arrRangeData[selectedAnswerRangeIndex].maxValue)"
            dictSelectedData["selectedAnswerRangeIndex"] = "\(selectedAnswerRangeIndex)"
            let continueVC = self.storyboard?.instantiateViewController(withIdentifier: "CreateContestContinueVC") as! CreateContestContinueVC
            if isTypeFlexibar {
                continueVC.isType = false
            } else if isTypeFixbar {
                continueVC.isType = true
            }
            continueVC.isNotify = isNotify
            continueVC.numberOfTikets = numberOfTickets
            continueVC.dictContestData = dictSelectedData
            continueVC.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(continueVC, animated: true)
        }
    }
    
    func getGameMode() -> String{
        if isModeEasy {
            return "1"
        } else if isModeMedium {
            return "2"
        } else if isModePro {
            return "3"
        }
        return "1"
    }
    func getGameType() -> String {
        if isTypeFlexibar {
            return "0"
        } else if isTypeFixbar {
            return "1"
        }
        return "0"
    }
    //TODO: RadioButoon
    @IBAction func buttonModeEasy(_ sender: Any) {
        if dropDown != nil {
            dropDown!.hideMyDropDown(sendButton: buttonSelecteDropDown)
            dropDown = nil
        }
        labelAnswerRange.text = "-100 to 100"
        selectedAnswerRangeIndex = 0
        
        isModeEasy = true
        isModeMedium = false
        isModePro = false
        
        buttonModeEasy.setImage(#imageLiteral(resourceName: "ic_radiobuttonfill"), for: .normal)
        buttonModeMedium.setImage(#imageLiteral(resourceName: "ic_radiobuttonempty"), for: .normal)
        buttonModePro.setImage(#imageLiteral(resourceName: "ic_radiobuttonempty"), for: .normal)
    }
    
    @IBAction func buttonModeMedium(_ sender: Any) {
        if dropDown != nil {
            dropDown!.hideMyDropDown(sendButton: buttonSelecteDropDown)
            dropDown = nil
        }
        labelAnswerRange.text = "-100 to 100"
        selectedAnswerRangeIndex = 0
        
        isModeEasy = false
        isModeMedium = true
        isModePro = false
        
        buttonModeEasy.setImage(#imageLiteral(resourceName: "ic_radiobuttonempty"), for: .normal)
        buttonModeMedium.setImage(#imageLiteral(resourceName: "ic_radiobuttonfill"), for: .normal)
        buttonModePro.setImage(#imageLiteral(resourceName: "ic_radiobuttonempty"), for: .normal)
    }
    
    @IBAction func buttonModePro(_ sender: Any) {
        if dropDown != nil {
            dropDown!.hideMyDropDown(sendButton: buttonSelecteDropDown)
            dropDown = nil
        }
        labelAnswerRange.text = "-100 to 100"
        selectedAnswerRangeIndex = 0
        
        isModeEasy = false
        isModeMedium = false
        isModePro = true
        
        buttonModeEasy.setImage(#imageLiteral(resourceName: "ic_radiobuttonempty"), for: .normal)
        buttonModeMedium.setImage(#imageLiteral(resourceName: "ic_radiobuttonempty"), for: .normal)
        buttonModePro.setImage(#imageLiteral(resourceName: "ic_radiobuttonfill"), for: .normal)
    }
    
    @IBAction func buttonTypeFlexibar(_ sender: Any) {
        if dropDown != nil {
            dropDown!.hideMyDropDown(sendButton: buttonSelecteDropDown)
            dropDown = nil
        }
        
        isTypeFlexibar = true
        isTypeFixbar = false
        
        buttonTypeFlexibar.setImage(#imageLiteral(resourceName: "ic_radiobuttonfill"), for: .normal)
        buttonTypeFixbar.setImage(#imageLiteral(resourceName: "ic_radiobuttonempty"), for: .normal)
    }
    
    @IBAction func buttonTypeFixbar(_ sender: Any) {
        if dropDown != nil {
            dropDown!.hideMyDropDown(sendButton: buttonSelecteDropDown)
            dropDown = nil
        }
        
        isTypeFlexibar = false
        isTypeFixbar = true
        
        buttonTypeFlexibar.setImage(#imageLiteral(resourceName: "ic_radiobuttonempty"), for: .normal)
        buttonTypeFixbar.setImage(#imageLiteral(resourceName: "ic_radiobuttonfill"), for: .normal)
    }
    
    //TODO: DropDown
    @IBAction func buttonNumberOfTickets(_ sender: Any) {
        isNumberOfTicket = true
        isMaxWinner = false
        
        if dropDown == nil {
            buttonSelecteDropDown = buttonNumberOfTickets
            dropDown = MyDropDown()
            dropDown!.delegate = self
            dropDown!.showMyDropDown(sendButton: buttonNumberOfTickets,
                                     height: 180,
                                     arrayList: PrivateContest.arrOfTickets,
                                     imageList: nil,
                                     direction: "Up")
        } else {
            dropDown!.hideMyDropDown(sendButton: buttonSelecteDropDown)
            dropDown = nil
        }
    }
    
    @IBAction func buttonMaxWinner(_ sender: Any) {
        isNumberOfTicket = false
        isMaxWinner = true
        
        if dropDown == nil {
            buttonSelecteDropDown = buttonMaxWinner
            dropDown = MyDropDown()
            dropDown!.delegate = self
            dropDown!.showMyDropDown(sendButton: buttonMaxWinner,
                                     height: 180,
                                     arrayList: PrivateContest.arrMaxWinner,
                                     imageList: nil,
                                     direction: "Up")
        } else {
            dropDown!.hideMyDropDown(sendButton: buttonSelecteDropDown)
            dropDown = nil
        }
    }
    @IBAction func buttonAnswerRange(_ sender: Any) {
        isNumberOfTicket = false
        isMaxWinner = false
        
        var dropDownHeight = CGFloat()
        
//        if getGameMode() == "1" {
//            dropDownHeight = 40
//        } else if getGameMode() == "2" {
//            dropDownHeight = 120
//        } else if getGameMode() == "3" {
//            dropDownHeight = 120
//        }
        
        dropDownHeight = 120
        
        if dropDown == nil {
            buttonSelecteDropDown = buttonAnswerRange
            dropDown = MyDropDown()
            dropDown!.delegate = self
            dropDown!.showMyDropDown(sendButton: buttonAnswerRange,
                                     height: dropDownHeight,
                                     arrayList: MyModel().getAnserRange(strMode: getGameMode()),
                                     imageList: nil,
                                     direction: "Down")
        } else {
            dropDown!.hideMyDropDown(sendButton: buttonSelecteDropDown)
            dropDown = nil
        }
    }
}

//MARK: - Notifcation Delegate Method
extension CreateContestVC: UNUserNotificationCenterDelegate {
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

//MARK: - Drop Down Delegate Method
extension CreateContestVC: MyDropDownDelegate {
    func recievedSelectedValue(name: String, index: Int) {
        if isNumberOfTicket {
            isNumberOfTicket = false
            labelNumberOfTickets.text = "\(name)"
            numberOfTickets = Int(name)!
        } else if isMaxWinner {
            isMaxWinner = false
            labelMaxWinner.text = "\(name)%"
            maxWinner = Int(name)!
        } else {
            labelAnswerRange.text = "\(name)"
            selectedAnswerRangeIndex = index
        }
        dropDown!.hideMyDropDown(sendButton: buttonSelecteDropDown)
        dropDown = nil
    }
}

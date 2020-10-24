import UIKit

class UpdateContestVC: UIViewController {
    //MARK: - Properies.
    @IBOutlet weak var textEntryFees: UITextField!
    @IBOutlet weak var textDate: UITextField!
    @IBOutlet weak var textTime: UITextField!
    @IBOutlet weak var textBracketSize: UITextField!
    
    private var datePicker: DatePickerDialog?
    
    //MARK: - Default Method
    override func viewDidLoad() {
        super.viewDidLoad()
        setDatePicker()
    }
    
    private func setDatePicker() {
        datePicker = DatePickerDialog(textColor: Define.MAINVIEWCOLOR,
                                      buttonColor: Define.MAINVIEWCOLOR,
                                      font: UIFont(name: "Helvetica Neue", size: 14)!,
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
                print("Date: ", dateFormater.string(from: selectedDate))
                self.textDate.text = dateFormater.string(from: selectedDate)
            }
        }
    }
    
    private func showTimePicker() {
        datePicker!.show("Select Time",
                         doneButtonTitle: "Select",
                         cancelButtonTitle: "Cancel",
                         defaultDate: Date(),
                         minimumDate: nil,
                         maximumDate: nil,
                         datePickerMode: .time)
        { (date) in
            if let selectedDate = date {
                let dateFormater = DateFormatter()
                dateFormater.dateFormat = "HH:mm a"
                print("Time: ", dateFormater.string(from: selectedDate))
                self.textTime.text = dateFormater.string(from: selectedDate)
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
    
    @IBAction func buttonUpdate(_ sender: Any) {
        
    }
}

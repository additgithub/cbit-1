import UIKit

public protocol SelectionViewDelegate {
    func getSelectionValue(strValue: String, index: Int)
}

class SelectionView: UIView {

    @IBOutlet weak var tableSelection: UITableView!
    @IBOutlet weak var constraintSelectionTableHeight: NSLayoutConstraint!
    
    var delegate: SelectionViewDelegate?
    var arrSelectionValues = [String]()
    
    var arrData: [String]? {
        didSet {
            guard let arrItems = arrData else {
                return
            }
            arrSelectionValues = arrItems
            tableSelection.rowHeight = 50
            constraintSelectionTableHeight.constant = CGFloat(arrSelectionValues.count * 50)
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tableSelection.delegate = self
        tableSelection.dataSource = self
        tableSelection.tableFooterView = UIView()
        tableSelection.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "SelectionView", bundle: nil).instantiate(withOwner: self, options: nil).first as! SelectionView
    }
}

//MARK: - Tableview Delegate Method
extension SelectionView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSelectionValues.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        cell.textLabel!.text = arrSelectionValues[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.delegate?.getSelectionValue(strValue: arrSelectionValues[indexPath.row], index: indexPath.row)
        self.removeFromSuperview()
    }
}

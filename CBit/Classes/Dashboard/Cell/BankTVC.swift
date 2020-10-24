import UIKit

class BankTVC: UITableViewCell {
    
    @IBOutlet weak var labelBankName: UILabel!
    @IBOutlet weak var labelAccountNumber: UILabel!
    @IBOutlet weak var labelIFSCCode: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        //selectionStyle = .none
    }
}

class AddBankFooterView: UITableViewCell {
    
    @IBOutlet weak var buttonAddAcount: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
    }
}

import UIKit

class PassBookTVC: UITableViewCell {

    @IBOutlet weak var beforebalance: UILabel!
    @IBOutlet weak var imageTransaction: UIImageView!
    @IBOutlet weak var labelTransactionName: UILabel!
    @IBOutlet weak var labelData: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var labelAmount: UILabel!
    @IBOutlet weak var labelTDS: UILabel!
    
    @IBOutlet weak var viewbefore: UIView!
    
    @IBOutlet weak var imgapprovedstamp: UIImageView!
    @IBOutlet weak var imggreentick: UIImageView!
    
    
    @IBOutlet weak var vwnormal: UIView!
    @IBOutlet weak var vwflip: UIView!
    @IBOutlet weak var lbldepositedt: UILabel!
    @IBOutlet weak var lbldepositetime: UILabel!
    @IBOutlet weak var lbltransactionid: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)


    }

}

import UIKit

class NotificationTVC: UITableViewCell {

    @IBOutlet weak var labelNotification: UILabel!
    @IBOutlet weak var labelNotificaionData: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
    }

}

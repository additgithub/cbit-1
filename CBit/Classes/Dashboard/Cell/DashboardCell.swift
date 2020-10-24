import UIKit

class DashboardCell: UITableViewCell {

    @IBOutlet weak var lableGameTime: UILabel!
    @IBOutlet weak var labelCurrentTime: UILabel!
    @IBOutlet weak var buttonJoin: UIButton!
    @IBOutlet weak var labelGameType: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lableGameTime.layer.borderWidth = 1
        lableGameTime.layer.borderColor = Define.MAINVIEWCOLOR.cgColor
        labelCurrentTime.layer.borderWidth = 1
        labelCurrentTime.layer.borderColor = Define.BUTTONCOLOR.cgColor
        labelGameType.layer.cornerRadius = labelGameType.frame.height / 2
        labelGameType.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}

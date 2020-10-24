import UIKit

class MyPackageCell: UITableViewCell {

    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var LabelDate: UILabel!
    @IBOutlet weak var labelGameType: UILabel!
    @IBOutlet weak var buttonUpdateContest: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        labelTime.layer.borderColor = Define.MAINVIEWCOLOR.cgColor
        labelTime.layer.borderWidth = 1
        labelGameType.layer.cornerRadius = labelGameType.frame.height / 2
        labelGameType.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

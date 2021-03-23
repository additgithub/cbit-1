import UIKit

class TicketTVC: UITableViewCell {
    
    

    @IBOutlet weak var viewRange: UIView!
    @IBOutlet weak var labelEntryFees: LableWithLightBG!
    @IBOutlet weak var labelTotalTicket: LableWithLightBG!
    @IBOutlet weak var labelWinningAmount: LableWithLightBG!
    @IBOutlet weak var labelMaxWinner: LableWithLightBG!
    @IBOutlet weak var labelMinRange: UILabel!
    @IBOutlet weak var labelMaxRange: UILabel!
    @IBOutlet weak var imageBar: UIImageView!
    @IBOutlet weak var labelBar: UILabel!
    @IBOutlet weak var buttonSelectTicket: UIButton!
    
    @IBOutlet weak var labelLoackedAt: UILabel!
    @IBOutlet weak var labelAnswer: UILabel!
    @IBOutlet weak var labelAmount: UILabel!
//    @IBOutlet weak var buttonViewWinners: UIButton!
//    @IBOutlet weak var labelViewWinners: UILabel!
    
    var longPress = UILongPressGestureRecognizer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewRange.layer.cornerRadius = 5
        viewRange.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}

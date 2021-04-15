

import UIKit

class ThreeSloatTVC: UITableViewCell {

    
    @IBOutlet weak var btnAnsplus: ButtonWithRadius!
    
    @IBOutlet weak var btnAnsMinus: ButtonWithRadius!
    @IBOutlet weak var btnAnsZero: ButtonWithRadius!
    
    @IBOutlet weak var jticketwinning: UILabel!
    @IBOutlet weak var jticketholder: UILabel!
    @IBOutlet weak var perjticket: UILabel!
    
    
    @IBOutlet weak var viewRange: UIView!
    @IBOutlet weak var labelEntryFees: LableWithLightBG!
    @IBOutlet weak var labelTotalTickets: LableWithLightBG!
    @IBOutlet weak var labelWinningAmount: LableWithLightBG!
    @IBOutlet weak var labelMaxWinner: LableWithLightBG!
    
    @IBOutlet weak var labelAnsMinus: UILabel!
    @IBOutlet weak var labelAnsZero: UILabel!
    @IBOutlet weak var labelAnsPlus: UILabel!
    
    @IBOutlet weak var buttonSelectTicket: UIButton!
    @IBOutlet weak var lblpending: UILabel!
    @IBOutlet weak var lbllockstyle: UILabel!
    @IBOutlet weak var lblgameno: UILabel!
    @IBOutlet weak var lbldate: UILabel!
    
    @IBOutlet weak var labelLoackedAt: UILabel!
    @IBOutlet weak var labelAnswer: UILabel!
    @IBOutlet weak var labelAmount: UILabel!
    
    
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}

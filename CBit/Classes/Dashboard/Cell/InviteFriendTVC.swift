import UIKit

class InviteFriendTVC: UITableViewCell {
    
    @IBOutlet weak var imageUser: ImageViewProfile!
    @IBOutlet weak var labelUserName: UILabel!
    @IBOutlet weak var buttonAddFriend: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        buttonAddFriend.layer.cornerRadius = buttonAddFriend.frame.height / 2
        buttonAddFriend.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}

import UIKit

class TicketSloteTVC: UITableViewCell {
    
    @IBOutlet weak var jticketwinning: UILabel!
    
    
    @IBOutlet weak var jticketholder: UILabel!


    @IBOutlet weak var collectionSloat: UICollectionView!
    @IBOutlet weak var viewRange: UIView!
    @IBOutlet weak var labelEntryFees: LableWithLightBG!
    @IBOutlet weak var labelTotalTickets: LableWithLightBG!
    @IBOutlet weak var labelWinningAmount: LableWithLightBG!
    @IBOutlet weak var labelMaxWinner: LableWithLightBG!
    @IBOutlet weak var buttonSelectTicket: UIButton!
    
    
    var arrSloats = [[String: Any]]()
    
    var arrData:[[String: Any]]? {
        didSet {
            guard let arrList = arrData else { return }
            arrSloats = arrList
            collectionSloat.reloadData()
            
//            collectionSloat.frame = CGRect(x: collectionSloat.frame.origin.x,
//                                           y: collectionSloat.frame.origin.y,
//                                           width: collectionSloat.contentSize.width,
//                                           height: collectionSloat.frame.height)
            collectionSloat.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionSloat.delegate = self
        collectionSloat.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}

//MARK: - Collection Delegate Method
extension TicketSloteTVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrSloats.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if arrSloats.count == 2 {
            return CGSize(width: (collectionView.frame.width / 2) - 5.0, height: 40)
        } else {
            return CGSize(width: 50, height: 50)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TicketSloatCVC", for: indexPath) as! TicketSloatCVC
        
        let strDisplayValue = arrSloats[indexPath.row]["displayValue"] as! String
        if arrSloats.count == 2 {
            cell.labelDisplay.text = strDisplayValue
        } else {
            let strMainString = strDisplayValue.replacingOccurrences(of: " ", with: "\n")
            
            cell.labelDisplay.text = strMainString
        }
        
        return cell
    }
}

//MARK: - CollectionView Cell
class TicketSloatCVC: UICollectionViewCell {
    
    @IBOutlet weak var labelDisplay: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}

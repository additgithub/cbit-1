import UIKit

class GameAnswerOneTVC: UITableViewCell {
    
    @IBOutlet weak var vwWithradius: ViewWithRadius!
    @IBOutlet weak var labelEntryFees: LableWithLightBG!
    @IBOutlet weak var labelTotalTickets: LableWithLightBG!
    @IBOutlet weak var labelTotalWinnig: LableWithLightBG!
    @IBOutlet weak var labelMaxWinners: LableWithLightBG!
    
    @IBOutlet weak var buttonAnsMinus: ButtonWithRadius!
    @IBOutlet weak var labelAnsMinus: UILabel!
    @IBOutlet weak var buttonAnsZero: ButtonWithRadius!
    @IBOutlet weak var labelAnsZero: UILabel!
    @IBOutlet weak var buttonAnsPlus: ButtonWithRadius!
    @IBOutlet weak var labelAnsPlus: UILabel!
    
    @IBOutlet weak var labelLoackTime: UILabel!
    @IBOutlet weak var labelAnsLoacked: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

class GameAnswerTwoTVC: UITableViewCell {
    
    @IBOutlet weak var vwWithradius: ViewWithRadius!
    @IBOutlet weak var labelEntryFees: LableWithLightBG!
    @IBOutlet weak var labelTotalTickets: LableWithLightBG!
    @IBOutlet weak var labelTotalWinnig: LableWithLightBG!
    @IBOutlet weak var labelMaxWinners: LableWithLightBG!
    
    @IBOutlet weak var buttonAnsMinus: ButtonWithRadius!
    @IBOutlet weak var labelAnsMinus: UILabel!
    @IBOutlet weak var buttonAnsZero: ButtonWithRadius!
    @IBOutlet weak var labelAnsZero: UILabel!
    @IBOutlet weak var buttonAnsPlus: ButtonWithRadius!
    @IBOutlet weak var labelAnsPlus: UILabel!
    @IBOutlet weak var labelAnsSelected: UILabel!
    
    @IBOutlet weak var buttonLockNow: ButtonWithRadius!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

protocol GameAnswerThreeDelegate {
    func getSloatData(_ sender: GameAnswerThreeTVC, arrData:[[String: Any]])
}

class GameAnswerThreeTVC: UITableViewCell {
    
    @IBOutlet weak var collectionSloat: UICollectionView!
    
    @IBOutlet weak var labelEntryFees: LableWithLightBG!
    @IBOutlet weak var labelTotalTickets: LableWithLightBG!
    @IBOutlet weak var labelTotalWinnig: LableWithLightBG!
    @IBOutlet weak var labelMaxWinners: LableWithLightBG!
    
    @IBOutlet weak var labelAnsSelected: UILabel!
    @IBOutlet weak var buttonLockNow: ButtonWithRadius!
    
    var delegate: GameAnswerThreeDelegate?
    
    var arrSloats = [[String: Any]]()
    
    var arrData:[[String: Any]]? {
        didSet {
            guard let arrList = arrData else { return }
            arrSloats = arrList
            collectionSloat.reloadData()
        }
    }
    var isGameStart = Bool()
    
    var isStart: Bool? {
        didSet {
            guard let isItem = isStart else { return }
            isGameStart = isItem
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionSloat.delegate = self
        collectionSloat.dataSource = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

//MARK: - Collection Delegate Method
extension GameAnswerThreeTVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrSloats.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if arrSloats.count == 2 {
            return CGSize(width: (collectionView.frame.width / 2) - 5.0, height: 50)
        } else {
            return CGSize(width: 50, height: 50)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SloatCVC", for: indexPath) as! SloatCVC
        
        
        let strDisplayValue = arrSloats[indexPath.row]["displayValue"] as! String
        if arrSloats.count == 2 {
            cell.labelDisplayValue.text = strDisplayValue
        } else {
            let strMainString = strDisplayValue.replacingOccurrences(of: " ", with: "\n")
            
            cell.labelDisplayValue.text = strMainString
        }
        
     
        
        
        let isSelected = arrSloats[indexPath.row]["isSelected"] as? Bool ?? false
        if isSelected {
            cell.viewSloats.backgroundColor = UIColor.white
        } else {
            cell.viewSloats.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
        }
        if  !isGameStart
             {
               cell.viewSloats.backgroundColor = UIColor.lightGray
               }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isGameStart {
            for (index,_) in arrSloats.enumerated() {
                if index == indexPath.row {
                    arrSloats[index]["isSelected"] = NSNumber(value: true)
                } else {
                    arrSloats[index]["isSelected"] = NSNumber(value: false)
                }
            }
            collectionSloat.reloadData()
            
            self.delegate?.getSloatData(self, arrData: arrSloats)
        }
    }
}

class GameAnswerThreeLockTVC: UITableViewCell{
    
    @IBOutlet weak var collectionSloat: UICollectionView!
    
    @IBOutlet weak var labelEntryFees: LableWithLightBG!
    @IBOutlet weak var labelTotalTickets: LableWithLightBG!
    @IBOutlet weak var labelTotalWinnig: LableWithLightBG!
    @IBOutlet weak var labelMaxWinners: LableWithLightBG!
    
    @IBOutlet weak var labelAnsSelected: UILabel!
    @IBOutlet weak var labelLockTime: UILabel!
    
    var arrSloats = [[String: Any]]()
    var widthView = CGFloat()
    
    var arrData:[[String: Any]]? {
        didSet {
            guard let arrList = arrData else { return }
            arrSloats = arrList
            collectionSloat.reloadData()
            setSelectedIndex()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionSloat.delegate = self
        collectionSloat.dataSource = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setSelectedIndex() {
        var index = Int()
        for (itemIndex, item) in arrSloats.enumerated() {
            let isSelecte = item["isSelected"] as? Bool ?? false
            if isSelecte {
                index = itemIndex
                break
            }
        }
        
        let indexPath = IndexPath(row: index, section: 0)
        collectionSloat.scrollToItem(at: indexPath,
                                     at: .right,
                                     animated: false)
    }
}

//MARK: - Collection Delegate Method
extension GameAnswerThreeLockTVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrSloats.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if arrSloats.count == 2 {
            return CGSize(width: (widthView / 2) - 5.0, height: 50)
        } else {
            return CGSize(width: 50, height: 50)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SloatCVC", for: indexPath) as! SloatCVC
        
        let strDisplayValue = arrSloats[indexPath.row]["displayValue"] as! String
        if arrSloats.count == 2 {
            cell.labelDisplayValue.text = strDisplayValue
        } else {
            let strMainString = strDisplayValue.replacingOccurrences(of: " ", with: "\n")
            
            cell.labelDisplayValue.text = strMainString
        }
        
        let isSelected = arrSloats[indexPath.row]["isSelected"] as? Bool ?? false
        if isSelected {
            cell.viewSloats.backgroundColor = UIColor.white
        } else {
            cell.viewSloats.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
        }
        
        return cell
    }
}

class SloatCVC: UICollectionViewCell {
    
    
    @IBOutlet weak var labelDisplayValue: UILabel!
    @IBOutlet weak var viewSloats: ViewWithRadius!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}

import UIKit
import RangeSeekSlider

protocol GameAnsRangeDelegate {
    func getRanges(_ sender: GameAnsRangeTVC, minRange: Int, maxRange: Int, selectedRange: Int)
}
class GameAnsRangeTVC: UITableViewCell {

    @IBOutlet weak var labelEntryFees: LableWithLightBG!
    @IBOutlet weak var labelTotalTickets: LableWithLightBG!
    @IBOutlet weak var labelTotalWinnig: LableWithLightBG!
    @IBOutlet weak var labelMaxWinners: LableWithLightBG!
    
    @IBOutlet weak var labelAnsSelected: UILabel!
    @IBOutlet weak var buttonLockNow: ButtonWithRadius!
    
    @IBOutlet weak var sliderAnswer: UISlider!
    
    @IBOutlet weak var labelMinRange: UILabel!
    @IBOutlet weak var labelMaxRange: UILabel!
    
    @IBOutlet weak var imageDummyBar: UIImageView!
    @IBOutlet weak var labelDummyBarVal: UILabel!
    
    @IBOutlet weak var viewUnLocked: UIView!
    @IBOutlet weak var viewLocked: UIView!
    @IBOutlet weak var imageLocked: UIImageView!
    @IBOutlet weak var labelLockedAnswer: UILabel!
    @IBOutlet weak var labelLockedAt: UILabel!
    
    var delegate: GameAnsRangeDelegate?
    var rangeMin = Double()
    var rangeMax = Double()
    var bracketRange = Double()
    var selectedIndex = Double()
    var isGameStart = Bool()
    
    var dictData: [String: Any]? {
        didSet {
            guard let itemData = dictData else {
                return
            }
            
            bracketRange = (itemData["bracketSize"] as? Double ?? 0.0) - 1.0
            print("Bracket Size --> ", bracketRange)
            
            if sliderAnswer.value == 0 {
                sliderAnswer.value = sliderAnswer.minimumValue
            }
            rangeMin = Double(sliderAnswer.minimumValue)
            rangeMax = rangeMin + bracketRange
            
            if isGameStart {
                labelAnsSelected.text = "\(Int(rangeMin)) to \(Int(rangeMax))"
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    @IBAction func sliderAnswer(_ sender: Any) {
        let index = sliderAnswer.value
        if selectedIndex <= Double(index) {
            selectedIndex = Double(sliderAnswer.value)
            if selectedIndex >= (Double(sliderAnswer.maximumValue) - bracketRange) {
                //range = "\(selecteIndex - setDistange) to \(selecteIndex)"max
                rangeMin = selectedIndex - bracketRange
                rangeMax = selectedIndex
            } else {
                //range = "\(selecteIndex) to \(selecteIndex + setDistange)"
                rangeMin = selectedIndex
                rangeMax = selectedIndex + bracketRange
            }
            
            print("Right Move : minRange: \(rangeMin) maxRange: \(rangeMax)")
        } else if selectedIndex >= Double(index){
            selectedIndex = Double(sliderAnswer.value)
            if selectedIndex <= (Double(sliderAnswer.minimumValue) + bracketRange) {
                //range = "\(selecteIndex) to \(selecteIndex + setDistange)"min
                rangeMax = selectedIndex
                rangeMin = selectedIndex + bracketRange
            } else {
                //range = "\(selecteIndex - setDistange) to \(selecteIndex)"
                
                rangeMax = selectedIndex
                rangeMin = selectedIndex - bracketRange
            }
            
            print("Left Move  : minRange: \(rangeMin) maxRange: \(rangeMax)")
            
        }
        print("Answer Range is : minRange: \(round(rangeMin)) maxRange: \(round(rangeMax))")
        self.delegate?.getRanges(self, minRange: Int(round(rangeMin)), maxRange: Int(round(rangeMax)), selectedRange: Int(sliderAnswer.value))
    }
    
}


class GameAnsRangeLockTVC: UITableViewCell {
    
    @IBOutlet weak var labelEntryFees: LableWithLightBG!
    @IBOutlet weak var labelTotalTickets: LableWithLightBG!
    @IBOutlet weak var labelTotalWinnig: LableWithLightBG!
    @IBOutlet weak var labelMaxWinners: LableWithLightBG!
    
    @IBOutlet weak var buttonAnsSelected: ButtonWithRadius!
    @IBOutlet weak var labelAnsSelected: UILabel!
    @IBOutlet weak var sliderAnswer: UISlider!
    
    @IBOutlet weak var labelMinValue: UILabel!
    @IBOutlet weak var labelMaxValue: UILabel!
    @IBOutlet weak var labelLockTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
}

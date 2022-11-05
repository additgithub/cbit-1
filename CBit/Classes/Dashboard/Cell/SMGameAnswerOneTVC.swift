//
//  SMGameAnswerOneTVC.swift
//  CBit
//
//  Created by Nirmal Bodar on 12/02/21.
//  Copyright © 2021 Bhavik Kothari. All rights reserved.
//

import UIKit

class SMGameAnswerOneTVC: UITableViewCell {

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

class SMGameAnswerTwoTVC: UITableViewCell {
    
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

protocol SMGameAnswerThreeDelegate {
    func getSloatData(_ sender: SMGameAnswerThreeTVC, arrData:[[String: Any]])
}

class SMGameAnswerThreeTVC: UITableViewCell {
    
    @IBOutlet weak var collectionSloat: UICollectionView!
    
    @IBOutlet weak var labelEntryFees: LableWithLightBG!
    @IBOutlet weak var labelTotalTickets: LableWithLightBG!
    @IBOutlet weak var labelTotalWinnig: LableWithLightBG!
    @IBOutlet weak var labelMaxWinners: LableWithLightBG!
    
    @IBOutlet weak var labelAnsSelected: UILabel!
    @IBOutlet weak var buttonLockNow: ButtonWithRadius!
    @IBOutlet weak var imgselected: UIImageView!
    
    var delegate: SMGameAnswerThreeDelegate?
    
    var arrSloats = [[String: Any]]()
    
    var arrData:[[String: Any]]? {
        didSet {
            guard let arrList = arrData else { return }
            arrSloats = arrList
            collectionSloat.reloadData()
            self.viewDidLayoutSubviews()
        }
    }
    var isGameStart = Bool()
    
    var isStart: Bool? {
        didSet {
            guard let isItem = isStart else { return }
            isGameStart = isItem
        }
    }
    
     func viewDidLayoutSubviews() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let section = 0
        let lastItemIndex = self.collectionSloat.numberOfItems(inSection: section) - 1
        let indexPath:NSIndexPath = NSIndexPath.init(item: lastItemIndex, section: section)
        self.collectionSloat.scrollToItem(at: indexPath as IndexPath, at: .right, animated: true)
        }
       }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionSloat.delegate = self
        collectionSloat.dataSource = self
//        collectionSloat.layer.cornerRadius = 10
//        collectionSloat.layer.borderWidth = 2
//        collectionSloat.layer.borderColor = UIColor.black.cgColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

//MARK: - Collection Delegate Method
extension SMGameAnswerThreeTVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SMSloatCVC", for: indexPath) as! SMSloatCVC
        
        
        let strDisplayValue = arrSloats[indexPath.row]["displayValue"] as! String
        if arrSloats.count == 2 {
            cell.labelDisplayValue.text = strDisplayValue
        }
      
//             if strDisplayValue == "Draw" {
//                 let strMainString = strDisplayValue.replacingOccurrences(of: " ", with: "\n")
//                 cell.labelDisplayValue.text = strMainString
//                 cell.labelDisplayValue.isHidden = false
//                 cell.img.isHidden = true
//             }
//             else
//             {
                 cell.labelDisplayValue.isHidden = true
                 cell.img.isHidden = false
                 let localimg = loadImageFromDocumentDirectory(nameOfImage: arrSloats[indexPath.row]["displayValue"] as! String)
 //                cell.img.image = makeTransparent(image: localimg)
                 cell.img.image =  localimg//.imageByMakingWhiteBackgroundTransparent()
       //      }
         
        
        
        let isSelected = arrSloats[indexPath.row]["isSelected"] as? Bool ?? false
        if isSelected {
           // cell.viewSloats.backgroundColor = UIColor.white
            cell.viewSloats.layer.borderColor = UIColor.black.cgColor
            cell.viewSloats.layer.borderWidth = 2
           
        } else {
            //cell.viewSloats.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
            cell.viewSloats.layer.borderColor = UIColor.black.cgColor
            cell.viewSloats.layer.borderWidth = 0
        }
        if  !isGameStart
             {
               cell.viewSloats.backgroundColor = UIColor.clear
               }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        //Where elements_count is the count of all your items in that
        //Collection view...
        if collectionView == collectionSloat {
            let cellCount = CGFloat(arrSloats.count)

            //If the cell count is zero, there is no point in calculating anything.
            if cellCount <= 4 {
                let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
                let cellWidth = flowLayout.itemSize.width + flowLayout.minimumInteritemSpacing

                //20.00 was just extra spacing I wanted to add to my cell.
                let totalCellWidth = cellWidth*cellCount + 20.00 * (cellCount-1)
                let contentWidth = collectionView.frame.size.width - collectionView.contentInset.left - collectionView.contentInset.right

                if (totalCellWidth < contentWidth) {
                    //If the number of cells that exists take up less room than the
                    //collection view width... then there is an actual point to centering them.

                    //Calculate the right amount of padding to center the cells.
                    let padding = (contentWidth - totalCellWidth) / 2.0
                    return UIEdgeInsets(top: 0, left: padding, bottom: 0, right: padding)
                } else {
                    //Pretty much if the number of cells that exist take up
                    //more room than the actual collectionView width, there is no
                    // point in trying to center them. So we leave the default behavior.
                    return UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 40)
                }
            }

        }
        return UIEdgeInsets.zero
    }
    
    func loadImageFromDocumentDirectory(nameOfImage : String) -> UIImage {
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        if let dirPath = paths.first{
            let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent(nameOfImage)
            let image    = UIImage(contentsOfFile: imageURL.path)
            return image!
        }
        return UIImage.init(named: "default.png")!
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

class SMGameAnswerThreeLockTVC: UITableViewCell{
    
    @IBOutlet weak var collectionSloat: UICollectionView!
    
    @IBOutlet weak var labelEntryFees: LableWithLightBG!
    @IBOutlet weak var labelTotalTickets: LableWithLightBG!
    @IBOutlet weak var labelTotalWinnig: LableWithLightBG!
    @IBOutlet weak var labelMaxWinners: LableWithLightBG!
    
    @IBOutlet weak var labelAnsSelected: UILabel!
    @IBOutlet weak var labelLockTime: UILabel!
    @IBOutlet weak var imgselected: UIImageView!
    
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
//        collectionSloat.layer.cornerRadius = 10
//        collectionSloat.layer.borderWidth = 2
//        collectionSloat.layer.borderColor = UIColor.black.cgColor
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
extension SMGameAnswerThreeLockTVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SMSloatCVC", for: indexPath) as! SMSloatCVC
        
        let strDisplayValue = arrSloats[indexPath.row]["displayValue"] as! String
        if arrSloats.count == 2 {
            cell.labelDisplayValue.text = strDisplayValue
        }
       
//            if strDisplayValue == "Draw" {
//                let strMainString = strDisplayValue.replacingOccurrences(of: " ", with: "\n")
//                cell.labelDisplayValue.text = strMainString
//                cell.labelDisplayValue.isHidden = false
//                cell.img.isHidden = true
//            }
//            else
//            {
                cell.labelDisplayValue.isHidden = true
                cell.img.isHidden = false
                let localimg = loadImageFromDocumentDirectory(nameOfImage: arrSloats[indexPath.row]["displayValue"] as! String)
//                cell.img.image = makeTransparent(image: localimg)
                cell.img.image =  localimg//.imageByMakingWhiteBackgroundTransparent()
       //     }
        
       
        
        let isSelected = arrSloats[indexPath.row]["isSelected"] as? Bool ?? false
//        if isSelected {
//            cell.viewSloats.backgroundColor = UIColor.white
//        } else {
//            cell.viewSloats.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//        }
        if isSelected {
           // cell.viewSloats.backgroundColor = UIColor.white
            cell.viewSloats.layer.borderColor = UIColor.black.cgColor
            cell.viewSloats.layer.borderWidth = 2
           
        } else {
            //cell.viewSloats.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
            cell.viewSloats.layer.borderColor = UIColor.black.cgColor
            cell.viewSloats.layer.borderWidth = 0
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        //Where elements_count is the count of all your items in that
        //Collection view...
        if collectionView == collectionSloat {
            let cellCount = CGFloat(arrSloats.count)

            //If the cell count is zero, there is no point in calculating anything.
            if cellCount <= 4 {
                let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
                let cellWidth = flowLayout.itemSize.width + flowLayout.minimumInteritemSpacing

                //20.00 was just extra spacing I wanted to add to my cell.
                let totalCellWidth = cellWidth*cellCount + 20.00 * (cellCount-1)
                let contentWidth = collectionView.frame.size.width - collectionView.contentInset.left - collectionView.contentInset.right

                if (totalCellWidth < contentWidth) {
                    //If the number of cells that exists take up less room than the
                    //collection view width... then there is an actual point to centering them.

                    //Calculate the right amount of padding to center the cells.
                    let padding = (contentWidth - totalCellWidth) / 2.0
                    return UIEdgeInsets(top: 0, left: padding, bottom: 0, right: padding)
                } else {
                    //Pretty much if the number of cells that exist take up
                    //more room than the actual collectionView width, there is no
                    // point in trying to center them. So we leave the default behavior.
                    return UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 40)
                }
            }

        }
        return UIEdgeInsets.zero
    }
    
    func loadImageFromDocumentDirectory(nameOfImage : String) -> UIImage {
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        if let dirPath = paths.first{
            let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent(nameOfImage)
            let image    = UIImage(contentsOfFile: imageURL.path)
            return image!
        }
        return UIImage.init(named: "default.png")!
    }
}

class SMSloatCVC: UICollectionViewCell {
    
    
    @IBOutlet weak var labelDisplayValue: UILabel!
    @IBOutlet weak var viewSloats: ViewWithRadius!
    @IBOutlet weak var img: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}

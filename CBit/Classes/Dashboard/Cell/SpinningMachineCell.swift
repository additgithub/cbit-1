//
//  SpinningMachineCell.swift
//  CBit
//
//  Created by Nirmal Bodar on 11/02/21.
//  Copyright © 2021 Bhavik Kothari. All rights reserved.
//

import UIKit

class SpinningMachineCell: UITableViewCell {

    @IBOutlet weak var jticketwinning: UILabel!
    
    
    @IBOutlet weak var jticketholder: UILabel!


    @IBOutlet weak var collectionSloat: UICollectionView!
    @IBOutlet weak var viewRange: UIView!
    @IBOutlet weak var labelEntryFees: LableWithLightBG!
    @IBOutlet weak var labelTotalTickets: LableWithLightBG!
    @IBOutlet weak var labelWinningAmount: LableWithLightBG!
    @IBOutlet weak var labelMaxWinner: LableWithLightBG!
    @IBOutlet weak var buttonSelectTicket: UIButton!
    
    @IBOutlet weak var lblpending: UILabel!
    @IBOutlet weak var lbllockstyle: UILabel!
    @IBOutlet weak var lblgameno: UILabel!
    
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
extension SpinningMachineCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SpinningMachineSlotCell", for: indexPath) as! SpinningMachineSlotCell
        
        let strDisplayValue = arrSloats[indexPath.row]["displayValue"] as! String
        
            if strDisplayValue == "Draw" {
                let strMainString = strDisplayValue.replacingOccurrences(of: " ", with: "\n")
                cell.labelDisplay.text = strMainString
                cell.labelDisplay.isHidden = false
                cell.img.isHidden = true
            }
            else
            {
                cell.labelDisplay.isHidden = true
                cell.img.isHidden = false
                let localimg = loadImageFromDocumentDirectory(nameOfImage: arrSloats[indexPath.row]["displayValue"] as! String)
              //  let scaledimg = localimg.scaleImage(toSize: CGSize(width: 50, height: 50))
//                cell.img.image = makeTransparent(image: localimg)
                cell.img.image =  localimg.imageByMakingWhiteBackgroundTransparent()
              //  cell.img.sd_setImage(with: URL(string: arrSloats[indexPath.row]["ImageUrl"] as! String), completed: nil)
            }
//            if indexPath.row == 1 {
//                let strMainString = strDisplayValue.replacingOccurrences(of: " ", with: "\n")
//                cell.labelDisplay.text = strMainString
//                cell.labelDisplay.isHidden = false
//                cell.img.isHidden = true
//            }
//            else
//            {
//                cell.labelDisplay.isHidden = true
//                cell.img.isHidden = false
//                let localimg = loadImageFromDocumentDirectory(nameOfImage: arrSloats[indexPath.row]["displayValue"] as! String)
////                cell.img.image = makeTransparent(image: localimg)
//                cell.img.image =  localimg.imageByMakingWhiteBackgroundTransparent()
//            }
  
        
        return cell
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

//MARK: - CollectionView Cell
class SpinningMachineSlotCell: UICollectionViewCell {
    
    @IBOutlet weak var labelDisplay: UILabel!
    @IBOutlet weak var img: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}


extension UIImage {
    func scaleImage(toSize newSize: CGSize) -> UIImage? {
        var newImage: UIImage?
        let newRect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height).integral
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        if let context = UIGraphicsGetCurrentContext(), let cgImage = self.cgImage {
            context.interpolationQuality = .high
            let flipVertical = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: newSize.height)
            context.concatenate(flipVertical)
            context.draw(cgImage, in: newRect)
            if let img = context.makeImage() {
                newImage = UIImage(cgImage: img)
            }
            UIGraphicsEndImageContext()
        }
        return newImage
    }
}

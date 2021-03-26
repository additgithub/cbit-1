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
    @IBOutlet weak var lbldate: UILabel!
    
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
          //  collectionSloat.reloadData()
            self.viewDidLayoutSubviews()
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
    
    func viewDidLayoutSubviews() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let section = 0
        let lastItemIndex = self.collectionSloat.numberOfItems(inSection: section) - 1
        let indexPath:NSIndexPath = NSIndexPath.init(item: lastItemIndex, section: section)
        //    self.scrollToIndexPath(path: indexPath)
        self.collectionSloat.scrollToItem(at: indexPath as IndexPath, at: .right, animated: true)
//            self.collectionSloat.layoutSubviews()
        //    self.autoScroll()
        }


       }
    
    func autoScroll () {
        let co = collectionSloat.contentOffset.x
        let no = co + 1

        UIView.animate(withDuration: 0.001, delay: 0, options: .curveEaseInOut, animations: { [weak self]() -> Void in
            self?.collectionSloat.contentOffset = CGPoint(x: no, y: 0)
            }) { [weak self](finished) -> Void in
                self?.autoScroll()
        }
    }
    
    var scrollPoint: CGPoint?
    var endPoint: CGPoint?
    var scrollTimer: Timer?
    var scrollingUp = false

    func scrollToIndexPath(path: NSIndexPath) {
        let atts = self.collectionSloat!.layoutAttributesForItem(at: path as IndexPath)
        self.endPoint = CGPoint(x: 0, y: atts!.frame.origin.y - self.collectionSloat!.contentInset.top)
        self.scrollPoint = self.collectionSloat!.contentOffset
        self.scrollingUp = self.collectionSloat!.contentOffset.y > self.endPoint!.y

        self.scrollTimer?.invalidate()
        self.scrollTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(scrollTimerTriggered(timer:)), userInfo: nil, repeats: true)
    }

    @objc func scrollTimerTriggered(timer: Timer) {
        let dif = abs(self.scrollPoint!.y - self.endPoint!.y) / 1000.0
        let modifier: CGFloat = self.scrollingUp ? -30 : 30

        self.scrollPoint = CGPoint(x: self.scrollPoint!.x, y: self.scrollPoint!.y + (modifier * dif))
        self.collectionSloat?.contentOffset = self.scrollPoint!

        if self.scrollingUp && self.collectionSloat!.contentOffset.y <= self.endPoint!.y {
            self.collectionSloat!.contentOffset = self.endPoint!
            timer.invalidate()
        } else if !self.scrollingUp && self.collectionSloat!.contentOffset.y >= self.endPoint!.y {
            self.collectionSloat!.contentOffset = self.endPoint!
            timer.invalidate()
        }
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

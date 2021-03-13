//
//  SpinningMachineVC.swift
//  CBit
//
//  Created by Nirmal Bodar on 10/02/21.
//  Copyright © 2021 Bhavik Kothari. All rights reserved.
//

import UIKit

class slotcell: UICollectionViewCell {
    @IBOutlet weak var imgImage: UIImageView!
    var timerfade=Timer()
    @IBOutlet weak var lbldraw: UILabel!
    
    override class func awakeFromNib() {
        
    }
    
    
}

class SpinningMachineVC: UIViewController {
    
    @IBOutlet var collection_slot: UICollectionView!
    @IBOutlet weak var collection_original: UICollectionView!
    @IBOutlet weak var fadevw: UIView!
    @IBOutlet weak var collheight: NSLayoutConstraint!
    @IBOutlet weak var lbltime: UILabel!
    @IBOutlet weak var animationvw: UIView!
    
    var timerautoscroll=Timer()
    var timerfade=Timer()
    var w:CGFloat=0.0
    var slotarr  = [UIImage]()
    var randomarr  = [UIImage]()
    var itemarr  = [UIImage]()
    var originalarr  = [UIImage]()
    var timecount = 0
    var speed:Double = 50
    var LoadSpeed:Double = 0.0001
    var startTimer: Timer?
    var StartSecond = 30
    var storeimage = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let width = (view.frame.width-20)/5
        
        let coln = [collection_slot,collection_original]
        
        for cln in coln {
            cln?.layer.cornerRadius = 10
            cln?.layer.borderColor = UIColor.black.cgColor
            cln?.layer.borderWidth = 3
            
            let layout = cln?.collectionViewLayout as! UICollectionViewFlowLayout
            layout.itemSize = CGSize(width: width, height: width)
            // collheight.constant = (view.frame.width-20) /* 5*5 */
            collheight.constant = (view.frame.width-20) - width  /* 5*4 */
            // collheight.constant = (view.frame.width-20) - (width*2) /* 5*3 */
        }
        
        //collection_slot.semanticContentAttribute = .forceRightToLeft
        
        
        for _ in 1..<50
        {
            for dict in storeimage //Define.Globalimagearr
            {
                itemarr.append(loadImageFromDocumentDirectory(nameOfImage: dict["name"] as! String))
            }

        }
        
        randomarr = itemarr
        
//        for _ in 1..<10
//        {
//            for dict in Define.Globalimagearr {
//                randomarr.append(loadImageFromDocumentDirectory(nameOfImage: dict["name"] as! String))
//            }
//        }
        
        
        
//        for _ in 1..<80 {
//            randomarr.append(UIImage(named: "bananas")!)
//            randomarr.append(UIImage(named: "cherry")!)
//            randomarr.append(UIImage(named: "mango")!)
//            randomarr.append(UIImage(named: "strawberry")!)
//            randomarr.append(UIImage(named: "apple")!)
//            randomarr.append(UIImage(named: "bananas")!)
//
//        }
     
//        for _ in 1..<10 {
//            itemarr.append(UIImage(named: "Batman")!)
//            itemarr.append(UIImage(named: "Doraemon")!)
//            itemarr.append(UIImage(named: "Mario")!)
//            itemarr.append(UIImage(named: "Nobi Nobita")!)
//            itemarr.append(UIImage(named: "bananas")!)
//            itemarr.append(UIImage(named: "cherry")!)
//            itemarr.append(UIImage(named: "mango")!)
//            itemarr.append(UIImage(named: "strawberry")!)
//            itemarr.append(UIImage(named: "apple")!)
//            itemarr.append(UIImage(named: "strawberry")!)
//        }
        
        for _ in 1..<10 {
            originalarr.append(UIImage(named: "bananas")!)
            originalarr.append(UIImage(named: "cherry")!)
            originalarr.append(UIImage(named: "mango")!)
            originalarr.append(UIImage(named: "strawberry")!)
            originalarr.append(UIImage(named: "apple")!)
            originalarr.append(UIImage(named: "bananas")!)
            originalarr.append(UIImage(named: "cherry")!)
        }
        
       slotarr = itemarr
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
    
//    func randomImgPicker() {
//            let randomNumber = arc4random_uniform(UInt32(backgroundImages.count)) // generating random number
//            backgroundImage.image = UIImage(named: backgroundImages[randomNumber])
//        }
    
    override func viewDidAppear(_ animated: Bool) {
      //  configAutoscrollTimer()
        configFadeTimer()
        configStartTimer()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        deconfigAutoscrollTimer()
        deconfigFadeTimer()
        startTimer?.invalidate()
    }
    
    func configAutoscrollTimer()
    {
        
        timerautoscroll=Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(SpinningMachineVC.autoScrollView), userInfo: nil, repeats: true)
        RunLoop.current.add(self.timerautoscroll, forMode: .common)
    }
    
    func configFadeTimer()
    {
        timerfade=Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(SpinningMachineVC.FedeinOut), userInfo: nil, repeats: true)
        RunLoop.current.add(self.timerfade, forMode: .common)
    }
    
    func configStartTimer()
    {
        startTimer=Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(SpinningMachineVC.HandleStartTimer), userInfo: nil, repeats: true)
        RunLoop.current.add(self.startTimer!, forMode: .common)
    }
    
    func deconfigAutoscrollTimer()
    {
        timerautoscroll.invalidate()
    }
    
    func deconfigFadeTimer()
    {
        timerfade.invalidate()
    }
    
    @objc func HandleStartTimer()
    {
        StartSecond = StartSecond-1
        if StartSecond == 0 {
         
            collection_original.isHidden = false
            collection_slot.isHidden = true
           // collection_original.animShow()
            startTimer?.invalidate()
            deconfigAutoscrollTimer()
        }
//        if StartSecond == 25 {
//            animationvw.animShow()
//        }
        lbltime.text = "\(StartSecond)"
        
       
    }
    
    @objc func FedeinOut()
    {
        timecount+=1
        fadevw.fadeIn()
        fadevw.fadeOut()
        
       
        if timecount == 10 {
            slotarr = randomarr
            deconfigFadeTimer()
            configAutoscrollTimer()
        }
        
        slotarr.shuffle()
      //  collection_slot.scrollToLast()
        collection_slot.reloadData()
    }
    
    @objc func autoScrollView()
    {
        let initailPoint = CGPoint(x: 0,y :w)
        if(LoadSpeed > 0.70 || speed < 10){
            speed = 10
        }else if(LoadSpeed > 0.50){
            LoadSpeed = (LoadSpeed * 1.005)
        }else{
        LoadSpeed = (LoadSpeed * 1.09)
        }
        speed = speed-LoadSpeed
        if(speed <= 0){
            speed = 0
            deconfigAutoscrollTimer()
        }
        var LessSpeed = speed-(speed*2)
        if(speed >= 47){
            LessSpeed = 60
        }
//        LessSpeed = -5
        print("LOADSPPED",LoadSpeed)
        print("LessSpeed",LessSpeed)
        print("SPPED",speed)
        if __CGPointEqualToPoint(initailPoint, collection_slot.contentOffset)
        {
            if w<collection_slot.contentSize.height
            {
                w += CGFloat(LessSpeed)
            }
            else
            {
                w = -self.view.frame.size.height
            }
            
            let offsetPoint = CGPoint(x: 0,y :w)
            collection_slot.contentOffset=offsetPoint
        }
        else
        {
            w=collection_slot.contentOffset.y
        }
    }
    
}


extension SpinningMachineVC:UICollectionViewDataSource,UICollectionViewDelegate ,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collection_slot {
            return slotarr.count
        }
        if collectionView == collection_original {
            return originalarr.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "slotcell", for: indexPath) as! slotcell
        
        if collectionView == collection_slot {
            cell.imgImage.image = slotarr[indexPath.row].imageByMakingWhiteBackgroundTransparent()
            return cell
        }
        if collectionView == collection_original {
            cell.imgImage.image = originalarr[indexPath.row].imageByMakingWhiteBackgroundTransparent()
            return cell
        } else {
            return cell
        }
    }
    
}

extension UIView {
    func fadeIn() {
        // Move our fade out code from earlier
        UIView.animate(withDuration: 0.5, delay: 0.1, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 0.8 // Instead of a specific instance of, say, birdTypeLabel, we simply set [thisInstance] (ie, self)'s alpha
            }, completion: nil)
    }

    func fadeOut() {
        UIView.animate(withDuration: 0.5, delay: 0.1, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.alpha = 0.0
            }, completion: nil)
    }
}


extension UICollectionView {
    func scrollToLast() {
        guard numberOfSections > 0 else {
            return
        }

        let lastSection = numberOfSections - 1

        guard numberOfItems(inSection: lastSection) > 0 else {
            return
        }

        let lastItemIndexPath = IndexPath(item: numberOfItems(inSection: lastSection) - 1,
                                          section: lastSection)
        scrollToItem(at: lastItemIndexPath, at: .bottom, animated: true)
    }
}


extension UIView{
    func animShow(){
//        UIView.animate(withDuration:1 , delay: 0, options: [.curveLinear],
//                       animations: {
//                        self.center.y += self.bounds.height
//                        self.layoutIfNeeded()
//        }, completion: nil)
       self.isHidden = false
        UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.5,
        initialSpringVelocity: 0.5, options: [], animations:
        {
           // self.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: nil)
//        self.isHidden = false
    }
    func animHide(){
        UIView.animate(withDuration: 2, delay: 0, options: [.curveLinear],
                       animations: {
                        self.center.y += self.bounds.height
                        self.layoutIfNeeded()

        },  completion: {(_ completed: Bool) -> Void in
        self.isHidden = true
            })
    }
}

extension UIImage {
    func imageByMakingWhiteBackgroundTransparent() -> UIImage? {

        
        let image = UIImage(data: self.jpegData(compressionQuality: 1.0) ?? Data())
        guard image?.imageAsset != nil else {
            return UIImage()
        }
//        if images == nil {
//            return UIImage()
//        }
        let rawImageRef: CGImage = (image?.cgImage) ?? UIImage().cgImage!

        let colorMasking: [CGFloat] = [222, 255, 222, 255, 222, 255]
        UIGraphicsBeginImageContext(image?.size ?? CGSize.zero);

        let maskedImageRef = rawImageRef.copy(maskingColorComponents: colorMasking)
        UIGraphicsGetCurrentContext()?.translateBy(x: 0.0,y: image?.size.height ?? 0)
        UIGraphicsGetCurrentContext()?.scaleBy(x: 1.0, y: -1.0)
        UIGraphicsGetCurrentContext()?.draw(maskedImageRef!, in: CGRect.init(x: 0, y: 0, width: image?.size.width ?? 0, height: image?.size.height ?? 0))
        let result = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return result

    }

}

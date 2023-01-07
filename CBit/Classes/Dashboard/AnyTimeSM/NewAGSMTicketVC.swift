//
//  NewAGSMTicketVC.swift
//  CBit
//
//  Created by Mobcast on 22/06/22.
//  Copyright © 2022 Bhavik Kothari. All rights reserved.
//

import UIKit
import UserNotifications
import MarqueeLabel
import EventKit

class NewAGSMTicketVC: UIViewController {
    //MARK: - Properties
    
    @IBOutlet weak var btnselectall: UIButton!
 //   @IBOutlet weak var labelRemainingTime: UILabel!
    @IBOutlet weak var collectionviewtickets: UICollectionView!
    private var arrRandomNumbers = [Int]()
    var arrBarcketColor = [BracketData]()
    var startTimer: Timer?
    var timer: Timer?
    var seconds = Int()

    @IBOutlet weak var labelContestName: UILabel!
    @IBOutlet weak var tableTickets: UITableView!
    @IBOutlet weak var labelSelectedCount: UILabel!
    @IBOutlet weak var labelPurchasedAmount: UILabel!
    @IBOutlet weak var labelPBAmount: UILabel!
    @IBOutlet weak var buttonPay: UIButton!
    @IBOutlet weak var labelPay: UILabel!
    
  //  @IBOutlet weak var labelMarquee: MarqueeLabel!
    //Constraint
    @IBOutlet weak var constraintPaymentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var constraintSelectionViewHeight: NSLayoutConstraint!
    
    //View Amount
    @IBOutlet weak var viewAmountMain: UIView!
    @IBOutlet weak var viewAmount: UIView!
    @IBOutlet weak var labelUtilizedbalance: UILabel!
    @IBOutlet weak var labelwidrawableBalance: UILabel!
    @IBOutlet weak var labelTotalBalance: UILabel!
    @IBOutlet weak var buttonAmountOk: UIButton!
    @IBOutlet weak var buttonAmountCancel: UIButton!
    
    @IBOutlet weak var vwmain: UIView!
    @IBOutlet weak var collection_original: UICollectionView!
    @IBOutlet weak var fadevw: UIView!
    @IBOutlet weak var collection_items: UICollectionView!
    
    private var arrSelectedTikets = [[String: Any]]()
    
    var dictContest = [String: Any]()
    var isFromMyTickets = Bool()
    private var isDataLoaded = Bool()
    private var isFromButtonClick = Bool()
    
    
   // private var dictContestDetail = [String: Any]()
    private var arrTicket = [[String: Any]]()
    
    private var noOfSelected = Int()
    private var totalSelectedAmount = Double()
    
    private var isGetContest = Bool()
    private var isJoinContest = Bool()
    
    var isFromLink = Bool()
   // var storeimage = [[String:Any]]()
    var itemarr  = [UIImage]()
    var timerfade=Timer()
    
    private  let reuseidentifier = "slotspinningcell"
    @IBOutlet weak var constraintCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var lblgamename: UILabel!
    var AnyTimedictContest = [[String: Any]]()
    var AnyTimeGameList = [[String: Any]]()
    var totalgame = 0
    var currentindex = 0
    var smitemarr = [[String: Any]]()
    var smitemarrcopy = [[String: Any]]()
    //MARK: - Default Method
    override func viewDidLoad() {
        super.viewDidLoad()

        tableTickets.rowHeight = UITableView.automaticDimension
        tableTickets.tableFooterView = UIView()
      //  UNUserNotificationCenter.current().delegate = self
        if !MyModel().isConnectedToInternet() {
            Alert().showTost(message: Define.ERROR_INTERNET,
                             viewController: self)
        } else {
           // getContestDetail()
            getSpinningitemcategory()
        }
        
       // setReminder()
        constraintPaymentViewHeight.constant = 50
        constraintSelectionViewHeight.constant = 0
        
        

    }
    
    func loadImageFromDocumentDirectory(nameOfImage : String) -> UIImage {
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        if let dirPath = paths.first{
            let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent(nameOfImage)
            let image    = UIImage(contentsOfFile: imageURL.path)
            return image ?? UIImage()
        }
        return UIImage.init(named: "default.png")!
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      
        
        let pbAmount = Define.USERDEFAULT.value(forKey: "PBAmount") as? Double ?? 0.0
        let sbAmount = Define.USERDEFAULT.value(forKey: "SBAmount") as? Double ?? 0.0
        
        let totalAmount = pbAmount + sbAmount
        
        labelPBAmount.text = MyModel().getCurrncy(value: totalAmount)
        
        if isFromButtonClick {
            setSelectedData()
        }
        
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(self.handelNotifcation(_:)),
//                                               name: .onContestLiveUpdate,
//                                               object: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
      //  configAutoscrollTimer()
      //  configFadeTimer()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
       // deconfigFadeTimer()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    func configFadeTimer()
    {
        timerfade=Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(SpinningMachineTicketVC.FedeinOut), userInfo: nil, repeats: true)
      //  RunLoop.current.add(self.timerfade, forMode: .common)
    }
    func deconfigFadeTimer()
    {
        timerfade.invalidate()
    }
    @objc func FedeinOut()
    {
        fadevw.fadeIn()
        fadevw.fadeOut()
        
        itemarr.shuffle()
        collection_original.reloadData()
    }
    
    func setReminder() {
        if Define.APPDELEGATE.eventStore == nil {
            Define.APPDELEGATE.eventStore = EKEventStore()
        }
        
        Define.APPDELEGATE.eventStore!.requestAccess(to: .reminder, completion: { (granted, error) in
            if granted {
                print("Access Granted")
                
            } else {
                print("Access to store not granted")
                print(error?.localizedDescription ?? "Some Thing Is Missing.")
            }
        })
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
//        buttonAmountCancel.layer.borderColor = UIColor.black.cgColor
//        buttonAmountCancel.layer.borderWidth = 1
//        buttonAmountCancel.layer.masksToBounds = true
    }
    
//    @objc func handelNotifcation(_ notification: Notification) {
//        print("Contest Data: \(notification.userInfo!)")
//
//        if  notification.userInfo != nil {
//            let dictData = notification.userInfo
//            let arrData = dictData!["contest"] as! [[String: Any]]
//            let strContestId = "\(dictContest["id"]!)"
//
//            for (_, item) in arrData.enumerated() {
//                let strSelectedContestId = "\(item["contestId"]!)"
//                let strContestPriceId = "\(item["contestPriceId"]!)"
//                if strContestId == strSelectedContestId {
//                    for (arrIndex, arrItem) in arrTicket.enumerated() {
//                        let strSelectedContestPriceId = "\(arrItem["contestPriceId"]!)"
//                        if strContestPriceId == strSelectedContestPriceId {
//                            arrTicket[arrIndex]["maxWinners"] = item["maxWinners"]!
//                            arrTicket[arrIndex]["totalTickets"] = item["totalTickets"]!
//                            arrTicket[arrIndex]["totalWinnings"] = item["totalWinnings"]!
//
//                            let indexPath = IndexPath(row: arrIndex, section: 0)
//                            tableTickets.reloadRows(at: [indexPath], with: .none)
//                        }
//                    }
//                } else {
//                    break
//                }
//            }
//        }
//    }
    private func setStartTimer() {
      
        startTimer = Timer.scheduledTimer(timeInterval:0.5,
                                          target: self,
                                          selector: #selector(handleStartTimer),
                                          userInfo: nil,
                                          repeats: true)
    }
    
    @objc func handleStartTimer() {
      
//                updateColors()
//              SetRandomNumber()
//        collectionviewtickets.reloadData()

    }
    private func setDetail() {
        
        labelContestName.text = dictContest["name"] as? String ?? "No Name"
        
        let width = (view.frame.width-20)/5
        
        let coln = [collection_original]
        
        for cln in coln {
            cln?.layer.cornerRadius = 10
            cln?.layer.borderColor = UIColor.black.cgColor
            cln?.layer.borderWidth = 3
            
            let layout = cln?.collectionViewLayout as! UICollectionViewFlowLayout
            layout.itemSize = CGSize(width: width, height: width-10)
    
        }
        
        let gamelevel = dictContest["rows"] as? Int ?? 3
      
            if gamelevel == 3 {
                // constraintCollectionViewHeight.constant = (view.frame.width-20) /* 5*5 */
             //   constraintCollectionViewHeight.constant = (view.frame.width-20) - width  /* 5*4 */
                 constraintCollectionViewHeight.constant = (view.frame.width) - (width*2) - 30 /* 5*3 */
            } else if gamelevel == 4 {
                // constraintCollectionViewHeight.constant = (view.frame.width-20) /* 5*5 */
                constraintCollectionViewHeight.constant = (view.frame.width) - width - 40  /* 5*4 */
               //  constraintCollectionViewHeight.constant = (view.frame.width) - (width*2) /* 5*3 */
            } else if gamelevel == 5 {
                 constraintCollectionViewHeight.constant = (view.frame.width) - 50 /* 5*5 */
             //   constraintCollectionViewHeight.constant = (view.frame.width-20) - width  /* 5*4 */
               //  constraintCollectionViewHeight.constant = (view.frame.width) - (width*2) /* 5*3 */
            }

        
 //       DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { // Change `2.0` to the desired number of seconds.
           // Code you want to be delayed
            self.itemarr = [UIImage]()
            for dict in self.AnyTimedictContest[self.currentindex]["items"] as! [[String:Any]] {
                self.itemarr.append(self.loadImageFromDocumentDirectory(nameOfImage: dict["name"] as! String))
                    }
            
                    for _ in 1..<3
                    {
                        self.itemarr.append(contentsOf: self.itemarr)
                    }
       //     self.collection_original.reloadData()
 //       }
        
        arrTicket = AnyTimeGameList
//        let strMarquee = dictContestDetail["scrollerContent"] as? String ?? "No String"
//        labelMarquee.text = strMarquee
        for (index, item) in arrTicket.enumerated() {
            var dictData = arrTicket[index]
            dictData["isPurchased"] = item["isPurchased"] as? Bool ?? false
            arrTicket[index] = dictData
        }
        
        let slotes = arrTicket[0]["slotes"] as? String ?? ""
        smitemarr = []
        smitemarrcopy = []
        var itemsarr = self.AnyTimedictContest[currentindex]["items"] as? [[String:Any]] ?? []

        if slotes == "wdw" {
            for (innerindex, _) in itemsarr.enumerated()
                {
                if innerindex == 0 {
                    itemsarr.shuffle()
                    smitemarr.append(itemsarr[innerindex])
                }
                else if innerindex == 1 {
                    let dic = [
                       "categoryID" : "0",
                       "created_at" : "",
                       "id" : "0",
                       "image" : "Draw",
                       "name" : "Draw",
                       "status" : "1",
                       "updated_at" : ""
                    ]
                   smitemarr.append(dic)
                }
                else if innerindex == 4 {
                    break
                }
                else
                {
                   // let indexrandom: Int = Int(arc4random_uniform(UInt32(itemsarr.count)))
                    smitemarr.append(itemsarr[innerindex])
                }
            }
        }
        else
        {
//            for (index, _) in arrTicket.enumerated() {
//                var dictData = arrTicket[index]
            for (innerindex, _) in itemsarr.enumerated()
                {
//                if innerindex == 1 {
//                     let dic = [
//                        "categoryID" : "0",
//                        "created_at" : "",
//                        "id" : "0",
//                        "image" : "Draw",
//                        "name" : "Draw",
//                        "status" : "1",
//                        "updated_at" : ""
//                     ]
//                    smitemarr.append(dic)
//                 }
                if innerindex == 0 {
                    itemsarr.shuffle()
                    smitemarr.append(itemsarr[innerindex])
                }
                else if innerindex == 3 {
                    break
                }
                else
                {
                   // let indexrandom: Int = Int(arc4random_uniform(UInt32(itemsarr.count)))
                    smitemarr.append(itemsarr[innerindex])
                }
                
//                dictData["smdict"] = ""
//                arrTicket[index] = dictData
//
            }
        }
        smitemarrcopy = smitemarr
        smitemarr.removeLast()
      //  print("➭Tickets: \(arrTicket)")
        tableTickets.reloadData()
        isDataLoaded = true
        itemarr.shuffle()
        collection_original.reloadData()
        collection_items.reloadData()
    }
    
    //MARK: - Button Method
    
    @IBAction func left_click(_ sender: UIButton) {
        if (currentindex > 0) {
            currentindex = currentindex-1
            self.lblgamename.text = self.AnyTimedictContest[currentindex]["name"] as? String
          //  self.getContestDetail(index: currentindex)
            setDetail()
        }
    }
    @IBAction func right_click(_ sender: UIButton) {
        if (currentindex < totalgame-1) {
            currentindex = currentindex + 1
            self.lblgamename.text = self.AnyTimedictContest[currentindex]["name"] as? String
           // self.getContestDetail(index: currentindex)
            setDetail()
        }
    }
    @IBAction func shuffle_click(_ sender: UIButton) {
        setDetail()
    }
    
    @IBAction func buttonBack(_ sender: Any) {
        NotificationCenter.default.removeObserver(self)
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func buttonPay(_ sender: Any) {
        
        
        
         if buttonPay.titleLabel?.text == "Play" {
             if !MyModel().isConnectedToInternet() {
                 Alert().showTost(message: Define.ERROR_INTERNET,
                                  viewController: self)
             } else if noOfSelected == 0 {
                 Alert().showTost(message: "Select Ticket",
                                  viewController: self)
             } else {
                 viewAmountMain.isHidden = false
                 let pbAmount = Define.USERDEFAULT.value(forKey: "PBAmount") as? Double ?? 0.0
                 //let tbAmount = Define.USERDEFAULT.value(forKey: "TBAmount") as? Double ?? 0.0
                 if totalSelectedAmount <= pbAmount {
                     
//                     let NewAGSMPlayVC = self.storyboard?.instantiateViewController(withIdentifier: "NewAGSMPlayVC") as! NewAGSMPlayVC
//                  //  AGSMPlayVC.dictContest = dictContestDetail
//                     NewAGSMPlayVC.isFromNotification = false
//                     NewAGSMPlayVC.arrSelectedTikets = arrSelectedTikets
//                     NewAGSMPlayVC.AnyTimedictContest = AnyTimedictContest
//                     self.navigationController?.pushViewController(NewAGSMPlayVC, animated: true)
                     
                     labelUtilizedbalance.text = String(format: "₹%.2f", totalSelectedAmount) //"₹ \()"
                     labelwidrawableBalance.text = "₹ 0.0"
                     labelTotalBalance.text = String(format: "₹%.2f", totalSelectedAmount) //"₹ \(totalSelectedAmount)"
                 } else {
                     let cutUtilized = totalSelectedAmount - pbAmount
                     labelUtilizedbalance.text = String(format: "₹%.2f", pbAmount) //"₹ \(pbAmount)"
                     labelwidrawableBalance.text = String(format: "₹%.2f", cutUtilized) //"₹ \(cutUtilized)"
                     labelTotalBalance.text = String(format: "₹%.2f", totalSelectedAmount) //"₹ \(totalSelectedAmount)"
                 }
             }
         } else {
             let pbAmount = Define.USERDEFAULT.value(forKey: "PBAmount") as? Double ?? 0.0
             let sbAmount = Define.USERDEFAULT.value(forKey: "SBAmount") as? Double ?? 0.0
 
             let cutUtilized = totalSelectedAmount - (pbAmount + sbAmount)
             let storyBoard : UIStoryboard = UIStoryboard(name: "Dashboard", bundle:nil)
             let paymentVC = storyBoard.instantiateViewController(withIdentifier: "AddPaymentVC") as! AddPaymentVC
             paymentVC.isFromTicket = true
             paymentVC.addAmount = cutUtilized
             paymentVC.isFromLink = isFromLink
             self.navigationController?.pushViewController(paymentVC, animated: true)
         }
     }
    
    
    @IBAction func btn_selectall(_ sender: Any) {
        
        var i = 0
        for i in i..<arrTicket.count
        
        {
         
        let index = i
        
            
        let isPurchased = arrTicket[index]["isPurchased"] as! Bool
        
        let dictData = arrTicket[index]
        let ticketID = dictData["contestpriceID"] as? Int ?? 0
        
            
        if arrSelectedTikets.count > 0 {
            
            for (indexNo, item) in arrSelectedTikets.enumerated() {
                let selectedTicketID = item["contestpriceID"] as? Int ?? 0
                
                if ticketID == selectedTicketID {
                    
                    arrTicket[index]["isPurchased"] = NSNumber(value: !isPurchased)
                    arrSelectedTikets[indexNo]["isPurchased"] = NSNumber(value: !isPurchased)
                    break
                } else if indexNo == arrSelectedTikets.count - 1 {
                    
                    arrTicket[index]["isPurchased"] = NSNumber(value: !isPurchased)
                    arrSelectedTikets.append(arrTicket[index])
                    break
                }
            }
            
        } else {
            arrTicket[index]["isPurchased"] = NSNumber(value: !isPurchased)
            arrSelectedTikets.append(arrTicket[index])
        }
        
        var totalSelected = Int()
        var totalAmount = Double()
        
        for item in arrSelectedTikets {
            let isSelected = item["isPurchased"] as! Bool
            if isSelected {
                totalSelected = totalSelected + 1
                let ticketAmount = item["amount"] as? Double ?? 0
                totalAmount = totalAmount + ticketAmount
            }
        }
        
        noOfSelected = totalSelected
        totalSelectedAmount = Double(totalAmount)
        
        labelSelectedCount.text = "\(totalSelected) Contest Selected"
        labelPurchasedAmount.text = String(format: "₹%.2f", totalAmount)//"₹\(totalAmount)"
        
        setSelectedData()
        isFromButtonClick = true
        
        let indexPath = IndexPath(row: index, section: 0)
        tableTickets.reloadRows(at: [indexPath], with: .none)
        
        }
    }
    @IBAction func buttonAmountOK(_ sender: UIButton) {
      //  joinContest()
        let AGSMPlayVC = self.storyboard?.instantiateViewController(withIdentifier: "NewAGSMPlayVC") as! NewAGSMPlayVC
    AGSMPlayVC.dictContest = self.dictContest
       AGSMPlayVC.isFromNotification = false
    AGSMPlayVC.arrSelectedTikets = self.arrSelectedTikets
    AGSMPlayVC.AnyTimedictContest = self.AnyTimedictContest[self.currentindex]["items"] as? [[String:Any]] ?? []
    AGSMPlayVC.smitemarr = self.smitemarr
    AGSMPlayVC.smitemarrcopy = self.smitemarrcopy

        self.navigationController?.pushViewController(AGSMPlayVC, animated: true)
    }
    
    @IBAction func buttonAmountCancel(_ sender: UIButton) {
        viewAmountMain.isHidden = true
      //  self.view.sendSubviewToBack(vwmain)
    }
    @IBAction func buttonInfo(_ sender: Any) {
        
        let ticketInfo = ViewTicketInfo.instanceFromNib() as! ViewTicketInfo
        ticketInfo.frame = view.bounds
        view.addSubview(ticketInfo)
    }
}

extension NewAGSMTicketVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return arrRandomNumbers.count
        if collectionView == collection_items {
            return smitemarr.count
        }
        else if collectionView == collection_original
        {
            return itemarr.count
        }
        else
        {
            return 0
        }
            
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: view.frame.width / 4, height: 25)
//    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
     //   print(collectionView)
        if collectionView == collection_items {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SpinningMachineSlotCell", for: indexPath) as! SpinningMachineSlotCell
            let strDisplayValue = smitemarr[indexPath.row]["name"] as! String
            
//                if strDisplayValue == "Draw" {
//                    let strMainString = strDisplayValue.replacingOccurrences(of: " ", with: "\n")
//                    cell.labelDisplay.text = strMainString
//                    cell.labelDisplay.isHidden = false
//                    cell.img.isHidden = true
//                }
//                else
//                {
                    cell.labelDisplay.isHidden = true
                    cell.img.isHidden = false
                    let localimg = loadImageFromDocumentDirectory(nameOfImage: smitemarr[indexPath.row]["name"] as! String)
                  //  let scaledimg = localimg.scaleImage(toSize: CGSize(width: 50, height: 50))
                    cell.img.image = localimg
                   // cell.img.image =  localimg.imageByMakingWhiteBackgroundTransparent()
                 //   cell.img.sd_setImage(with: URL(string: arrSloats[indexPath.row]["ImageUrl"] as! String), completed: nil)
           //     }
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
        else if collectionView == collection_original
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseidentifier, for: indexPath) as! slotspinningcell
            //let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "slotcell", for: indexPath) as! slotcell
          //  cell.imgImage.image = makeTransparent(image: itemarr[indexPath.row])
            cell.imgImage.image = (itemarr[indexPath.row])//.imageByMakingWhiteBackgroundTransparent()
            return cell
        }
        else
        {
            return UICollectionViewCell()
        }
      
    }
}


//MARK: - TableView Delegate Method
extension NewAGSMTicketVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrTicket.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
            let ticketCell = tableView.dequeueReusableCell(withIdentifier: "NewSpinningMachineCell") as! NewSpinningMachineCell
            self.view.layoutIfNeeded()
            
         //   let isAlreadyPurchase = arrTicket[indexPath.row]["isPurchased"] as? Bool ?? false
            
           // ticketCell.lblpending.text = "\(arrTicket[indexPath.row]["players_played"]!) Played /\(arrTicket[indexPath.row]["pending"]!) Pending"
            
//            if isAlreadyPurchase {
//
//                ticketCell.buttonSelectTicket.alpha = 0.6
//                ticketCell.buttonSelectTicket.isEnabled = false
//                ticketCell.buttonSelectTicket.setImage(#imageLiteral(resourceName: "ic_checked"), for: .normal)
//            } else {
                let isPurchased = arrTicket[indexPath.row]["isPurchased"] as? Bool ?? false
                view.layoutIfNeeded()
                ticketCell.buttonSelectTicket.alpha = 1
                ticketCell.buttonSelectTicket.isEnabled = true
                if isPurchased {
                   //  btnselectall.setImage(#imageLiteral(resourceName: "ic_checked"), for: .normal)
                    ticketCell.buttonSelectTicket.setImage(#imageLiteral(resourceName: "ic_checked"), for: .normal)
                } else {
                   //  btnselectall.setImage(#imageLiteral(resourceName: "ic_unchecked"), for: .normal)
                    ticketCell.buttonSelectTicket.setImage(#imageLiteral(resourceName: "ic_unchecked"), for: .normal)
                }
                view.layoutIfNeeded()
         //   }
            
            let strAmonut = "\(arrTicket[indexPath.row]["amount"] as? Double ?? 0.0)"
            let test = Double(strAmonut) ?? 0.00
            ticketCell.labelEntryFees.text = String(format: "₹ %.02f", test)
            //ticketCell.labelEntryFees.text = "₹\(MyModel().getNumbers(value: Double(strAmonut)!))"
//            let strTickets = "\(arrTicket[indexPath.row]["totalTickets"] as? Int ?? 0)"
//            ticketCell.labelTotalTickets.text = "\(MyModel().getNumbers(value: Double(strTickets)!))"
            ticketCell.labelTotalTickets.text = "\(arrTicket[indexPath.row]["no_of_players"]!)"
        
        let strWinning = "\(arrTicket[indexPath.row]["winningAmount"]!)"
        ticketCell.labelWinningAmount.text = strWinning
        
        let strno_of_winners = "\(arrTicket[indexPath.row]["no_of_winners"]!)"
        ticketCell.labelMaxWinner.text = strno_of_winners
            
            
            ticketCell.buttonSelectTicket.addTarget(self,
                                                 action: #selector(buttonSelection(_:)),
                                                 for: .touchUpInside)
            ticketCell.buttonSelectTicket.tag = indexPath.row
            self.view.layoutIfNeeded()
            return ticketCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        let userVC = self.storyboard?.instantiateViewController(withIdentifier: "UserListVC") as! UserListVC
//        userVC.dictContestData = dictContest
//        userVC.dictTicketData = arrTicket[indexPath.row]
//        userVC.isfromanytimegame = true
//        self.navigationController?.pushViewController(userVC, animated: true)
    }
    
    //MARK: - TableView Button Method
    @objc func buttonSelection(_ sender: UIButton) {
        
        let index = sender.tag
        
        let isPurchased = arrTicket[index]["isPurchased"] as! Bool
        
        let dictData = arrTicket[index]
        let ticketID = dictData["contestpriceID"] as? Int ?? 0
        
        if arrSelectedTikets.count > 0 {
            
            for (indexNo, item) in arrSelectedTikets.enumerated() {
                let selectedTicketID = item["contestpriceID"] as? Int ?? 0
                
                if ticketID == selectedTicketID {
                    
                    arrTicket[index]["isPurchased"] = NSNumber(value: !isPurchased)
                    arrSelectedTikets[indexNo]["isPurchased"] = NSNumber(value: !isPurchased)
                    break
                } else if indexNo == arrSelectedTikets.count - 1 {
                    
                    arrTicket[index]["isPurchased"] = NSNumber(value: !isPurchased)
                    arrSelectedTikets.append(arrTicket[index])
                    break
                }
            }

        } else {
            arrTicket[index]["isPurchased"] = NSNumber(value: !isPurchased)
            arrSelectedTikets.append(arrTicket[index])
        }
        
        var totalSelected = Int()
        var totalAmount = Double()
        
        for item in arrSelectedTikets {
            
            let isSelected = item["isPurchased"] as! Bool
            if isSelected {
                totalSelected = totalSelected + 1
                let ticketAmount = item["amount"] as? Double ?? 0
                totalAmount = totalAmount + ticketAmount
                
            }
            

        }
        
        noOfSelected = totalSelected
        totalSelectedAmount = Double(totalAmount)
        
        labelSelectedCount.text = "Selected \(totalSelected)"
        labelPurchasedAmount.text = String(format: "₹%.2f", totalAmount)//"₹\(totalAmount)"
        
        setSelectedData()
        isFromButtonClick = true
        
        let indexPath = IndexPath(row: index, section: 0)
        tableTickets.reloadRows(at: [indexPath], with: .none)
        //tableTickets.reloadData()
    }
    
    func setSelectedData() {
        self.view.layoutIfNeeded()
        if noOfSelected == 0 {
            constraintPaymentViewHeight.constant = 50
            constraintSelectionViewHeight.constant = 0
        } else {
            constraintPaymentViewHeight.constant = 50
            constraintSelectionViewHeight.constant = 25
        }
        self.view.layoutIfNeeded()
        
        let pbAmount = Define.USERDEFAULT.value(forKey: "PBAmount") as? Double ?? 0.0
        let sbAmount = Define.USERDEFAULT.value(forKey: "SBAmount") as? Double ?? 0.0
        
        let totalAmount = pbAmount + sbAmount
        
        if Double(totalSelectedAmount) > totalAmount {
            labelPBAmount.textColor = UIColor.red
            labelPay.text = "Add to wallet"
            buttonPay.setTitle("Add to wallet", for: .normal)
        } else {
            labelPBAmount.textColor = Define.MAINVIEWCOLOR2
            labelPBAmount.textColor = UIColor.green
            labelPay.text = "Play"
            buttonPay.setTitle("Play", for: .normal)
        }
    }
    
   
    
}

//MARK: - API
extension NewAGSMTicketVC {
    
    func getSpinningitemcategory() {
        Loading().showLoading(viewController: self)
        let parameter: [String: Any] = [:]
        let strURL = Define.APP_URL + Define.API_SPINNINGITEMCATEGORY
        print("Parameter: \(parameter)\nURL: \(strURL)")
        
        let jsonString = MyModel().getJSONString(object: parameter)
        let encriptString = MyModel().encrypting(strData: jsonString!, strKey: Define.KEY)
        let strbase64 = encriptString.toBase64()
        
        SwiftAPI().postMethodSecure(stringURL: strURL,
                                    parameters: ["data":strbase64!],
                                    header: Define.USERDEFAULT.value(forKey: "AccessToken") as? String,
                                    auther: Define.USERDEFAULT.value(forKey: "UserID") as? String)
        { (result, error) in
            if error != nil {
                Loading().hideLoading(viewController: self)
                print("Error: \(error!)")
                self.isGetContest = true
                self.isJoinContest = false
                //self.retry()
             //   self.getContestDetail(index: )
            } else {
                Loading().hideLoading(viewController: self)
                print("Result: \(result!)")
                let status = result!["statusCode"] as? Int ?? 0
                if status == 200 {
                    let dic = result!["content"] as? [String: Any]
                    let arrlst = dic!["lst"] as? [[String: Any]] ?? []
                    if arrlst.count > 0 {
                        self.AnyTimedictContest = arrlst
                        self.AnyTimedictContest.shuffle()
                        self.lblgamename.text = self.AnyTimedictContest[0]["name"] as? String
                        self.totalgame = self.AnyTimedictContest.count
                        self.getAnyTimeGameContestList()
                    }
                   
                  //  print(self.dictContestDetail)
                   
                   
                } else if status == 401 {
                    Define.APPDELEGATE.handleLogout()
                } else {
                    Alert().showAlert(title: "Error",
                                      message: result!["message"] as?  String ?? "No Message.",
                                      viewController: self)
                }
            }
        }
    }
    
    func getAnyTimeGameContestList() {
        Loading().showLoading(viewController: self)
        let parameter: [String: Any] = ["isSpinningMachine":"1","game_type":"spinning-machine"]
        let strURL = Define.APP_URL + Define.API_GETANYTIMEGAMELIST
        print("Parameter: \(parameter)\nURL: \(strURL)")
        
        let jsonString = MyModel().getJSONString(object: parameter)
        let encriptString = MyModel().encrypting(strData: jsonString!, strKey: Define.KEY)
        let strbase64 = encriptString.toBase64()
        
        SwiftAPI().postMethodSecure(stringURL: strURL,
                                    parameters: ["data":strbase64!],
                                    header: Define.USERDEFAULT.value(forKey: "AccessToken") as? String,
                                    auther: Define.USERDEFAULT.value(forKey: "UserID") as? String)
        { [self] (result, error) in
            if error != nil {
                Loading().hideLoading(viewController: self)
                print("Error: \(error!)")
                self.isGetContest = true
                self.isJoinContest = false
                //self.retry()
             //   self.getContestDetail(index: in)
            } else {
                Loading().hideLoading(viewController: self)
                print("Result: \(result!)")
                let status = result!["statusCode"] as? Int ?? 0
                if status == 200 {
                    let arr = result!["content"] as? [[String: Any]] ?? []
                    if arr.count > 0 {
                        self.AnyTimeGameList = arr
                       // self.getContestDetail(index: 0)
                   
//                        self.dictContestDetail = result!["content"] as! [String: Any]
                        self.dictContest = AnyTimeGameList[0]
                     //   print(self.dictContestDetail)
                        self.setDetail()
                    }
                   
                  //  print(self.dictContestDetail)
                   
                                    } else if status == 401 {
                    Define.APPDELEGATE.handleLogout()
                } else {
                    Alert().showAlert(title: "Error",
                                      message: result!["message"] as?  String ?? "No Message.",
                                      viewController: self)
                }
            }
        }
    }
    
    func joinContest() {
        Loading().showLoading(viewController: self)
        var arrSelectedcontestid = [String]()
        var arrSelectedticketsIds = [String]()
        var randomlistarr = [[String:Any]]()
        var listarr = [[String:Any]]()
        for (_,dict) in smitemarr.enumerated() {
            let singledict = ["Image":dict["image"],
                              "Item":dict["name"],
                              "id":dict["id"],
            ]
            listarr.append(singledict as [String : Any])
        }
        
        let singledict = ["Image":smitemarrcopy[smitemarrcopy.count-1]["image"],
                          "Item":smitemarrcopy[smitemarrcopy.count-1]["name"],
                          "id":smitemarrcopy[smitemarrcopy.count-1]["id"],
        ]
        randomlistarr.append(singledict as [String : Any])
        
        for item in arrSelectedTikets {
            let isSelected = item["isPurchased"] as! Bool
            if isSelected {
                let strID = "\(item["contestpriceID"]!)"
                arrSelectedticketsIds.append(strID)
                
                let strcontestId = "\(item["contestId"]!)"
                arrSelectedcontestid.append(strcontestId)
            }
        }
        
        let strSelectedID = arrSelectedcontestid.joined(separator: ",")
        let strSelectedID1 = arrSelectedticketsIds.joined(separator: ",")
        
        let parameter:[String: Any] = ["contest_id":strSelectedID ,
                                       "tickets": strSelectedID1,"list":MyModel().getJSONString(object: listarr)!,"Randomlist":MyModel().getJSONString(object: randomlistarr)!]
        let strURL = Define.APP_URL + Define.API_ANYTIMEJOIN_CONTEST
        
        print("Parameter: \(parameter)\nURL: \(strURL)")
        
        let jsonString = MyModel().getJSONString(object: parameter)
        let encriptString = MyModel().encrypting(strData: jsonString!, strKey: Define.KEY)
        let strbase64 = encriptString.toBase64()
        
        SwiftAPI().postMethodSecure(stringURL: strURL,
                                    parameters: ["data":strbase64!],
                                    header: Define.USERDEFAULT.value(forKey: "AccessToken") as? String,
                                    auther: Define.USERDEFAULT.value(forKey: "UserID") as? String)
        {  (result, error) in
            if error != nil {
                
                Loading().hideLoading(viewController: self)
                print("Error: \(error!.localizedDescription)")
                self.isGetContest = false
                self.isJoinContest = true
                //self.retry()
                self.joinContest()
                
                
            } else {
                Loading().hideLoading(viewController: self)
                print("Result: \(result!)")
                let status = result!["statusCode"] as? Int ?? 0
                if status == 200 {
                    
                    let dictData = result!["content"] as! [String: Any]
                    
                    Define.USERDEFAULT.set(dictData["pbAmount"] as? Double ?? 0.0, forKey: "PBAmount")
                    Define.USERDEFAULT.set(dictData["sbAmount"] as? Double ?? 0.0, forKey: "SBAmount")
                    Define.USERDEFAULT.set(dictData["tbAmount"] as? Double ?? 0.0, forKey: "TBAmount")
                    
                    let GameNumberarr = result!["GameNumber"] as! [[String: Any]]
                    let arrSelectedTiketscopy = self.arrSelectedTikets
                    
                    for (_,dictouter) in GameNumberarr.enumerated() {
                        for (indexinner,dictinner) in arrSelectedTiketscopy.enumerated() {
                            if dictouter["contestPriceId"] as! Int == dictinner["contestpriceID"] as! Int {
                                self.arrSelectedTikets[indexinner]["game_played"] = dictouter["game_no"] as! Int
                            }
                        }
                    }
                 //   DispatchQueue.main.async { [self] in
                        let AGSMPlayVC = self.storyboard?.instantiateViewController(withIdentifier: "NewAGSMPlayVC") as! NewAGSMPlayVC
                    AGSMPlayVC.dictContest = self.dictContest
                       AGSMPlayVC.isFromNotification = false
                    AGSMPlayVC.arrSelectedTikets = self.arrSelectedTikets
                    AGSMPlayVC.AnyTimedictContest = self.AnyTimedictContest[self.currentindex]["items"] as? [[String:Any]] ?? []
                    AGSMPlayVC.smitemarr = self.smitemarr
                        self.navigationController?.pushViewController(AGSMPlayVC, animated: true)
                 //   }
                   
                  //  NotificationCenter.default.post(name: .paymentUpdated, object: nil)
                  //  self.getContestDetail(isfromtimer: true, isStart: 0)
                 //   configStartTimer()
//                    self.createReminder(strTitle: self.dictContest["name"] as? String ?? "No Name",strDate: self.dictContest["startDate"] as! String)
//                    let paymentVC = self.storyboard?.instantiateViewController(withIdentifier: "PaymentSummaryVC") as! PaymentSummaryVC
//                    paymentVC.isFromLink = self.isFromLink
//                    self.navigationController?.pushViewController(paymentVC, animated: true)
                    
                    //UpComingContest
//                    NotificationCenter.default.post(name: .upComingContest, object: nil)
//
//                    //MyContest
//                    NotificationCenter.default.post(name: .myContest, object: nil)
//                     NotificationCenter.default.post(name: .getAllspecialContest, object: nil)
                    
                } else if status == 401 {
                    Define.APPDELEGATE.handleLogout()
                } else {
                    Alert().showAlert(title: "Error",
                                      message: result!["message"] as? String ?? "No Message",
                                      viewController: self)
                }
            }
        }
    }
    
//    func getContestDetail(index:Int) {
//        Loading().showLoading(viewController: self)
//        let parameter: [String: Any] = ["contest_id": AnyTimeGameList[index]["contestID"] ?? "0"]
//        let strURL = Define.APP_URL + Define.API_CONTEST_DETAIL
//        print("Parameter: \(parameter)\nURL: \(strURL)")
//
//        let jsonString = MyModel().getJSONString(object: parameter)
//        let encriptString = MyModel().encrypting(strData: jsonString!, strKey: Define.KEY)
//        let strbase64 = encriptString.toBase64()
//
//        SwiftAPI().postMethodSecure(stringURL: strURL,
//                                    parameters: ["data":strbase64!],
//                                    header: Define.USERDEFAULT.value(forKey: "AccessToken") as? String,
//                                    auther: Define.USERDEFAULT.value(forKey: "UserID") as? String)
//        { (result, error) in
//            if error != nil {
//                Loading().hideLoading(viewController: self)
//                print("Error: \(error!)")
//                self.isGetContest = true
//                self.isJoinContest = false
//                //self.retry()
//                self.getContestDetail(index: index)
//            } else {
//                Loading().hideLoading(viewController: self)
//                print("Result: \(result!)")
//                let status = result!["statusCode"] as? Int ?? 0
//                if status == 200 {
//                   // self.dictContestDetail = result!["content"] as! [String: Any]
//                    self.dictContest = result!["content"] as! [String: Any]
//                    self.setDetail()
//                } else if status == 401 {
//                    Define.APPDELEGATE.handleLogout()
//                } else {
//                    Alert().showAlert(title: "Error",
//                                      message: result!["message"] as?  String ?? "No Message.",
//                                      viewController: self)
//                }
//            }
//        }
//    }
//    @objc func handleTimer() {
//        if  seconds > 0{
//            seconds -= 1
//            labelRemainingTime.text = "Game starts in \(timeString(time: TimeInterval(seconds)))"
//        } else {
//            if timer != nil {
//                timer!.invalidate()
//                timer = nil
//            }
//            labelRemainingTime.text = "00:00:00"
//        }
//    }
    
    func timeString(time: TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let secounds = Int(time) % 60
        
        let strTime = String(format: "%02i:%02i:%02i", hours, minutes, secounds)
        return strTime
    }
    
    func getDateForRemider(contestDate: String) -> Date {
     
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let startDate = dateFormater.date(from: contestDate)
        
        let calendar = NSCalendar.current
        let minusDate = calendar.date(byAdding: .second, value: -180, to: startDate!)
        
        return minusDate!
    }
  
//    func joinContest() {
//        Loading().showLoading(viewController: self)
//        var arrSelected = [String]()
//
//        for item in arrSelectedTikets {
//            let isSelected = item["isPurchased"] as! Bool
//            if isSelected {
//                let strID = "\(item["contestPriceId"]!)"
//                arrSelected.append(strID)
//            }
//        }
//
//        let strSelectedID = arrSelected.joined(separator: ",")
//
//        let parameter:[String: Any] = ["contest_id": dictContest["id"]!,
//                                       "tickets": strSelectedID]
//        let strURL = Define.APP_URL + Define.API_JOIN_CONTEST
//
//        print("Parameter: \(parameter)\nURL: \(strURL)")
//
//        let jsonString = MyModel().getJSONString(object: parameter)
//        let encriptString = MyModel().encrypting(strData: jsonString!, strKey: Define.KEY)
//        let strbase64 = encriptString.toBase64()
//
//        SwiftAPI().postMethodSecure(stringURL: strURL,
//                                    parameters: ["data":strbase64!],
//                                    header: Define.USERDEFAULT.value(forKey: "AccessToken") as? String,
//                                    auther: Define.USERDEFAULT.value(forKey: "UserID") as? String)
//        { (result, error) in
//            if error != nil {
//
//                Loading().hideLoading(viewController: self)
//                print("Error: \(error!.localizedDescription)")
//                self.isGetContest = false
//                self.isJoinContest = true
//                //self.retry()
//                self.joinContest()
//
//
//            } else {
//                Loading().hideLoading(viewController: self)
//                print("Result: \(result!)")
//                let status = result!["statusCode"] as? Int ?? 0
//                if status == 200 {
//
//                    let dictData = result!["content"] as! [String: Any]
//
//                    Define.USERDEFAULT.set(dictData["pbAmount"] as? Double ?? 0.0, forKey: "PBAmount")
//                    Define.USERDEFAULT.set(dictData["sbAmount"] as? Double ?? 0.0, forKey: "SBAmount")
//                    Define.USERDEFAULT.set(dictData["tbAmount"] as? Double ?? 0.0, forKey: "TBAmount")
//
//                    NotificationCenter.default.post(name: .paymentUpdated, object: nil)
//
//                    self.createReminder(strTitle: self.dictContest["name"] as? String ?? "No Name",strDate: self.dictContest["startDate"] as! String)
//                    let paymentVC = self.storyboard?.instantiateViewController(withIdentifier: "PaymentSummaryVC") as! PaymentSummaryVC
//                    paymentVC.isFromLink = self.isFromLink
//                    self.navigationController?.pushViewController(paymentVC, animated: true)
//
//                    //UpComingContest
//                    NotificationCenter.default.post(name: .upComingContest, object: nil)
//
//                    //MyContest
//                    NotificationCenter.default.post(name: .myContest, object: nil)
//                     NotificationCenter.default.post(name: .getAllspecialContest, object: nil)
//
//                } else if status == 401 {
//                    Define.APPDELEGATE.handleLogout()
//                } else {
//                    Alert().showAlert(title: "Error",
//                                      message: result!["message"] as? String ?? "No Message",
//                                      viewController: self)
//                }
//            }
//        }
//    }
    
    func createReminder(strTitle: String, strDate: String) {
        var isRemiderSet = Bool()
        
        for item in arrTicket {
            let isPrc = item["isPurchased"] as? Bool ?? false
            if isPrc {
                isRemiderSet = true
                break
            } else {
                isRemiderSet = false
            }
        }
        if isRemiderSet {
            return
        } else {
//            let reminder = EKReminder(eventStore: Define.APPDELEGATE.eventStore!)
//
//            reminder.title = strTitle
//            reminder.calendar = Define.APPDELEGATE.eventStore?.defaultCalendarForNewReminders()
//            let reminderDate = MyModel().getDateForRemider(contestDate: strDate)
//            print("Date: \(reminderDate)")
//            let alarm = EKAlarm(absoluteDate: reminderDate)
//            reminder.addAlarm(alarm)
//            do {
//
//                try Define.APPDELEGATE.eventStore?.save(reminder, commit: true)
//                print("Timer Set")
//            } catch {
//                print("Reminder failed with error \(error.localizedDescription)")
//            }
            
            let center = UNUserNotificationCenter.current()

            let content = UNMutableNotificationContent()
               content.title = strTitle
               content.body = "Your game starts soon, Hurry!!!!"
               content.categoryIdentifier = "alarm"
          //  content.categoryIdentifier = Define.PLAYGAME
             //  content.userInfo = ["customData": "fizzbuzz"]
               content.sound = UNNotificationSound.default

               let reminderDate = MyModel().getDateForRemider(contestDate: strDate)
                let timeInterval = reminderDate.timeIntervalSinceNow
               let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)

               let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
               center.add(request)
            
        }
    }
    
}



//MARK: - Alert Contollert
//extension NewAGSMTicketVC {
//    func retry() {
//        let alertController = UIAlertController(title: Define.ERROR_TITLE,
//                                                message: Define.ERROR_SERVER,
//                                                preferredStyle: .alert)
//        let buttonRetry = UIAlertAction(title: "Retry",
//                                        style: .default)
//        { _ in
//            if self.isGetContest {
//                self.getContestDetail(index: self.currentindex)
//            } else if self.isJoinContest {
//                self.joinContest()
//            }
//        }
//        let cancel = UIAlertAction(title: "Cancel",
//                                   style: .cancel,
//                                   handler: nil)
//        alertController.addAction(cancel)
//        alertController.addAction(buttonRetry)
//        self.present(alertController,
//                     animated: true,
//                     completion: nil)
//    }
//}


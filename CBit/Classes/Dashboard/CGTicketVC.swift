//
//  CGTicketVC.swift
//  CBit
//
//  Created by Emp-Mac-1 on 25/01/21.
//  Copyright © 2021 Bhavik Kothari. All rights reserved.
//

import UIKit
import UserNotifications
import MarqueeLabel
import EventKit

class CGTicketVC: UIViewController {
    //MARK: - Properties
    
    @IBOutlet weak var btnselectall: UIButton!
   // @IBOutlet weak var labelRemainingTime: UILabel!
    @IBOutlet weak var collectionviewtickets: UICollectionView!
    private var arrRandomNumbers = [Int]()
    var arrBarcketColor = [BracketData]()
    var startTimer: Timer?
    var timer: Timer?
    var seconds = Int()

    @IBOutlet weak var labelContestName: UILabel!
    @IBOutlet weak var tableTickets: UITableView!
    @IBOutlet weak var labelSelectedCount: UILabel!
 //   @IBOutlet weak var labelPurchasedAmount: UILabel!
  //  @IBOutlet weak var labelPBAmount: UILabel!
    @IBOutlet weak var buttonPay: UIButton!
  //  @IBOutlet weak var labelPay: UILabel!
    
    @IBOutlet weak var labelMarquee: MarqueeLabel!
    //Constraint
    @IBOutlet weak var constraintPaymentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var constraintSelectionViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var lblgamename: UILabel!
    //View Amount
//    @IBOutlet weak var viewAmountMain: UIView!
//    @IBOutlet weak var viewAmount: UIView!
//    @IBOutlet weak var labelUtilizedbalance: UILabel!
//    @IBOutlet weak var labelwidrawableBalance: UILabel!
//    @IBOutlet weak var labelTotalBalance: UILabel!
//    @IBOutlet weak var buttonAmountOk: UIButton!
//    @IBOutlet weak var buttonAmountCancel: UIButton!
    
    private var arrSelectedTikets = [[String: Any]]()
    var AnyTimedictContest = [[String: Any]]()
    var AnyTimeGameList = [[String: Any]]()
    var totalgame = 0
    var currentindex = 0
    var dictContest = [String: Any]()
    var isFromMyTickets = Bool()
    private var isDataLoaded = Bool()
    private var isFromButtonClick = Bool()
    
    
    private var dictContestDetail = [String: Any]()
    private var arrTicket = [[String: Any]]()
    
    private var noOfSelected = Int()
    private var totalSelectedAmount = Double()
    
    private var isGetContest = Bool()
    private var isJoinContest = Bool()
    
    var isFromLink = Bool()
    
    @IBOutlet weak var constraintCollectionViewHeight: NSLayoutConstraint!
    
    //MARK: - Default Method
    override func viewDidLoad() {
        super.viewDidLoad()
        SetRandomNumber()
        setStartTimer()
        tableTickets.rowHeight = UITableView.automaticDimension
        tableTickets.tableFooterView = UIView()
        UNUserNotificationCenter.current().delegate = self
        if !MyModel().isConnectedToInternet() {
            Alert().showTost(message: Define.ERROR_INTERNET,
                             viewController: self)
        } else {
          //  getContestDetail()
            getAnyTimeGameList()
           // getAnyTimeGameContestList()
        }
        
       // setReminder()
        constraintPaymentViewHeight.constant = 0
        constraintSelectionViewHeight.constant = 0
        
        labelMarquee.animationCurve = .curveEaseInOut
        labelMarquee.fadeLength = 10.0
        labelMarquee.leadingBuffer = 30.0
        labelMarquee.trailingBuffer = 20.0
        labelMarquee.marqueeType = .MLContinuous
        labelMarquee.scrollDuration = 15
        
//        let formatedString = NSMutableAttributedString()
//        formatedString
//            .normal("The Total Tickets Sold and Max Winners are ")
//            .bold("Updating Live !!!")
//        labelMarquee.attributedText = formatedString
        
     
        
//       var startDate: Date?
//
//        let sDate1 = dictContest["startDate"]  as! String
//
//
//
//        let dateFormater = DateFormatter()
//        dateFormater.dateFormat = "yyyy-MM-dd HH:mm:ss"
//
//        let sDate = dateFormater.date(from:sDate1)
//
//        print("Start Date :\(String(describing: sDate))")
//                let calender = Calendar.current
//                let unitFlags = Set<Calendar.Component>([ .second])
//        let dateComponent = calender.dateComponents(unitFlags, from: Date(), to:sDate!)
//                seconds = dateComponent.second!
//                print("Seconds: \(seconds)")
//                if timer == nil {
//                    timer = Timer.scheduledTimer(timeInterval: 1,
//                                                 target: self,
//                                                 selector: #selector(handleTimer),
//                                                 userInfo: nil,
//                                                 repeats: true)
//                }
        
      //  viewAmountMain.isHidden = true
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        labelContestName.text = dictContest["name"] as? String ?? "No Name"
        labelContestName.text = "Classic Grids"
        
        let pbAmount = Define.USERDEFAULT.value(forKey: "PBAmount") as? Double ?? 0.0
        let sbAmount = Define.USERDEFAULT.value(forKey: "SBAmount") as? Double ?? 0.0
        
        let totalAmount = pbAmount + sbAmount
        
       // labelPBAmount.text = MyModel().getCurrncy(value: totalAmount)
        
        if isFromButtonClick {
            setSelectedData()
        }
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.handelNotifcation(_:)),
                                               name: .onContestLiveUpdate,
                                               object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
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
    
    @objc func handelNotifcation(_ notification: Notification) {
        print("Contest Data: \(notification.userInfo!)")
        
        if  notification.userInfo != nil {
            let dictData = notification.userInfo
            let arrData = dictData!["contest"] as! [[String: Any]]
            let strContestId = "\(dictContestDetail["id"]!)"
            
            for (_, item) in arrData.enumerated() {
                let strSelectedContestId = "\(item["contestId"]!)"
                let strContestPriceId = "\(item["contestPriceId"]!)"
                if strContestId == strSelectedContestId {
                    for (arrIndex, arrItem) in arrTicket.enumerated() {
                        let strSelectedContestPriceId = "\(arrItem["contestPriceId"]!)"
                        if strContestPriceId == strSelectedContestPriceId {
                            arrTicket[arrIndex]["maxWinners"] = item["maxWinners"]!
                            arrTicket[arrIndex]["totalTickets"] = item["totalTickets"]!
                            arrTicket[arrIndex]["totalWinnings"] = item["totalWinnings"]!
                            
                            let indexPath = IndexPath(row: arrIndex, section: 0)
                            tableTickets.reloadRows(at: [indexPath], with: .none)
                        }
                    }
                } else {
                    break
                }
            }
        }
    }
    private func setStartTimer() {
      
        startTimer = Timer.scheduledTimer(timeInterval:0.5,
                                          target: self,
                                          selector: #selector(handleStartTimer),
                                          userInfo: nil,
                                          repeats: true)
    }
    
    @objc func handleStartTimer() {
      
                updateColors()
              SetRandomNumber()
        collectionviewtickets.reloadData()

    }
    private func setDetail() {
        
        arrTicket = dictContestDetail["tickets"] as! [[String: Any]]
        let strMarquee = dictContestDetail["scrollerContent"] as? String ?? "No String"
        labelMarquee.text = strMarquee
        for (index, item) in arrTicket.enumerated() {
            var dictData = arrTicket[index]
            dictData["isAlreadyPurchase"] = item["isPurchased"] as? Bool ?? false
            arrTicket[index] = dictData
        }
        print("➭Tickets: \(arrTicket)")
        tableTickets.reloadData()
        isDataLoaded = true
        
    }
    
    //MARK: - Button Method
    
    @IBAction func left_click(_ sender: UIButton) {
        if (currentindex > 0) {
            currentindex = currentindex-1
            self.lblgamename.text = self.AnyTimeGameList[currentindex]["name"] as? String
            self.getContestDetail(index: currentindex)
        }
    }
    @IBAction func right_click(_ sender: UIButton) {
        if (currentindex < totalgame-1) {
            currentindex = currentindex + 1
            self.lblgamename.text = self.AnyTimeGameList[currentindex]["name"] as? String
            self.getContestDetail(index: currentindex)
           
        }
    }
    
    @IBAction func hostgame_click(_ sender: UIButton) {
        let HostGameVC = self.storyboard?.instantiateViewController(withIdentifier: "HostGameVC") as! HostGameVC
        self.navigationController?.pushViewController(HostGameVC, animated: true)
    }
    @IBAction func buttonBack(_ sender: Any) {
        NotificationCenter.default.removeObserver(self)
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func buttonPay(_ sender: Any) {
        
   
        
       // if labelPay.text == "Pay" {
            if !MyModel().isConnectedToInternet() {
                Alert().showTost(message: Define.ERROR_INTERNET,
                                 viewController: self)
            } else if noOfSelected == 0 {
                Alert().showTost(message: "Select Ticket",
                                 viewController: self)
            } else {
               // viewAmountMain.isHidden = false
                let pbAmount = Define.USERDEFAULT.value(forKey: "PBAmount") as? Double ?? 0.0
                //let tbAmount = Define.USERDEFAULT.value(forKey: "TBAmount") as? Double ?? 0.0
                if totalSelectedAmount <= pbAmount {
                    
                    let CGGamePlayVC = self.storyboard?.instantiateViewController(withIdentifier: "CGGamePlayVC") as! CGGamePlayVC
                    CGGamePlayVC.dictContest = dictContestDetail
                    CGGamePlayVC.isFromNotification = false
                    CGGamePlayVC.arrSelectedTikets = arrSelectedTikets
                    CGGamePlayVC.AnyTimedictContest = AnyTimedictContest
                    //gamePlayVC.dictGameData = dictGameData
                    self.navigationController?.pushViewController(CGGamePlayVC, animated: true)
                    
//                    labelUtilizedbalance.text = String(format: "₹%.2f", totalSelectedAmount) //"₹ \()"
//                    labelwidrawableBalance.text = "₹ 0.0"
//                    labelTotalBalance.text = String(format: "₹%.2f", totalSelectedAmount) //"₹ \(totalSelectedAmount)"
                } else {
//                    let cutUtilized = totalSelectedAmount - pbAmount
//                    labelUtilizedbalance.text = String(format: "₹%.2f", pbAmount) //"₹ \(pbAmount)"
//                    labelwidrawableBalance.text = String(format: "₹%.2f", cutUtilized) //"₹ \(cutUtilized)"
//                    labelTotalBalance.text = String(format: "₹%.2f", totalSelectedAmount) //"₹ \(totalSelectedAmount)"
                }
            }
//        } else {
//            let pbAmount = Define.USERDEFAULT.value(forKey: "PBAmount") as? Double ?? 0.0
//            let sbAmount = Define.USERDEFAULT.value(forKey: "SBAmount") as? Double ?? 0.0
//
//            let cutUtilized = totalSelectedAmount - (pbAmount + sbAmount)
//
//            let paymentVC = self.storyboard?.instantiateViewController(withIdentifier: "AddPaymentVC") as! AddPaymentVC
//            paymentVC.isFromTicket = true
//            paymentVC.addAmount = cutUtilized
//            paymentVC.isFromLink = isFromLink
//            self.navigationController?.pushViewController(paymentVC, animated: true)
//        }
    }
    
    
    @IBAction func btn_selectall(_ sender: Any) {
        
        var i = 0
        for i in i..<arrTicket.count
        
        {
         
        let index = i
        
            
        let isPurchased = arrTicket[index]["isPurchased"] as! Bool
        
        let dictData = arrTicket[index]
        let ticketID = dictData["contestPriceId"] as? Int ?? 0
        
            
        if arrSelectedTikets.count > 0 {
            
            for (indexNo, item) in arrSelectedTikets.enumerated() {
                let selectedTicketID = item["contestPriceId"] as? Int ?? 0
                
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
      //  labelPurchasedAmount.text = String(format: "₹%.2f", totalAmount)//"₹\(totalAmount)"
        
        setSelectedData()
        isFromButtonClick = true
        
        let indexPath = IndexPath(row: index, section: 0)
        tableTickets.reloadRows(at: [indexPath], with: .none)
        
        }
    }
    @IBAction func buttonAmountOK(_ sender: UIButton) {
        joinContest()
    }
    
    @IBAction func buttonAmountCancel(_ sender: UIButton) {
       // viewAmountMain.isHidden = true
    }
    @IBAction func buttonInfo(_ sender: Any) {
        
        let ticketInfo = ViewTicketInfo.instanceFromNib() as! ViewTicketInfo
        ticketInfo.frame = view.bounds
        view.addSubview(ticketInfo)
    }
    @IBAction func joinprivategroup_click(_ sender: UIButton) {
        let ClassicGridViewController = self.storyboard?.instantiateViewController(withIdentifier: "ClassicGridViewController") as! ClassicGridViewController
        self.navigationController?.pushViewController(ClassicGridViewController, animated: true)
        
    }
    
    func SetRandomNumber() {
        self.view.layoutIfNeeded()
//
//        let rangeMin = dictContestDetail["ansRangeMin"] as? Int ?? 0
//        let rangeMax = dictContestDetail["ansRangeMax"] as? Int ?? 0
//            arrRandomNumbers = MyModel().createRandomNumbers(number:8, minRange:rangeMin, maxRange:rangeMax)
//            arrBarcketColor = MyDataType().getArrayBrackets(index:8)
//          //  constrainCollectionViewHeight.constant = 50
//      //  collectionviewtickets.reloadData()
//        self.view.layoutIfNeeded()
        
       self.view.layoutIfNeeded()
            let rangeMinNumber = dictContestDetail["ansRangeMin"] as? Int ?? 0
            let rangeMaxNumber = dictContestDetail["ansRangeMax"] as? Int ?? 99
            
        let gamelevel = dictContestDetail["level"] as? Int ?? 0
      
            if gamelevel == 1 {
                arrRandomNumbers = MyModel().createRandomNumbers(number: 8, minRange: rangeMinNumber, maxRange: rangeMaxNumber)
                arrBarcketColor = MyDataType().getArrayBrackets(index: 8)
                constraintCollectionViewHeight.constant = 50
            } else if gamelevel == 2 {
                arrRandomNumbers = MyModel().createRandomNumbers(number: 16, minRange: rangeMinNumber, maxRange: rangeMaxNumber)
                arrBarcketColor = MyDataType().getArrayBrackets(index: 16)
                constraintCollectionViewHeight.constant = 100
            } else if gamelevel == 3 {
                arrRandomNumbers = MyModel().createRandomNumbers(number: 32, minRange: rangeMinNumber, maxRange: rangeMaxNumber)
                arrBarcketColor = MyDataType().getArrayBrackets(index: 32)
                constraintCollectionViewHeight.constant = 200
            }
        else
            {
                arrRandomNumbers = MyModel().createRandomNumbers(number: 8, minRange: rangeMinNumber, maxRange: rangeMaxNumber)
                arrBarcketColor = MyDataType().getArrayBrackets(index: 8)
                constraintCollectionViewHeight.constant = 50
            }
            self.view.layoutIfNeeded()
    }
    
    func updateColors()
    {
        for _ in 1...4 {
            let index = arrBarcketColor.count
            let lastColor = arrBarcketColor[index - 1]
            arrBarcketColor.remove(at: arrBarcketColor.count - 1)
            arrBarcketColor.insert(lastColor, at: 0)
        }
        
       
        
        
            arrRandomNumbers = MyModel().createRandomNumbers(number: 8, minRange: 0, maxRange: 99)
        
    }
    
}


extension CGTicketVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       

        return arrRandomNumbers.count
    
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width / 4, height: 25)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        let cell1 = collectionView.dequeueReusableCell(withReuseIdentifier: "Bracketcv", for: indexPath) as! Bracketcv
        

            cell1.labelNumber.text = "\(arrRandomNumbers[indexPath.row])"
            
           cell1.viewColor.backgroundColor = arrBarcketColor[indexPath.row].color
      
        return cell1
        
    }
}


//MARK: - TableView Delegate Method
extension CGTicketVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrTicket.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let gameMode = dictContestDetail["type"] as? Int ?? 0
        if gameMode == 0 {
            let ticketCell = tableView.dequeueReusableCell(withIdentifier: "TicketTVC") as! TicketTVC
            
            let isAlreadyPurchase = arrTicket[indexPath.row]["isAlreadyPurchase"] as? Bool ?? false
            
            
            
            
            if isAlreadyPurchase {
                //ticketCell.buttonSelection.backgroundColor = UIColor.white
                btnselectall.setImage(#imageLiteral(resourceName: "ic_checked"), for: .normal)
                ticketCell.buttonSelectTicket.alpha = 0.6
                ticketCell.buttonSelectTicket.isEnabled = false
                ticketCell.buttonSelectTicket.setImage(#imageLiteral(resourceName: "ic_checked"), for: .normal)
            } else {
                let isPurchased = arrTicket[indexPath.row]["isPurchased"] as? Bool ?? false
                view.layoutIfNeeded()
                ticketCell.buttonSelectTicket.alpha = 1
                ticketCell.buttonSelectTicket.isEnabled = true
                if isPurchased {
                    //ticketCell.buttonSelection.backgroundColor = UIColor.black.withAlphaComponent(0.4)
                    btnselectall.setImage(#imageLiteral(resourceName: "ic_checked"), for: .normal)
                    ticketCell.buttonSelectTicket.setImage(#imageLiteral(resourceName: "ic_checked"), for: .normal)
                } else {
                    //ticketCell.buttonSelection.backgroundColor = UIColor.clear
                    btnselectall.setImage(#imageLiteral(resourceName: "ic_unchecked"), for: .normal)
                    ticketCell.buttonSelectTicket.setImage(#imageLiteral(resourceName: "ic_unchecked"), for: .normal)
                }
                view.layoutIfNeeded()
            }
            
            
            let strAmonut = "\(arrTicket[indexPath.row]["amount"] as? Double ?? 0.0)"
            //ticketCell.labelEntryFees.text = "₹\(MyModel().getNumbers(value: Double(strAmonut)!))"

            let test = Double(strAmonut) ?? 0.00
            ticketCell.labelEntryFees.text = String(format: "₹ %.02f", test)
            //print(String(format: "%.02f", test))
            
            
            let strTickets = "\(arrTicket[indexPath.row]["totalTickets"] as? Int ?? 0)"
            ticketCell.labelTotalTicket.text = "\(MyModel().getNumbers(value: Double(strTickets)!))"
            
            let range = arrTicket[indexPath.row]["bracketSize"] as? Int ?? 0
            let rangeMin = dictContestDetail["ansRangeMin"] as? Int ?? 0
            let rangeMax = dictContestDetail["ansRangeMax"] as? Int ?? 0
            
            ticketCell.imageBar.image = MyModel().getImageForRange(range: range, rangeMaxValue: abs(rangeMin - rangeMax))
            ticketCell.labelBar.text = "\(range)"
            
            let totalTicket = arrTicket[indexPath.row]["totalTickets"] as? Int ?? 0
            
            if MyModel().isSetNA(totalTickets: totalTicket) {
                ticketCell.labelWinningAmount.text = "N/A"
                ticketCell.labelMaxWinner.text = "N/A(\(arrTicket[indexPath.row]["maxWinnersPrc"] as? Int ?? 0)%)"
            } else {
                let strWinning = "\(arrTicket[indexPath.row]["totalWinnings"]!)"
                ticketCell.labelWinningAmount.text = "\(MyModel().getCurrncy(value: Double(strWinning)!))"
                let strWinners = "\(arrTicket[indexPath.row]["maxWinners"] as? Int ?? 0)"
                ticketCell.labelMaxWinner.text = "\(MyModel().getNumbers(value: Double(strWinners)!))(\(arrTicket[indexPath.row]["maxWinnersPrc"] as? Int ?? 0)%)"
                
             
            }
            
            
            ticketCell.labelMinRange.text = "\(dictContestDetail["ansRangeMin"] as? Int ?? 0)"
            ticketCell.labelMaxRange.text = "\(dictContestDetail["ansRangeMax"] as? Int ?? 0)"
            
            ticketCell.buttonSelectTicket.addTarget(self,
                                                 action: #selector(buttonSelection(_:)),
                                                 for: .touchUpInside)
            ticketCell.buttonSelectTicket.tag = indexPath.row
            return ticketCell
        } else {
            let arrSloats = arrTicket[indexPath.row]["slotes"] as! [[String: Any]]
            if arrSloats.count == 3 {
                let ticketCell = tableView.dequeueReusableCell(withIdentifier: "ThreeSloatTVC") as! ThreeSloatTVC
                
                let game_no = arrTicket[indexPath.row]["game_no"] as? Int ?? 0
                
                ticketCell.lblgameno.text = "Game No: \(game_no)"
                
                let isAlreadyPurchase = arrTicket[indexPath.row]["isAlreadyPurchase"] as? Bool ?? false
                
                ticketCell.lblpending.text = "\(arrTicket[indexPath.row]["played"]!) Played /\(arrTicket[indexPath.row]["pending"]!) Pending"
                
                ticketCell.lbllockstyle.text = "Lock Style : Basic"
                
                if isAlreadyPurchase {
                    btnselectall.setImage(#imageLiteral(resourceName: "ic_checked"), for: .normal)
                    ticketCell.buttonSelectTicket.alpha = 0.6
                    ticketCell.buttonSelectTicket.isEnabled = false
                    ticketCell.buttonSelectTicket.setImage(#imageLiteral(resourceName: "ic_checked"), for: .normal)
                } else {
                    let isPurchased = arrTicket[indexPath.row]["isPurchased"] as? Bool ?? false
                    view.layoutIfNeeded()
                    ticketCell.buttonSelectTicket.alpha = 1
                    ticketCell.buttonSelectTicket.isEnabled = true
                    if isPurchased {
                        //ticketCell.buttonSelection.backgroundColor = UIColor.black.withAlphaComponent(0.4)
                       
                        btnselectall.setImage(#imageLiteral(resourceName: "ic_checked"), for: .normal)
                        ticketCell.buttonSelectTicket.setImage(#imageLiteral(resourceName: "ic_checked"), for: .normal)
                    } else {
                        //ticketCell.buttonSelection.backgroundColor = UIColor.clear
                        btnselectall.setImage(#imageLiteral(resourceName: "ic_unchecked"), for: .normal)
                        ticketCell.buttonSelectTicket.setImage(#imageLiteral(resourceName: "ic_unchecked"), for: .normal)
                    }
                    view.layoutIfNeeded()
                }
                
                let strAmonut = "\(arrTicket[indexPath.row]["amount"] as? Double ?? 0.0)"
                let test = Double(strAmonut) ?? 0.00
                ticketCell.labelEntryFees.text = String(format: "₹ %.02f", test)
                
                
                //ticketCell.labelEntryFees.text = "₹\(MyModel().getNumbers(value: Double(strAmonut)!))"
              //  let strTickets = "\(arrTicket[indexPath.row]["totalTickets"] as? Int ?? 0)"
//                ticketCell.labelTotalTickets.text = "\(MyModel().getNumbers(value: Double(strTickets)!))"
                ticketCell.labelTotalTickets.text = "\(arrTicket[indexPath.row]["no_of_players"]!)"
                
                let totalTicket = arrTicket[indexPath.row]["totalTickets"] as? Int ?? 0
                
                if MyModel().isSetNA(totalTickets: totalTicket) {
                    ticketCell.labelWinningAmount.text = "N/A"
                    
                    ticketCell.labelMaxWinner.text = "N/A(\(arrTicket[indexPath.row]["maxWinnersPrc"] as? Int ?? 0)%)"
                    
//                    let jticketwinning = "\(arrTicket[indexPath.row]["jticketwinning"]!)"
//                    if jticketwinning != "0" {
//                        ticketCell.jticketwinning.text = "\(MyModel().getCurrncy(value: Double(jticketwinning)!))"
//                    }
//                    else
//                    {
//                        ticketCell.jticketwinning.text = "N/A"
//                    }
//
//                    let totalJTicketHolder = "\(arrTicket[indexPath.row]["totalJTicketHolder"] as? Int ?? 0)"
//                    if totalJTicketHolder != "0"
//                    {
//                        ticketCell.jticketholder.text = totalJTicketHolder
//                    }
//                    else
//                    {
//                        ticketCell.jticketholder.text = "N/A"
//                    }
//
                  //  ticketCell.perjticket.text =   "\(arrTicket[indexPath.row]["perJTicket"] as? Int ?? 0)" + "/" + "1 J ticket holder"
                    
                } else {
                    
//                   let jticketwinning = "\(arrTicket[indexPath.row]["jticketwinning"]!)"
//                   if jticketwinning != "0" {
//                       ticketCell.jticketwinning.text = "\(MyModel().getCurrncy(value: Double(jticketwinning)!))"
//                   }
//                   else
//                   {
//                       ticketCell.jticketwinning.text = "N/A"
//                   }
//
//                   let totalJTicketHolder = "\(arrTicket[indexPath.row]["totalJTicketHolder"] as? Int ?? 0)"
//                   if totalJTicketHolder != "0"
//                   {
//                       ticketCell.jticketholder.text = totalJTicketHolder
//                   }
//                   else
//                   {
//                       ticketCell.jticketholder.text = "N/A"
//                   }
                    
                    let strWinning = "\(arrTicket[indexPath.row]["totalWinnings"]!)"
                    ticketCell.labelWinningAmount.text = "\(MyModel().getCurrncy(value: Double(strWinning)!))"
                    
                    let strWinners = "\(arrTicket[indexPath.row]["maxWinners"] as? Int ?? 0)"
                    ticketCell.labelMaxWinner.text = "\(MyModel().getNumbers(value: Double(strWinners)!))(\(arrTicket[indexPath.row]["maxWinnersPrc"] as? Int ?? 0)%)"
                  
                }
                
                ticketCell.labelAnsMinus.text = arrSloats[0]["displayValue"] as? String ?? "-"
                ticketCell.labelAnsZero.text = arrSloats[1]["displayValue"] as? String ?? "0"
                ticketCell.labelAnsPlus.text = arrSloats[2]["displayValue"] as? String ?? "+"
                
                let string1 = arrSloats[0]["displayValue"] as? String ?? "-"
                let string2 = arrSloats[2]["displayValue"] as? String ?? "-"
                
                if string1.localizedCaseInsensitiveContains("red win")
                {
                    ticketCell.viewRange.backgroundColor = #colorLiteral(red: 0.9019607843, green: 0.8862745098, blue: 0.8862745098, alpha: 1)
                   // ticketCell.labelAnsMinus.backgroundColor = UIColor.red
                    ticketCell.labelAnsMinus.textColor = UIColor.white
                    ticketCell.labelAnsMinus.layer.cornerRadius = 5
                    ticketCell.btnAnsMinus.backgroundColor = UIColor.red
                }
                if string2.localizedCaseInsensitiveContains("blue win")
                {
                  //  ticketCell.labelAnsPlus.backgroundColor = #colorLiteral(red: 0.01085097995, green: 0.3226040006, blue: 1, alpha: 1)
                    ticketCell.labelAnsPlus.textColor = UIColor.white
                    ticketCell.labelAnsPlus.layer.cornerRadius = 5
                    ticketCell.btnAnsplus.backgroundColor = #colorLiteral(red: 0.01085097995, green: 0.3226040006, blue: 1, alpha: 1)
                }
                
                ticketCell.buttonSelectTicket.addTarget(self,
                action: #selector(buttonSelection(_:)),for: .touchUpInside)
                ticketCell.buttonSelectTicket.tag = indexPath.row
                return ticketCell
            } else {
                let ticketCell = tableView.dequeueReusableCell(withIdentifier: "TicketSloteTVC") as! TicketSloteTVC
                self.view.layoutIfNeeded()
                let isAlreadyPurchase = arrTicket[indexPath.row]["isAlreadyPurchase"] as? Bool ?? false
                
                if isAlreadyPurchase {
                    
                    ticketCell.buttonSelectTicket.alpha = 0.6
                    ticketCell.buttonSelectTicket.isEnabled = false
                    ticketCell.buttonSelectTicket.setImage(#imageLiteral(resourceName: "ic_checked"), for: .normal)
                } else {
                    let isPurchased = arrTicket[indexPath.row]["isPurchased"] as? Bool ?? false
                    view.layoutIfNeeded()
                    ticketCell.buttonSelectTicket.alpha = 1
                    ticketCell.buttonSelectTicket.isEnabled = true
                    if isPurchased {
                         btnselectall.setImage(#imageLiteral(resourceName: "ic_checked"), for: .normal)
                        ticketCell.buttonSelectTicket.setImage(#imageLiteral(resourceName: "ic_checked"), for: .normal)
                    } else {
                         btnselectall.setImage(#imageLiteral(resourceName: "ic_unchecked"), for: .normal)
                        ticketCell.buttonSelectTicket.setImage(#imageLiteral(resourceName: "ic_unchecked"), for: .normal)
                    }
                    view.layoutIfNeeded()
                }
                
                let strAmonut = "\(arrTicket[indexPath.row]["amount"] as? Double ?? 0.0)"
                let test = Double(strAmonut) ?? 0.00
                ticketCell.labelEntryFees.text = String(format: "₹ %.02f", test)
                //ticketCell.labelEntryFees.text = "₹\(MyModel().getNumbers(value: Double(strAmonut)!))"
                let strTickets = "\(arrTicket[indexPath.row]["totalTickets"] as? Int ?? 0)"
                ticketCell.labelTotalTickets.text = "\(MyModel().getNumbers(value: Double(strTickets)!))"
                
                
                
                
//                let totalTicket = arrTicket[indexPath.row]["totalTickets"] as? Int ?? 0
//
//                if MyModel().isSetNA(totalTickets: totalTicket) {
//                    ticketCell.labelWinningAmount.text = "N/A"
//                    ticketCell.labelMaxWinner.text = "N/A(\(arrTicket[indexPath.row]["maxWinnersPrc"] as? Int ?? 0)%)"
//                } else {
//                    let strWinning = "\(arrTicket[indexPath.row]["totalWinnings"]!)"
//                    ticketCell.labelWinningAmount.text = "\(MyModel().getCurrncy(value: Double(strWinning)!))"
//                    let strWinners = "\(arrTicket[indexPath.row]["maxWinners"] as? Int ?? 0)"
//                    ticketCell.labelMaxWinner.text = "\(MyModel().getNumbers(value: Double(strWinners)!))(\(arrTicket[indexPath.row]["maxWinnersPrc"] as? Int ?? 0)%)"
//                }
                
         let totalTicket = arrTicket[indexPath.row]["totalTickets"] as? Int ?? 0
                                             
                                                           
                                                           if MyModel().isSetNA(totalTickets: totalTicket) {
                                                               ticketCell.labelWinningAmount.text = "N/A"
                                                               
                                                               ticketCell.labelMaxWinner.text = "N/A(\(arrTicket[indexPath.row]["maxWinnersPrc"] as? Int ?? 0)%)"
                                                               
//                                                               let jticketwinning = "\(arrTicket[indexPath.row]["jticketwinning"]!)"
//                                                               if jticketwinning != "0" {
//                                                                   ticketCell.jticketwinning.text = "\(MyModel().getCurrncy(value: Double(jticketwinning)!))"
//                                                               }
//                                                               else
//                                                               {
//                                                                   ticketCell.jticketwinning.text = "N/A"
//                                                               }
//
//                                                               let totalJTicketHolder = "\(arrTicket[indexPath.row]["totalJTicketHolder"] as? Int ?? 0)"
//                                                               if totalJTicketHolder != "0"
//                                                               {
//                                                                   ticketCell.jticketholder.text = totalJTicketHolder
//                                                               }
//                                                               else
//                                                               {
//                                                                   ticketCell.jticketholder.text = "N/A"
//                                                               }
                                                               
                                                            //   ticketCell.perjticket.text =   "\(arrSelectedTikets[indexPath.row]["perJTicket"] as? Int ?? 0)" + "/" + "1 J ticket holder"
                                                               
                                                           } else {
                                                               
//                                                              let jticketwinning = "\(arrTicket[indexPath.row]["jticketwinning"]!)"
//                                                              if jticketwinning != "0" {
//                                                                  ticketCell.jticketwinning.text = "\(MyModel().getCurrncy(value: Double(jticketwinning)!))"
//                                                              }
//                                                              else
//                                                              {
//                                                                  ticketCell.jticketwinning.text = "N/A"
//                                                              }
//
//                                                              let totalJTicketHolder = "\(arrTicket[indexPath.row]["totalJTicketHolder"] as? Int ?? 0)"
//                                                              if totalJTicketHolder != "0"
//                                                              {
//                                                                  ticketCell.jticketholder.text = totalJTicketHolder
//                                                              }
//                                                              else
//                                                              {
//                                                                  ticketCell.jticketholder.text = "N/A"
//                                                              }
                                                               
                                                               let strWinning = "\(arrTicket[indexPath.row]["totalWinnings"]!)"
                                                               ticketCell.labelWinningAmount.text = "\(MyModel().getCurrncy(value: Double(strWinning)!))"
                                                               
                                                               let strWinners = "\(arrTicket[indexPath.row]["maxWinners"] as? Int ?? 0)"
                                                               ticketCell.labelMaxWinner.text = "\(MyModel().getNumbers(value: Double(strWinners)!))(\(arrTicket[indexPath.row]["maxWinnersPrc"] as? Int ?? 0)%)"
                                                             
                                                           }
                
                ticketCell.arrData = nil
                ticketCell.arrData = arrTicket[indexPath.row]["slotes"] as? [[String: Any]]
                
                ticketCell.buttonSelectTicket.addTarget(self,
                                                     action: #selector(buttonSelection(_:)),
                                                     for: .touchUpInside)
                ticketCell.buttonSelectTicket.tag = indexPath.row
                self.view.layoutIfNeeded()
                return ticketCell
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let userVC = self.storyboard?.instantiateViewController(withIdentifier: "UserListVC") as! UserListVC
        userVC.dictContestData = dictContest
        userVC.dictTicketData = arrTicket[indexPath.row]
        userVC.isfromanytimegame = true
        self.navigationController?.pushViewController(userVC, animated: true)
    }
    
    //MARK: - TableView Button Method
    @objc func buttonSelection(_ sender: UIButton) {
        
        let index = sender.tag
        
        let isPurchased = arrTicket[index]["isPurchased"] as! Bool
        
        let dictData = arrTicket[index]
        let ticketID = dictData["contestPriceId"] as? Int ?? 0
        
        if arrSelectedTikets.count > 0 {
            
            for (indexNo, item) in arrSelectedTikets.enumerated() {
                let selectedTicketID = item["contestPriceId"] as? Int ?? 0
                
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
      //  labelPurchasedAmount.text = String(format: "₹%.2f", totalAmount)//"₹\(totalAmount)"
        
        setSelectedData()
        isFromButtonClick = true
        
        let indexPath = IndexPath(row: index, section: 0)
        tableTickets.reloadRows(at: [indexPath], with: .none)
        //tableTickets.reloadData()
    }
    
    func setSelectedData() {
        self.view.layoutIfNeeded()
        if noOfSelected == 0 {
            constraintPaymentViewHeight.constant = 0
            constraintSelectionViewHeight.constant = 0
        } else {
            constraintPaymentViewHeight.constant = 50
            constraintSelectionViewHeight.constant = 25
        }
        self.view.layoutIfNeeded()
        
        let pbAmount = Define.USERDEFAULT.value(forKey: "PBAmount") as? Double ?? 0.0
        let sbAmount = Define.USERDEFAULT.value(forKey: "SBAmount") as? Double ?? 0.0
        
        let totalAmount = pbAmount + sbAmount
        
//        if Double(totalSelectedAmount) > totalAmount {
//            labelPBAmount.textColor = UIColor.red
//            labelPay.text = "Add to wallet"
//        } else {
//            labelPBAmount.textColor = Define.MAINVIEWCOLOR2
//            labelPBAmount.textColor = UIColor.green
//            labelPay.text = "Pay"
//        }
    }
    
   
    
}

//MARK: - API
extension CGTicketVC {
    func getContestDetail(index:Int) {
        Loading().showLoading(viewController: self)
        let parameter: [String: Any] = ["contest_id": AnyTimeGameList[index]["contestID"] ?? "0"]
        let strURL = Define.APP_URL + Define.API_CONTEST_DETAIL
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
                self.getContestDetail(index: index)
            } else {
                Loading().hideLoading(viewController: self)
                print("Result: \(result!)")
                let status = result!["statusCode"] as? Int ?? 0
                if status == 200 {
                    self.dictContestDetail = result!["content"] as! [String: Any]
                    print(self.dictContestDetail)
                    self.setDetail()
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
    
    func getAnyTimeGameList() {
        Loading().showLoading(viewController: self)
        let parameter: [String: Any] = ["isSpinningMachine":"0"]
        let strURL = Define.APP_URL + Define.API_ANYTIMEGAMELIST
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
               // self.getContestDetail()
            } else {
                Loading().hideLoading(viewController: self)
                print("Result: \(result!)")
                let status = result!["statusCode"] as? Int ?? 0
                if status == 200 {
                    let arr = result!["content"] as? [[String: Any]] ?? []
                    if arr.count > 0 {
                        self.AnyTimedictContest = arr
                        self.getAnyTimeGameContestList()
                    }
                   
                    print(self.dictContestDetail)
                   
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
        let parameter: [String: Any] = ["isSpinningMachine":"0"]
        let strURL = Define.APP_URL + Define.API_ANYTIMEGAMECONTESTLIST
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
             //   self.getContestDetail(index: in)
            } else {
                Loading().hideLoading(viewController: self)
                print("Result: \(result!)")
                let status = result!["statusCode"] as? Int ?? 0
                if status == 200 {
                    let arr = result!["content"] as? [[String: Any]] ?? []
                    if arr.count > 0 {
                        self.AnyTimeGameList = arr
                        self.getContestDetail(index: 0)
                        self.lblgamename.text = self.AnyTimeGameList[0]["name"] as? String
                        self.totalgame = self.AnyTimeGameList.count
                    }
                   
                    print(self.dictContestDetail)
                   
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
  
    func joinContest() {
        Loading().showLoading(viewController: self)
        var arrSelected = [String]()
       
        for item in arrSelectedTikets {
            let isSelected = item["isPurchased"] as! Bool
            if isSelected {
                let strID = "\(item["contestPriceId"]!)"
                arrSelected.append(strID)
            }
        }
        
        let strSelectedID = arrSelected.joined(separator: ",")
        
        let parameter:[String: Any] = ["contest_id": AnyTimedictContest[0]["contestID"]!,
                                       "tickets": strSelectedID]
        let strURL = Define.APP_URL + Define.API_JOIN_CONTEST
        
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
                    
                    NotificationCenter.default.post(name: .paymentUpdated, object: nil)
                    
                    self.createReminder(strTitle: self.dictContest["name"] as? String ?? "No Name",strDate: self.dictContest["startDate"] as! String)
                    let paymentVC = self.storyboard?.instantiateViewController(withIdentifier: "PaymentSummaryVC") as! PaymentSummaryVC
                    paymentVC.isFromLink = self.isFromLink
                    self.navigationController?.pushViewController(paymentVC, animated: true)
                    
                    //UpComingContest
                    NotificationCenter.default.post(name: .upComingContest, object: nil)
                    
                    //MyContest
                    NotificationCenter.default.post(name: .myContest, object: nil)
                     NotificationCenter.default.post(name: .getAllspecialContest, object: nil)
                    
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
    
    func createReminder(strTitle: String, strDate: String) {
        var isRemiderSet = Bool()
        
        for item in arrTicket {
            let isPrc = item["isAlreadyPurchase"] as? Bool ?? false
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

//MARK: - Notifcation Delegate Method
extension CGTicketVC: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
        
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        switch response.actionIdentifier
        {
            
             
        case Define.PLAYGAME:
            print("Play Game")
            let dictData = response.notification.request.content.userInfo as! [String: Any]
            print(dictData)
            let gamePlayVC = self.storyboard?.instantiateViewController(withIdentifier: "GamePlayVC") as! GamePlayVC
            gamePlayVC.isFromNotification = true
            gamePlayVC.dictContest = dictData
            self.navigationController?.pushViewController(gamePlayVC, animated: true)
        default:
            break
        }
        
    }
    
}

//MARK: - Alert Contollert
extension CGTicketVC {
    func retry() {
        let alertController = UIAlertController(title: Define.ERROR_TITLE,
                                                message: Define.ERROR_SERVER,
                                                preferredStyle: .alert)
        let buttonRetry = UIAlertAction(title: "Retry",
                                        style: .default)
        { _ in
            if self.isGetContest {
                self.getContestDetail(index: self.currentindex)
            } else if self.isJoinContest {
                self.joinContest()
            }
        }
        let cancel = UIAlertAction(title: "Cancel",
                                   style: .cancel,
                                   handler: nil)
        alertController.addAction(cancel)
        alertController.addAction(buttonRetry)
        self.present(alertController,
                     animated: true,
                     completion: nil)
    }
}

//
//  SMMyTicketVC.swift
//  CBit
//
//  Created by Nirmal Bodar on 03/03/21.
//  Copyright © 2021 Bhavik Kothari. All rights reserved.
//

import UIKit
import UserNotifications
import MarqueeLabel


class SMMyTicketVC: UIViewController {
    //MARK: - Properties
    @IBOutlet weak var tableMyTickets: UITableView!
    @IBOutlet weak var labelContestName: UILabel!
    @IBOutlet weak var labelSelectedTicket: UILabel!
    @IBOutlet weak var labelMarquee: MarqueeLabel!
    
    //Constraint
    @IBOutlet weak var constraintBuyMoreViewHeights: NSLayoutConstraint!
    
    @IBOutlet weak var tblticketheight: NSLayoutConstraint!
    @IBOutlet weak var tblmyticketheight: NSLayoutConstraint!
    
    var dictContest = [String: Any]()

    private var dictContestDetail = [String: Any]()
    private var arrTickets = [[String: Any]]()
    private var arrSelectedTikets = [[String: Any]]()
    
    
   // @IBOutlet weak var lbltitle: UILabel!
    @IBOutlet weak var btnselectall: UIButton!
  //  @IBOutlet weak var labelRemainingTime: UILabel!
   // @IBOutlet weak var collectionviewtickets: UICollectionView!
   // private var arrRandomNumbers = [Int]()
  //  var arrBarcketColor = [BracketData]()
  //  var startTimer: Timer?
  //  var timer: Timer?
  //  var seconds = Int()

    //@IBOutlet weak var labelContestName: UILabel!
    @IBOutlet weak var tableTickets: UITableView!
    @IBOutlet weak var labelSelectedCount: UILabel!
    @IBOutlet weak var labelPurchasedAmount: UILabel!
    @IBOutlet weak var labelPBAmount: UILabel!
    @IBOutlet weak var buttonPay: UIButton!
    @IBOutlet weak var labelPay: UILabel!
    
    //@IBOutlet weak var labelMarquee: MarqueeLabel!
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
    
    private var arrSelectedTiketsPurchase = [[String: Any]]()
    
  //  var dictContest = [String: Any]()
    var isFromMyTickets = Bool()
    private var isDataLoaded = Bool()
    private var isFromButtonClick = Bool()
    
    
    private var dictContestDetailTicket = [String: Any]()
    private var arrTicket = [[String: Any]]()
    
    private var noOfSelected = Int()
    private var totalSelectedAmount = Double()
    
    private var isGetContest = Bool()
    private var isJoinContest = Bool()
    
    var isFromLink = Bool()
    
  //  @IBOutlet weak var constraintCollectionViewHeight: NSLayoutConstraint!
    
    //MARK: - Default Method
    override func viewDidLoad() {
        super.viewDidLoad()
        tableMyTickets.rowHeight = UITableView.automaticDimension
        tableMyTickets.tableFooterView = UIView()
        UNUserNotificationCenter.current().delegate = self
        if !MyModel().isConnectedToInternet() {
            Alert().showTost(message: Define.ERROR_INTERNET,
                             viewController: self)
        } else {
            getMyTickets()
        }
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.handelNotifcation(_:)),
                                               name: .onContestLiveUpdate,
                                               object: nil)
        labelMarquee.animationCurve = .curveEaseInOut
        labelMarquee.fadeLength = 10.0
        labelMarquee.leadingBuffer = 30.0
        labelMarquee.trailingBuffer = 20.0
        labelMarquee.marqueeType = .MLContinuous
        labelMarquee.scrollDuration = 15
        
        let formatedString = NSMutableAttributedString()
        formatedString
            .normal("The Total Tickets Sold and Max Winners are ")
            .bold("Updating Live !!!     ")
        labelMarquee.attributedText = formatedString
        
        if !MyModel().isConnectedToInternet() {
            Alert().showTost(message: Define.ERROR_INTERNET,
                             viewController: self)
        } else {
            getContestDetail()
        }
        
       // setReminder()
        constraintPaymentViewHeight.constant = 0
        constraintSelectionViewHeight.constant = 0
        viewAmountMain.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        tblmyticketheight.constant = tableMyTickets.contentSize.height
        tblticketheight.constant = tableTickets.contentSize.height
        tableMyTickets.layoutIfNeeded()
        tableTickets.layoutIfNeeded()
        self.view.layoutIfNeeded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        labelContestName.text = dictContest["name"] as? String ?? "No Name"
        let pbAmount = Define.USERDEFAULT.value(forKey: "PBAmount") as? Double ?? 0.0
        let sbAmount = Define.USERDEFAULT.value(forKey: "SBAmount") as? Double ?? 0.0
        
        let totalAmount = pbAmount + sbAmount
        
        labelPBAmount.text = MyModel().getCurrncy(value: totalAmount)
        
        if isFromButtonClick {
            setSelectedData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        buttonAmountCancel.layer.borderColor = UIColor.black.cgColor
        buttonAmountCancel.layer.borderWidth = 1
        buttonAmountCancel.layer.masksToBounds = true
    }
    
    @objc func handelNotifcation(_ notification: Notification) {
        print("Contest Data: \(notification.userInfo!)")
        
        if  notification.userInfo != nil {
            let dictData = notification.userInfo
            let arrData = dictData!["contest"] as! [[String: Any]]
            let strContestId = "\(dictContest["id"]!)"
            
            for (_, item) in arrData.enumerated() {
                let strSelectedContestId = "\(item["contestId"]!)"
                let strContestPriceId = "\(item["contestPriceId"]!)"
                if strContestId == strSelectedContestId {
                    for (arrIndex, arrItem) in arrSelectedTikets.enumerated() {
                        let strSelectedContestPriceId = "\(arrItem["contestPriceId"]!)"
                        print(strSelectedContestPriceId)
                        if strContestPriceId == strSelectedContestPriceId {
                            arrSelectedTikets[arrIndex]["maxWinners"] = item["maxWinners"]!
                            arrSelectedTikets[arrIndex]["totalTickets"] = item["totalTickets"]!
                            arrSelectedTikets[arrIndex]["totalWinnings"] = item["totalWinnings"]!
                            
                            let indexPath = IndexPath(row: arrIndex, section: 0)
                            tableMyTickets.reloadRows(at: [indexPath], with: .automatic)
                        }
                    }
                } else {
                    break
                }
            }
            
        }
    }
    
    private func setDetail() {
        arrTickets = dictContestDetail["tickets"] as! [[String: Any]]
        let strMarquee = dictContestDetail["scrollerContent"] as? String ?? "No String"
        labelMarquee.text = strMarquee
        
        for item in arrTickets {
            let isPurchased = item["isPurchased"] as? Bool ?? false
            if isPurchased {
                arrSelectedTikets.append(item)
            }
        }
        tableMyTickets.reloadData()
        
        if arrSelectedTikets.count == 1 {
            labelSelectedTicket.text = "\(arrSelectedTikets.count) Contest Joined"
        } else {
            labelSelectedTicket.text = "\(arrSelectedTikets.count) Contests Joined"
        }
        self.view.layoutIfNeeded()
        if arrTickets.count == arrSelectedTikets.count {
            constraintBuyMoreViewHeights.constant = 0
        } else {
            constraintBuyMoreViewHeights.constant = 50
        }
        self.view.layoutIfNeeded()
        
        
    }
    
    
    func setdetailsticket()
    {
        arrTicket = dictContestDetailTicket["tickets"] as! [[String: Any]]
        for (index, item) in arrTicket.enumerated() {
            var dictData = arrTicket[index]
            dictData["isAlreadyPurchase"] = item["isPurchased"] as? Bool ?? false
            arrTicket[index] = dictData
        }
        self.arrTicket = self.arrTicket.filter{($0["isAlreadyPurchase"] as! Bool) == false}
        print("➭Tickets: \(arrTicket)")
        DispatchQueue.main.async {
            self.tableTickets.reloadData()
        }
        isDataLoaded = true
    }
    
    //MARK: - Button Method
    @IBAction func buttonBack(_ sender: Any) {
        NotificationCenter.default.removeObserver(self)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonPay(_ sender: Any) {
        if labelPay.text == "Pay" {
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
            
            let paymentVC = self.storyboard?.instantiateViewController(withIdentifier: "AddPaymentVC") as! AddPaymentVC
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
        let ticketID = dictData["contestPriceId"] as? Int ?? 0
        
            
        if arrSelectedTiketsPurchase.count > 0 {
            
            for (indexNo, item) in arrSelectedTiketsPurchase.enumerated() {
                let selectedTicketID = item["contestPriceId"] as? Int ?? 0
                
                if ticketID == selectedTicketID {
                    
                    arrTicket[index]["isPurchased"] = NSNumber(value: !isPurchased)
                    arrSelectedTiketsPurchase[indexNo]["isPurchased"] = NSNumber(value: !isPurchased)
                    break
                } else if indexNo == arrSelectedTiketsPurchase.count - 1 {
                    
                    arrTicket[index]["isPurchased"] = NSNumber(value: !isPurchased)
                    arrSelectedTiketsPurchase.append(arrTicket[index])
                    break
                }
            }
            
        } else {
            arrTicket[index]["isPurchased"] = NSNumber(value: !isPurchased)
            arrSelectedTiketsPurchase.append(arrTicket[index])
        }
        
        var totalSelected = Int()
        var totalAmount = Double()
        
        for item in arrSelectedTiketsPurchase {
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
        joinContest()
    }
    
    @IBAction func buttonAmountCancel(_ sender: UIButton) {
        viewAmountMain.isHidden = true
    }
    
    @IBAction func joinprivategroup_click(_ sender: UIButton) {
        let NextVC = self.storyboard?.instantiateViewController(withIdentifier: "PrivateGroupViewController") as! PrivateGroupViewController
        NextVC.dictContest = dictContest
        self.navigationController?.pushViewController(NextVC, animated: true)
        
    }
    
    @IBAction func buttonBuyMoreTickets(_ sender: UIButton) {
//        let ticketVC = self.storyboard?.instantiateViewController(withIdentifier: "TicketVC") as! TicketVC
//        ticketVC.dictContest = dictContest
//        ticketVC.isFromMyTickets = true
//        self.navigationController?.pushViewController(ticketVC, animated: true)
        
        let SpinningMachineTicketVC = self.storyboard?.instantiateViewController(withIdentifier: "SpinningMachineTicketVC") as! SpinningMachineTicketVC
        SpinningMachineTicketVC.dictContest = dictContest
        SpinningMachineTicketVC.isFromMyTickets = true
        self.navigationController?.pushViewController(SpinningMachineTicketVC, animated: true)
    }
}


//MARK: - TableView Delegate Method
extension SMMyTicketVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
       viewDidLayoutSubviews()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableTickets {
            return arrTicket.count
        }
        else if tableView == tableMyTickets {
            return arrSelectedTikets.count
        }
        else
        {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tableTickets {
            let gameMode = dictContest["type"] as? Int ?? 0
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
                
                let minJoin = arrTicket[indexPath.row]["minJoin"] as? Int ?? 0
                if MyModel().isSetNA(totalTickets: totalTicket, minJoin: minJoin) {
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
            }
            else
            {
                let ticketCell = tableView.dequeueReusableCell(withIdentifier: "SpinningMachineCell") as! SpinningMachineCell
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
                

                
         let totalTicket = arrTicket[indexPath.row]["totalTickets"] as? Int ?? 0
                                             
                                                           
                let minJoin = arrTicket[indexPath.row]["minJoin"] as? Int ?? 0
                if MyModel().isSetNA(totalTickets: totalTicket, minJoin: minJoin) {
                                                               ticketCell.labelWinningAmount.text = "N/A"
                                                               
                                                               ticketCell.labelMaxWinner.text = "N/A(\(arrTicket[indexPath.row]["maxWinnersPrc"] as? Int ?? 0)%)"
                                                               

                                                               
                                                           } else {
                                                               
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
        else if tableView == tableMyTickets {
            let gameMode = dictContest["type"] as? Int ?? 0
            if gameMode == 0 {
                let ticketCell = tableView.dequeueReusableCell(withIdentifier: "TicketTVC") as! TicketTVC
                
                let strAmonut = "\(arrSelectedTikets[indexPath.row]["amount"] as? Double ?? 0.0)"
                //ticketCell.labelEntryFees.text = "₹\(MyModel().getNumbers(value: Double(strAmonut)!))"
                let test = Double(strAmonut) ?? 0.00
                ticketCell.labelEntryFees.text = String(format: "₹ %.02f", test)
                
                let strTickets = "\(arrSelectedTikets[indexPath.row]["totalTickets"] as? Int ?? 0)"
                ticketCell.labelTotalTicket.text = "\(MyModel().getNumbers(value: Double(strTickets)!))"
                
                let totalTicket = arrSelectedTikets[indexPath.row]["totalTickets"] as? Int ?? 0
                
                let minJoin = arrSelectedTikets[indexPath.row]["minJoin"] as? Int ?? 0
                if MyModel().isSetNA(totalTickets: totalTicket, minJoin: minJoin) {
                    ticketCell.labelWinningAmount.text = "N/A"
                    ticketCell.labelMaxWinner.text = "N/A(\(arrSelectedTikets[indexPath.row]["maxWinnersPrc"] as? Int ?? 0)%)"
                } else {
                    let strWinning = "\(arrSelectedTikets[indexPath.row]["totalWinnings"]!)"
                    ticketCell.labelWinningAmount.text = "\(MyModel().getCurrncy(value: Double(strWinning)!))"
                    let strWinners = "\(arrSelectedTikets[indexPath.row]["maxWinners"] as? Int ?? 0)"
                    ticketCell.labelMaxWinner.text = "\(MyModel().getNumbers(value: Double(strWinners)!))(\(arrSelectedTikets[indexPath.row]["maxWinnersPrc"] as? Int ?? 0)%)"
                }
                
                
                
                ticketCell.labelMinRange.text = "\(dictContestDetail["ansRangeMin"] as? Int ?? 0)"
                ticketCell.labelMaxRange.text = "\(dictContestDetail["ansRangeMax"] as? Int ?? 0)"
                
                let range = arrSelectedTikets[indexPath.row]["bracketSize"] as? Int ?? 0
                let rangeMin = dictContestDetail["ansRangeMin"] as? Int ?? 0
                let rangeMax = dictContestDetail["ansRangeMax"] as? Int ?? 0
                ticketCell.imageBar.image = MyModel().getImageForRange(range: range, rangeMaxValue: abs(rangeMin - rangeMax))
                ticketCell.labelBar.text = "\(range)"
                
                return ticketCell
            } else {
                let arrSloats = arrSelectedTikets[indexPath.row]["slotes"] as! [[String: Any]]
    //            if arrSloats.count == 3 {
    //                let ticketCell = tableView.dequeueReusableCell(withIdentifier: "ThreeSloatTVC") as! ThreeSloatTVC
    //
    //                let strAmonut = "\(arrSelectedTikets[indexPath.row]["amount"] as? Double ?? 0.0)"
    //                //ticketCell.labelEntryFees.text = "₹\(MyModel().getNumbers(value: Double(strAmonut)!))"
    //                let test = Double(strAmonut) ?? 0.00
    //                ticketCell.labelEntryFees.text = String(format: "₹ %.02f", test)
    //
    //                let strTickets = "\(arrSelectedTikets[indexPath.row]["totalTickets"] as? Int ?? 0)"
    //                ticketCell.labelTotalTickets.text = "\(MyModel().getNumbers(value: Double(strTickets)!))"
    //
    //                let totalTicket = arrSelectedTikets[indexPath.row]["totalTickets"] as? Int ?? 0
    //
    //
    //                              if MyModel().isSetNA(totalTickets: totalTicket) {
    //                                  ticketCell.labelWinningAmount.text = "N/A"
    //
    //                                  ticketCell.labelMaxWinner.text = "N/A(\(arrSelectedTikets[indexPath.row]["maxWinnersPrc"] as? Int ?? 0)%)"
    //
    //                                  let jticketwinning = "\(arrSelectedTikets[indexPath.row]["jticketwinning"]!)"
    //                                  if jticketwinning != "0" {
    //                                      ticketCell.jticketwinning.text = "\(MyModel().getCurrncy(value: Double(jticketwinning)!))"
    //                                  }
    //                                  else
    //                                  {
    //                                      ticketCell.jticketwinning.text = "N/A"
    //                                  }
    //
    //                                  let totalJTicketHolder = "\(arrSelectedTikets[indexPath.row]["totalJTicketHolder"] as? Int ?? 0)"
    //                                  if totalJTicketHolder != "0"
    //                                  {
    //                                      ticketCell.jticketholder.text = totalJTicketHolder
    //                                  }
    //                                  else
    //                                  {
    //                                      ticketCell.jticketholder.text = "N/A"
    //                                  }
    //
    //                                  ticketCell.perjticket.text =   "\(arrSelectedTikets[indexPath.row]["perJTicket"] as? Int ?? 0)" + "/" + "1 J ticket holder"
    //
    //                              } else {
    //
    //                                 let jticketwinning = "\(arrSelectedTikets[indexPath.row]["jticketwinning"]!)"
    //                                 if jticketwinning != "0" {
    //                                     ticketCell.jticketwinning.text = "\(MyModel().getCurrncy(value: Double(jticketwinning)!))"
    //                                 }
    //                                 else
    //                                 {
    //                                     ticketCell.jticketwinning.text = "N/A"
    //                                 }
    //
    //                                 let totalJTicketHolder = "\(arrSelectedTikets[indexPath.row]["totalJTicketHolder"] as? Int ?? 0)"
    //                                 if totalJTicketHolder != "0"
    //                                 {
    //                                     ticketCell.jticketholder.text = totalJTicketHolder
    //                                 }
    //                                 else
    //                                 {
    //                                     ticketCell.jticketholder.text = "N/A"
    //                                 }
    //
    //                                  let strWinning = "\(arrSelectedTikets[indexPath.row]["totalWinnings"]!)"
    //                                  ticketCell.labelWinningAmount.text = "\(MyModel().getCurrncy(value: Double(strWinning)!))"
    //
    //                                  let strWinners = "\(arrSelectedTikets[indexPath.row]["maxWinners"] as? Int ?? 0)"
    //                                  ticketCell.labelMaxWinner.text = "\(MyModel().getNumbers(value: Double(strWinners)!))(\(arrSelectedTikets[indexPath.row]["maxWinnersPrc"] as? Int ?? 0)%)"
    //
    //                              }
    //
    ////                if MyModel().isSetNA(totalTickets: totalTicket)  {
    ////                    ticketCell.labelWinningAmount.text = "N/A"
    ////                    ticketCell.labelMaxWinner.text = "N/A(\(arrSelectedTikets[indexPath.row]["maxWinnersPrc"] as? Int ?? 0)%)"
    ////                } else {
    ////                    let strWinning = "\(arrSelectedTikets[indexPath.row]["totalWinnings"]!)"
    ////                    ticketCell.labelWinningAmount.text = "\(MyModel().getCurrncy(value: Double(strWinning)!))"
    ////                    let strWinners = "\(arrSelectedTikets[indexPath.row]["maxWinners"] as? Int ?? 0)"
    ////                    ticketCell.labelMaxWinner.text = "\(MyModel().getNumbers(value: Double(strWinners)!))(\(arrSelectedTikets[indexPath.row]["maxWinnersPrc"] as? Int ?? 0)%)"
    ////                }
    //
    //                ticketCell.labelAnsMinus.text = arrSloats[0]["displayValue"] as? String ?? "-"
    //                ticketCell.labelAnsZero.text = arrSloats[1]["displayValue"] as? String ?? "0"
    //                ticketCell.labelAnsPlus.text = arrSloats[2]["displayValue"] as? String ?? "+"
    //
    //
    //                let string1 = arrSloats[0]["displayValue"] as? String ?? "-"
    //                               let string2 = arrSloats[2]["displayValue"] as? String ?? "-"
    //
    //                               if string1.localizedCaseInsensitiveContains("red win")
    //                               {
    //                                   ticketCell.viewRange.backgroundColor = #colorLiteral(red: 0.9019607843, green: 0.8862745098, blue: 0.8862745098, alpha: 1)
    //                                 //  ticketCell.labelAnsMinus.backgroundColor = UIColor.red
    //                                   ticketCell.labelAnsMinus.textColor = UIColor.white
    //                                ticketCell.labelAnsMinus.layer.cornerRadius = 5
    //                                ticketCell.btnAnsMinus.backgroundColor = UIColor.red
    //
    //                               }
    //                               if string2.localizedCaseInsensitiveContains("blue win")
    //                               {
    //                                 //  ticketCell.labelAnsPlus.backgroundColor = #colorLiteral(red: 0.01085097995, green: 0.3226040006, blue: 1, alpha: 1)
    //                                   ticketCell.labelAnsPlus.textColor = UIColor.white
    //                                   ticketCell.labelAnsPlus.layer.cornerRadius = 5
    //                                    ticketCell.btnAnsplus.backgroundColor = #colorLiteral(red: 0.01085097995, green: 0.3226040006, blue: 1, alpha: 1)
    //
    //                               }
    //
    //
    //                return ticketCell
    //            } else {
                    let ticketCell = tableView.dequeueReusableCell(withIdentifier: "SpinningMachineCell") as! SpinningMachineCell
                    
                    let strAmonut = "\(arrSelectedTikets[indexPath.row]["amount"] as? Double ?? 0.0)"
                    //ticketCell.labelEntryFees.text = "₹\(MyModel().getNumbers(value: Double(strAmonut)!))"
                    let test = Double(strAmonut) ?? 0.00
                    ticketCell.labelEntryFees.text = String(format: "₹ %.02f", test)
                    
                    
                    let strTickets = "\(arrSelectedTikets[indexPath.row]["totalTickets"] as? Int ?? 0)"
                    ticketCell.labelTotalTickets.text = "\(MyModel().getNumbers(value: Double(strTickets)!))"
                    
             
                    //  let totalTicket = arrSelectedTikets[indexPath.row]["totalTickets"] as? Int ?? 0

    //                if MyModel().isSetNA(totalTickets: totalTicket) {
    //                    ticketCell.labelWinningAmount.text = "N/A"
    //                    ticketCell.labelMaxWinner.text = "N/A(\(arrSelectedTikets[indexPath.row]["maxWinnersPrc"] as? Int ?? 0)%)"
    //                } else {
    //                    let strWinning = "\(arrSelectedTikets[indexPath.row]["totalWinnings"]!)"
    //                    ticketCell.labelWinningAmount.text = "\(MyModel().getCurrncy(value: Double(strWinning)!))"
    //                    let strWinners = "\(arrSelectedTikets[indexPath.row]["maxWinners"] as? Int ?? 0)"
    //                    ticketCell.labelMaxWinner.text = "\(MyModel().getNumbers(value: Double(strWinners)!))(\(arrSelectedTikets[indexPath.row]["maxWinnersPrc"] as? Int ?? 0)%)"
    //                }
                    
                    let totalTicket = arrSelectedTikets[indexPath.row]["totalTickets"] as? Int ?? 0
                                   
                                                 
                let minJoin = arrSelectedTikets[indexPath.row]["minJoin"] as? Int ?? 0
                if MyModel().isSetNA(totalTickets: totalTicket, minJoin: minJoin) {
                                                     ticketCell.labelWinningAmount.text = "N/A"
                                                     
                                                     ticketCell.labelMaxWinner.text = "N/A(\(arrSelectedTikets[indexPath.row]["maxWinnersPrc"] as? Int ?? 0)%)"
                                                     
                                                     let jticketwinning = "\(arrSelectedTikets[indexPath.row]["jticketwinning"]!)"
                                                     if jticketwinning != "0" {
                                                         ticketCell.jticketwinning.text = "\(MyModel().getCurrncy(value: Double(jticketwinning)!))"
                                                     }
                                                     else
                                                     {
                                                         ticketCell.jticketwinning.text = "N/A"
                                                     }
                                                     
                                                     let totalJTicketHolder = "\(arrSelectedTikets[indexPath.row]["totalJTicketHolder"] as? Int ?? 0)"
                                                     if totalJTicketHolder != "0"
                                                     {
                                                         ticketCell.jticketholder.text = totalJTicketHolder
                                                     }
                                                     else
                                                     {
                                                         ticketCell.jticketholder.text = "N/A"
                                                     }
                                                     
                                                  //   ticketCell.perjticket.text =   "\(arrSelectedTikets[indexPath.row]["perJTicket"] as? Int ?? 0)" + "/" + "1 J ticket holder"
                                                     
                                                 } else {
                                                     
                                                    let jticketwinning = "\(arrSelectedTikets[indexPath.row]["jticketwinning"]!)"
                                                    if jticketwinning != "0" {
                                                        ticketCell.jticketwinning.text = "\(MyModel().getCurrncy(value: Double(jticketwinning)!))"
                                                    }
                                                    else
                                                    {
                                                        ticketCell.jticketwinning.text = "N/A"
                                                    }
                                                    
                                                    let totalJTicketHolder = "\(arrSelectedTikets[indexPath.row]["totalJTicketHolder"] as? Int ?? 0)"
                                                    if totalJTicketHolder != "0"
                                                    {
                                                        ticketCell.jticketholder.text = totalJTicketHolder
                                                    }
                                                    else
                                                    {
                                                        ticketCell.jticketholder.text = "N/A"
                                                    }
                                                     
                                                     let strWinning = "\(arrSelectedTikets[indexPath.row]["totalWinnings"]!)"
                                                     ticketCell.labelWinningAmount.text = "\(MyModel().getCurrncy(value: Double(strWinning)!))"
                                                     
                                                     let strWinners = "\(arrSelectedTikets[indexPath.row]["maxWinners"] as? Int ?? 0)"
                                                     ticketCell.labelMaxWinner.text = "\(MyModel().getNumbers(value: Double(strWinners)!))(\(arrSelectedTikets[indexPath.row]["maxWinnersPrc"] as? Int ?? 0)%)"
                                                   
                                                 }
                                   
                    
                    ticketCell.arrData = arrSelectedTikets[indexPath.row]["slotes"] as? [[String: Any]]
                    
                    return ticketCell
         //       }
                
            }
        }
        else
        {
            return UITableViewCell()
        }
       
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if tableView == tableMyTickets {
            let userVC = self.storyboard?.instantiateViewController(withIdentifier: "UserListVC") as! UserListVC
            userVC.dictContestData = dictContest
            userVC.dictTicketData = arrSelectedTikets[indexPath.row]
            self.navigationController?.pushViewController(userVC, animated: true)
        }
        else
        {
            let userVC = self.storyboard?.instantiateViewController(withIdentifier: "UserListVC") as! UserListVC
            userVC.dictContestData = dictContest
            userVC.dictTicketData = arrTicket[indexPath.row]
            self.navigationController?.pushViewController(userVC, animated: true)
        }
       
    }
    
    //MARK: - TableView Button Method
    @objc func buttonSelection(_ sender: UIButton) {
        
        let index = sender.tag
        
        let isPurchased = arrTicket[index]["isPurchased"] as! Bool
        
        let dictData = arrTicket[index]
        let ticketID = dictData["contestPriceId"] as? Int ?? 0
        
        if arrSelectedTiketsPurchase.count > 0 {
            
            for (indexNo, item) in arrSelectedTiketsPurchase.enumerated() {
                let selectedTicketID = item["contestPriceId"] as? Int ?? 0
                
                if ticketID == selectedTicketID {
                    
                    arrTicket[index]["isPurchased"] = NSNumber(value: !isPurchased)
                    arrSelectedTiketsPurchase[indexNo]["isPurchased"] = NSNumber(value: !isPurchased)
                    break
                } else if indexNo == arrSelectedTiketsPurchase.count - 1 {
                    
                    arrTicket[index]["isPurchased"] = NSNumber(value: !isPurchased)
                    arrSelectedTiketsPurchase.append(arrTicket[index])
                    break
                }
            }

        } else {
            arrTicket[index]["isPurchased"] = NSNumber(value: !isPurchased)
            arrSelectedTiketsPurchase.append(arrTicket[index])
        }
        
        var totalSelected = Int()
        var totalAmount = Double()
        
        for item in arrSelectedTiketsPurchase {
            
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
        
        if Double(totalSelectedAmount) > totalAmount {
            labelPBAmount.textColor = UIColor.red
            labelPay.text = "Add to wallet"
        } else {
            labelPBAmount.textColor = Define.MAINVIEWCOLOR2
            labelPBAmount.textColor = UIColor.green
            labelPay.text = "Pay"
        }
    }
}

//MARK: - API
extension SMMyTicketVC {
    func getMyTickets() {
        Loading().showLoading(viewController: self)
        let parameter: [String: Any] = ["contest_id": dictContest["id"]!]
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
                print("Error: ", error!)
                //self.retry()
                self.getMyTickets()
            } else {
                Loading().hideLoading(viewController: self)
                print("Result: \(result!)")
                let status = result!["statusCode"] as? Int ?? 0
                if status == 200 {
                    self.dictContestDetail = result!["content"] as! [String: Any]
                    self.setDetail()
                } else if status == 401 {
                    Define.APPDELEGATE.handleLogout()
                } else {
                    Alert().showAlert(title: "Error",
                                      message: result!["message"] as! String,
                                      viewController: self)
                }
            }
        }
    }
    
    func getContestDetail() {
        Loading().showLoading(viewController: self)
        let parameter: [String: Any] = ["contest_id": dictContest["id"]!]
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
                self.getContestDetail()
            } else {
                Loading().hideLoading(viewController: self)
                print("Result: \(result!)")
                let status = result!["statusCode"] as? Int ?? 0
                if status == 200 {
                    self.dictContestDetailTicket = result!["content"] as! [String: Any]
                    print(self.dictContestDetailTicket)
                    self.setdetailsticket()
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
       
        for item in arrSelectedTiketsPurchase {
            let isSelected = item["isPurchased"] as! Bool
            if isSelected {
                let strID = "\(item["contestPriceId"]!)"
                arrSelected.append(strID)
            }
        }
        
        let strSelectedID = arrSelected.joined(separator: ",")
        
        let parameter:[String: Any] = ["contest_id": dictContest["id"]!,
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
                    
                  //  self.createReminder(strTitle: self.dictContest["name"] as? String ?? "No Name",strDate: self.dictContest["startDate"] as! String)
             //       self.createReminderbeforethirtysecond(strTitle: self.dictContest["name"] as? String ?? "No Name",strDate: self.dictContest["startDate"] as! String)
                  //  self.createReminderbeforetensecond(strTitle: self.dictContest["name"] as? String ?? "No Name",strDate: self.dictContest["startDate"] as! String)
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
                    if result!["message"] as? String ?? "No Message" == "contest is over" {
                        NotificationCenter.default.removeObserver(self)
                        self.navigationController?.popViewController(animated: true)
                    }
                    else
                    {
                        Alert().showAlert(title: "Error",
                                          message: result!["message"] as? String ?? "No Message",
                                          viewController: self)
                    }
                 
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
    
    
    func createReminderbeforetensecond(strTitle: String, strDate: String) {
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
             //  content.sound = UNNotificationSound.default
          //  content.sound = UNNotificationSound.init(named:UNNotificationSoundName(rawValue: "waiting_timer.mp3"))
            
               let reminderDate = MyModel().getDateForRemiderbeforetensecond(contestDate: strDate)
                let timeInterval = reminderDate.timeIntervalSinceNow
               let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)

               let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
               center.add(request)
            
        }
    }
    
    func createReminderbeforethirtysecond(strTitle: String, strDate: String) {
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
            
            let center = UNUserNotificationCenter.current()

            let content = UNMutableNotificationContent()
               content.title = strTitle
               content.body = "Your game starts soon, Hurry!!!!"
               content.categoryIdentifier = "alarm"
         //   content.categoryIdentifier = Define.PLAYGAME
             //  content.userInfo = ["customData": "fizzbuzz"]
          //     content.sound = UNNotificationSound.default
            content.sound = UNNotificationSound.init(named:UNNotificationSoundName(rawValue: "message_tone_lg_no.mp3"))
            
               let reminderDate = MyModel().getDateForRemiderbeforethirtysecond(contestDate: strDate)
                let timeInterval = reminderDate.timeIntervalSinceNow
               let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)

               let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
               center.add(request)
            
        }
    }

}

//MARK: - Notifcation Delegate Method
extension SMMyTicketVC: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        switch response.actionIdentifier {
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
extension SMMyTicketVC {
    func retry() {
        let alertController = UIAlertController(title: Define.ERROR_TITLE,
                                                message: Define.ERROR_SERVER,
                                                preferredStyle: .alert)
        let buttonRetry = UIAlertAction(title: "Retry",
                                        style: .default)
        { _ in
            self.getMyTickets()
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

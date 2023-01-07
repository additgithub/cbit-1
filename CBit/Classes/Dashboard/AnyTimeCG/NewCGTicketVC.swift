//
//  NewCGTicketVC.swift
//  CBit
//
//  Created by Mobcast on 14/05/22.
//  Copyright © 2022 Bhavik Kothari. All rights reserved.
//

import UIKit
import UserNotifications
import MarqueeLabel
import EventKit

class NewCGTicketVC: UIViewController {
    //MARK: - Properties
    
    @IBOutlet weak var btnselectall: UIButton!
    @IBOutlet weak var collectionviewtickets: UICollectionView!
    private var arrRandomNumbers = [Int]()
    var arrBarcketColor = [BracketData]()
    var startTimer: Timer?
    var timer: Timer?
    var seconds = Int()
    
    @IBOutlet weak var labelContestName: UILabel!
    @IBOutlet weak var tableTickets: UITableView!
    @IBOutlet weak var labelSelectedCount: UILabel!
    @IBOutlet weak var buttonPay: UIButton!
    
    //Constraint
    @IBOutlet weak var constraintPaymentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var constraintSelectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var lblgamename: UILabel!
    
    @IBOutlet weak var viewAmountMain: UIView!
    @IBOutlet weak var viewAmount: UIView!
    @IBOutlet weak var labelUtilizedbalance: UILabel!
    @IBOutlet weak var labelwidrawableBalance: UILabel!
    @IBOutlet weak var labelTotalBalance: UILabel!
    @IBOutlet weak var buttonAmountOk: UIButton!
    @IBOutlet weak var buttonAmountCancel: UIButton!
    
    //@IBOutlet weak var labelPay: UILabel!
    
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
    var gametype = ""
    @IBOutlet weak var constraintCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var constraintgamevwheight: NSLayoutConstraint!
    @IBOutlet weak var vwnumberslot: UIView!
    @IBOutlet weak var vwcolor: UIView!
    
    //MARK: - Default Method
    override func viewDidLoad() {
        super.viewDidLoad()
        SetRandomNumber()
        setStartTimer()
        tableTickets.rowHeight = UITableView.automaticDimension
        tableTickets.tableFooterView = UIView()
        if !MyModel().isConnectedToInternet() {
            Alert().showTost(message: Define.ERROR_INTERNET,
                             viewController: self)
        } else {
            getAnyTimeGameList()
        }
        
        constraintPaymentViewHeight.constant = 50
        constraintSelectionViewHeight.constant = 0
        
        if gametype == "rdb" {
            constraintgamevwheight.constant = 50
            vwnumberslot.isHidden = true
            lblgamename.text = "Blue - Red"
        }
        else
        {
            constraintgamevwheight.constant = 100
            vwcolor.isHidden = true
            lblgamename.text = "Which Colour has a bigger total?"

        }
        viewAmountMain.isHidden = true
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        labelContestName.text = dictContest["name"] as? String ?? "No Name"
        labelContestName.text = "Classic Grids"
        
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
    }
    
    @objc func handelNotifcation(_ notification: Notification) {
        print("Contest Data: \(notification.userInfo!)")
        
        if  notification.userInfo != nil {
            let dictData = notification.userInfo
            let arrData = dictData!["contest"] as! [[String: Any]]
            let strContestId = "\(dictContestDetail["id"]!)"
            
            for (_, item) in arrData.enumerated() {
                let strSelectedContestId = "\(item["contestId"]!)"
                let strContestPriceId = "\(item["contestpriceID"]!)"
                if strContestId == strSelectedContestId {
                    for (arrIndex, arrItem) in arrTicket.enumerated() {
                        let strSelectedContestPriceId = "\(arrItem["contestpriceID"]!)"
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
        arrTicket = AnyTimedictContest
        for (index, item) in arrTicket.enumerated() {
            var dictData = arrTicket[index]
            dictData["isPurchased"] =  false
            arrTicket[index] = dictData
        }
        print("➭Tickets: \(arrTicket)")
        tableTickets.reloadData()
        isDataLoaded = true
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
            paymentVC.addAmount = cutUtilized
            paymentVC.isFromLink = isFromLink
            self.navigationController?.pushViewController(paymentVC, animated: true)
        }
    }
    @IBAction func buttonAmountOK(_ sender: UIButton) {
       // joinContest()
        let CGGamePlayVC = self.storyboard?.instantiateViewController(withIdentifier: "NewCGGamePlayVC") as! NewCGGamePlayVC
        CGGamePlayVC.dictContest = dictContestDetail
        CGGamePlayVC.isFromNotification = false
        CGGamePlayVC.arrSelectedTikets = arrSelectedTikets
        CGGamePlayVC.AnyTimedictContest = AnyTimedictContest
        //gamePlayVC.dictGameData = dictGameData
        self.navigationController?.pushViewController(CGGamePlayVC, animated: true)
    }
    
    @IBAction func buttonAmountCancel(_ sender: UIButton) {
        viewAmountMain.isHidden = true
    }
    
    @IBAction func btn_selectall(_ sender: Any) {
        
        let i = 0
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
            //  labelPurchasedAmount.text = String(format: "₹%.2f", totalAmount)//"₹\(totalAmount)"
            
            setSelectedData()
            isFromButtonClick = true
            
            let indexPath = IndexPath(row: index, section: 0)
            tableTickets.reloadRows(at: [indexPath], with: .none)
        }
    }
    
    @IBAction func PlayAll_click(_ sender: UIButton) {
    }
    
    func SetRandomNumber() {
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

extension NewCGTicketVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
extension NewCGTicketVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrTicket.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if gametype == "rdb" {
            let ticketCell = tableView.dequeueReusableCell(withIdentifier: "ThreeSloatTVC") as! ThreeSloatTVC
            
            ticketCell.labelAnsMinus.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            ticketCell.labelAnsZero.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
            ticketCell.labelAnsPlus.backgroundColor = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
            
            ticketCell.labelAnsMinus.text = "Red Win"
            ticketCell.labelAnsZero.text = "Draw"
            ticketCell.labelAnsPlus.text = "Blue Win"
            
            ticketCell.viewRange.backgroundColor = UIColor.lightGray
            ticketCell.labelAnsMinus.textColor = UIColor.white
            ticketCell.labelAnsZero.textColor = UIColor.black
            ticketCell.labelAnsPlus.textColor = UIColor.white
           
            let isPurchased = arrTicket[indexPath.row]["isPurchased"] as? Bool ?? false
            if isPurchased {
                //ticketCell.buttonSelection.backgroundColor = UIColor.black.withAlphaComponent(0.4)
              //  btnselectall.setImage(#imageLiteral(resourceName: "ic_checked"), for: .normal)
                ticketCell.buttonSelectTicket.setImage(#imageLiteral(resourceName: "ic_checked"), for: .normal)
            } else {
                //ticketCell.buttonSelection.backgroundColor = UIColor.clear
              //  btnselectall.setImage(#imageLiteral(resourceName: "ic_unchecked"), for: .normal)
                ticketCell.buttonSelectTicket.setImage(#imageLiteral(resourceName: "ic_unchecked"), for: .normal)
            }
            view.layoutIfNeeded()
            
            let strAmonut = "\(arrTicket[indexPath.row]["amount"] as? Double ?? 0.0)"
            let test = Double(strAmonut) ?? 0.00
            ticketCell.labelEntryFees.text = String(format: "₹ %.02f", test)
            
         
            ticketCell.labelTotalTickets.text = "\(arrTicket[indexPath.row]["no_of_players"]!)"
            
    
    let strWinning = "\(arrTicket[indexPath.row]["winningAmount"]!)"
    ticketCell.labelWinningAmount.text = "\(MyModel().getCurrncy(value: Double(strWinning)!))"
    
    let strWinners = "\(arrTicket[indexPath.row]["no_of_winners"] as? Int ?? 0)"
    ticketCell.labelMaxWinner.text = "\(MyModel().getNumbers(value: Double(strWinners)!))"
            
            ticketCell.buttonSelectTicket.addTarget(self,
                                                    action: #selector(buttonSelection(_:)),for: .touchUpInside)
            ticketCell.buttonSelectTicket.tag = indexPath.row
            return ticketCell

        }
        else
        {
            let ticketCell = tableView.dequeueReusableCell(withIdentifier: "NewCGTicketSloteTVC") as! NewCGTicketSloteTVC
            
//            ticketCell.labelAnsMinus.text = "0 to 3"
//            ticketCell.labelAnsZero.text = "4 to 6"
//            ticketCell.labelAnsPlus.text = "7 to 9"
//
//            ticketCell.viewRange.backgroundColor = #colorLiteral(red: 0, green: 0.2549019608, blue: 0, alpha: 1)
//            ticketCell.labelAnsMinus.textColor = #colorLiteral(red: 0, green: 0.2549019608, blue: 0, alpha: 1)
//            ticketCell.labelAnsZero.textColor = #colorLiteral(red: 0, green: 0.2549019608, blue: 0, alpha: 1)
//            ticketCell.labelAnsPlus.textColor = #colorLiteral(red: 0, green: 0.2549019608, blue: 0, alpha: 1)
               
            self.view.layoutIfNeeded()
            let isPurchased = arrTicket[indexPath.row]["isPurchased"] as? Bool ?? false
            if isPurchased {
                //ticketCell.buttonSelection.backgroundColor = UIColor.black.withAlphaComponent(0.4)
              //  btnselectall.setImage(#imageLiteral(resourceName: "ic_checked"), for: .normal)
                ticketCell.buttonSelectTicket.setImage(#imageLiteral(resourceName: "ic_checked"), for: .normal)
            } else {
                //ticketCell.buttonSelection.backgroundColor = UIColor.clear
              //  btnselectall.setImage(#imageLiteral(resourceName: "ic_unchecked"), for: .normal)
                ticketCell.buttonSelectTicket.setImage(#imageLiteral(resourceName: "ic_unchecked"), for: .normal)
            }
            view.layoutIfNeeded()
                
                let strAmonut = "\(arrTicket[indexPath.row]["amount"] as? Double ?? 0.0)"
                let test = Double(strAmonut) ?? 0.00
                ticketCell.labelEntryFees.text = String(format: "₹ %.02f", test)
                //ticketCell.labelEntryFees.text = "₹\(MyModel().getNumbers(value: Double(strAmonut)!))"
                let strTickets = "\(arrTicket[indexPath.row]["totalTickets"] as? Int ?? 0)"
                ticketCell.labelTotalTickets.text = "\(MyModel().getNumbers(value: Double(strTickets)!))"
            
            let strWinning = "\(arrTicket[indexPath.row]["winningAmount"]!)"
            ticketCell.labelWinningAmount.text = "\(MyModel().getCurrncy(value: Double(strWinning)!))"
            
            let strWinners = "\(arrTicket[indexPath.row]["no_of_winners"] as? Int ?? 0)"
            ticketCell.labelMaxWinner.text = "\(MyModel().getNumbers(value: Double(strWinners)!))"
                
                ticketCell.arrData = nil
            var ticketdataarr = [[String:Any]]()
            
        let slotes = arrTicket[indexPath.row]["slotes"] as? String ?? "0"
          //  for _ in 1..<Int(slotes)! {
                if slotes == "3" {
                    ticketdataarr.append(["displayValue":"0 to 3"])
                    ticketdataarr.append(["displayValue":"4 to 6"])
                    ticketdataarr.append(["displayValue":"7 to 9"])
                }
                else
                {
                    ticketdataarr.append(["displayValue":"0 to 5"])
                    ticketdataarr.append(["displayValue":"6 to 9"])
                }
        //    }
                ticketCell.arrData = ticketdataarr
                
                ticketCell.buttonSelectTicket.addTarget(self,
                                                     action: #selector(buttonSelection(_:)),
                                                     for: .touchUpInside)
                ticketCell.buttonSelectTicket.tag = indexPath.row
                self.view.layoutIfNeeded()
                return ticketCell
            
        }
                
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
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
           // labelPBAmount.textColor = UIColor.red
          //  labelPay.text = "Add to wallet"
            buttonPay.setTitle("Add to wallet", for: .normal)
        } else {
         //   labelPBAmount.textColor = Define.MAINVIEWCOLOR2
          //  labelPBAmount.textColor = UIColor.green
         //   labelPay.text = "Play"
            buttonPay.setTitle("Play", for: .normal)
        }
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
extension NewCGTicketVC {
    func getAnyTimeGameList() {
        Loading().showLoading(viewController: self)
        let parameter: [String: Any] = ["isSpinningMachine":"0","game_type":gametype]
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
                        self.setDetail()
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
    
   
    
  
    
    
    func getDateForRemider(contestDate: String) -> Date {
        
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let startDate = dateFormater.date(from: contestDate)
        
        let calendar = NSCalendar.current
        let minusDate = calendar.date(byAdding: .second, value: -180, to: startDate!)
        
        return minusDate!
    }
    
    
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

//MARK: - Notifcation Delegate Method
//extension CGTicketVC: UNUserNotificationCenterDelegate {
//
//    func userNotificationCenter(_ center: UNUserNotificationCenter,
//                                willPresent notification: UNNotification,
//                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        completionHandler([.alert, .sound])
//
//    }
//    func userNotificationCenter(_ center: UNUserNotificationCenter,
//                                didReceive response: UNNotificationResponse,
//                                withCompletionHandler completionHandler: @escaping () -> Void) {
//        switch response.actionIdentifier
//        {
//
//
//        case Define.PLAYGAME:
//            print("Play Game")
//            let dictData = response.notification.request.content.userInfo as! [String: Any]
//            print(dictData)
//            let gamePlayVC = self.storyboard?.instantiateViewController(withIdentifier: "GamePlayVC") as! GamePlayVC
//            gamePlayVC.isFromNotification = true
//            gamePlayVC.dictContest = dictData
//            self.navigationController?.pushViewController(gamePlayVC, animated: true)
//        default:
//            break
//        }
//
//    }
//
//}



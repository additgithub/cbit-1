import UIKit
import UserNotifications

class GameResultVC: UIViewController {
    //MARK: - Properties
    
    @IBOutlet weak var lbltitle: UILabel!
    @IBOutlet weak var lblnowin: UILabel!
    @IBOutlet weak var ccwinning: UILabel!
    @IBOutlet weak var totalblue: UILabel!
    @IBOutlet weak var totalred: UILabel!
    @IBOutlet weak var labelContestName: UILabel!
    @IBOutlet weak var collectionGameView: UICollectionView!
    @IBOutlet weak var labelAnswer: UILabel!
    @IBOutlet weak var tableResult: UITableView!
    @IBOutlet weak var labelWinningAmount: UILabel!
    
    @IBOutlet weak var constraintCollectionViewHeight: NSLayoutConstraint!
    var dictContest = [String: Any]()
    var gamelevel = Int()
    
    var arrBrackets = [[String: Any]]()
    var arrTiclets = [[String: Any]]()
    var arrSelectedTickets = [[String: Any]]()
    
    var dictContestDetail = [String: Any]()
    var isfirstarr = [Bool]()
    //MARK: - Default Method
    override func viewDidLoad() {
        super.viewDidLoad()
        tableResult.rowHeight = UITableView.automaticDimension
        tableResult.tableFooterView = UIView()
        UNUserNotificationCenter.current().delegate = self
        
        getContestDetail()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        labelContestName.text = dictContest["name"] as? String ?? "No Name"
    }
    
    func setDetail() {
        
        lbltitle.text = dictContestDetail["title"] as? String
        
        let gametype = "\(dictContestDetail["game_type"]!)"
        
        
        if gametype == "0-9"
        {
            labelAnswer.text = "Blue - Red = \(dictContestDetail["answer"]!)"
        }
        else{
            labelAnswer.isHidden = true
        }
        
        
        
        totalred.text = "Blue Total : \(dictContestDetail["blue"]!)"
        totalblue.text = "Red Total : \(dictContestDetail["red"]!)"
        
        
        arrBrackets = dictContestDetail["boxJson"] as! [[String: Any]]
        arrTiclets = dictContestDetail["tickets"] as! [[String: Any]]
        let winAmount = Double(dictContestDetail["totalWinAmount"] as? String ?? "0.0")!
        let NowinAmount = Double(dictContestDetail["nowin"] as? String ?? "0.0")!
        labelWinningAmount.text = "Winnings : ₹\(winAmount)"
        lblnowin.text = "Refund : ₹\(NowinAmount)"
        
        let winCCAmount = Double(dictContestDetail["totalCCWinAmount"] as? String ?? "0.0")!
        ccwinning.text = "Reclamation : CC \(winCCAmount)"
        
        
        for item in arrTiclets {
            let isPurchased = item["isPurchased"] as? Bool ?? false
            if isPurchased {
                arrSelectedTickets.append(item)
            }
        }
        
        for _ in arrSelectedTickets {
            isfirstarr.append(true)
        }
        
        gamelevel = dictContestDetail["level"] as? Int ?? 1
        
        if gamelevel == 1 {
            constraintCollectionViewHeight.constant = 50
        } else if gamelevel == 2 {
            constraintCollectionViewHeight.constant = 100
        } else if gamelevel == 3 {
            constraintCollectionViewHeight.constant = 200
        }
        
        tableResult.reloadData()
        collectionGameView.reloadData()
    }
    
    //MAKR: - Buttom Method
    @IBAction func buttonBack(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}

//MAKR: - Collection View Delegate Mehtod
extension GameResultVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrBrackets.count
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
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BracketCVC", for: indexPath) as! BracketCVC
        
        cell.labelNumber.text = "\(arrBrackets[indexPath.row]["number"] as? Int ?? 0)"
        
        let strColor = arrBrackets[indexPath.row]["color"] as? String ?? "red"
        
        if strColor == "red" {
            cell.viewColor.backgroundColor = UIColor.red
        } else if strColor == "green" {
            cell.viewColor.backgroundColor = UIColor.green
        } else if strColor == "blue" {
            cell.viewColor.backgroundColor = UIColor.blue
        }
        
        return cell
    }
}

//MAKR: - TableView Delegate Method
extension GameResultVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSelectedTickets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let gameMode = dictContest["type"] as? Int ?? 0
        if gameMode == 0 {
            let ticketCell = tableView.dequeueReusableCell(withIdentifier: "TicketTVC") as! TicketTVC
            
            let isAlreadyPurchase = arrSelectedTickets[indexPath.row]["isAlreadyPurchase"] as? Bool ?? false
            
            
            
            let strAmonut = "\(arrSelectedTickets[indexPath.row]["amount"] as? Double ?? 0.0)"
            //ticketCell.labelEntryFees.text = "₹\(MyModel().getNumbers(value: Double(strAmonut)!))"
            
            let test = Double(strAmonut) ?? 0.00
            ticketCell.labelEntryFees.text = String(format: "₹ %.02f", test)
            //print(String(format: "%.02f", test))
            
            
            let strTickets = "\(arrSelectedTickets[indexPath.row]["totalTickets"] as? Int ?? 0)"
            ticketCell.labelTotalTicket.text = "\(MyModel().getNumbers(value: Double(strTickets)!))"
            
            let range = arrSelectedTickets[indexPath.row]["bracketSize"] as? Int ?? 0
            let rangeMin = dictContestDetail["ansRangeMin"] as? Int ?? 0
            let rangeMax = dictContestDetail["ansRangeMax"] as? Int ?? 0
            
            ticketCell.imageBar.image = MyModel().getImageForRange(range: range, rangeMaxValue: abs(rangeMin - rangeMax))
            ticketCell.labelBar.text = "\(range)"
            
            let totalTicket = arrSelectedTickets[indexPath.row]["totalTickets"] as? Int ?? 0
            
            let minJoin = arrSelectedTickets[indexPath.row]["minJoin"] as? Int ?? 0
            if MyModel().isSetNA(totalTickets: totalTicket, minJoin: minJoin) {
                ticketCell.labelWinningAmount.text = "N/A"
                ticketCell.labelMaxWinner.text = "N/A(\(arrSelectedTickets[indexPath.row]["maxWinnersPrc"] as? Int ?? 0)%)"
            } else {
                let strWinning = "\(arrSelectedTickets[indexPath.row]["totalWinnings"]!)"
                ticketCell.labelWinningAmount.text = "\(MyModel().getCurrncy(value: Double(strWinning)!))"
                let strWinners = "\(arrSelectedTickets[indexPath.row]["maxWinners"] as? Int ?? 0)"
                ticketCell.labelMaxWinner.text = "\(MyModel().getNumbers(value: Double(strWinners)!))(\(arrSelectedTickets[indexPath.row]["maxWinnersPrc"] as? Int ?? 0)%)"
                
                
            }
            
            
            ticketCell.labelMinRange.text = "\(dictContestDetail["ansRangeMin"] as? Int ?? 0)"
            ticketCell.labelMaxRange.text = "\(dictContestDetail["ansRangeMax"] as? Int ?? 0)"
            
            return ticketCell
        } else {
            let arrSloats = arrSelectedTickets[indexPath.row]["slotes"] as! [[String: Any]]
            if arrSloats.count == 3 {
                let ticketCell = tableView.dequeueReusableCell(withIdentifier: "ThreeSloatTVC") as! ThreeSloatTVC
                
                let isAlreadyPurchase = arrSelectedTickets[indexPath.row]["isAlreadyPurchase"] as? Bool ?? false
                
                let strAmonut = "\(arrSelectedTickets[indexPath.row]["amount"] as? Double ?? 0.0)"
                let test = Double(strAmonut) ?? 0.00
                ticketCell.labelEntryFees.text = String(format: "₹ %.02f", test)
                
                
                //ticketCell.labelEntryFees.text = "₹\(MyModel().getNumbers(value: Double(strAmonut)!))"
                let strTickets = "\(arrSelectedTickets[indexPath.row]["totalTickets"] as? Int ?? 0)"
                ticketCell.labelTotalTickets.text = "\(MyModel().getNumbers(value: Double(strTickets)!))"
                
                let totalTicket = arrSelectedTickets[indexPath.row]["totalTickets"] as? Int ?? 0
                
                let minJoin = arrSelectedTickets[indexPath.row]["minJoin"] as? Int ?? 0
                if MyModel().isSetNA(totalTickets: totalTicket, minJoin: minJoin) {
                    ticketCell.labelWinningAmount.text = "N/A"
                    
                    ticketCell.labelMaxWinner.text = "N/A(\(arrSelectedTickets[indexPath.row]["maxWinnersPrc"] as? Int ?? 0)%)"
                    
                } else {
                    
                    let strWinning = "\(arrSelectedTickets[indexPath.row]["totalWinnings"]!)"
                    ticketCell.labelWinningAmount.text = "\(MyModel().getCurrncy(value: Double(strWinning)!))"
                    
                    let strWinners = "\(arrSelectedTickets[indexPath.row]["maxWinners"] as? Int ?? 0)"
                    ticketCell.labelMaxWinner.text = "\(MyModel().getNumbers(value: Double(strWinners)!))(\(arrSelectedTickets[indexPath.row]["maxWinnersPrc"] as? Int ?? 0)%)"
                    
                    let strWinAmount = "\(arrSelectedTickets[indexPath.row]["winAmount"]!)"
                    ticketCell.labelAmount.text = "Win: \(MyModel().getCurrncy(value: Double(strWinAmount)!))"
                    
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
                
                
                let dictSelectedData = arrSelectedTickets[indexPath.row]["user_select"] as! [String: Any]
                let strValue = "\(dictSelectedData["displayValue"] as? String ?? "0")"
                
//                if (strValue == "Red win" || strValue == "0 To 3") && isfirstarr[indexPath.row] == true
//                        {
//                            isfirstarr[indexPath.row] = false
////                            ticketCell.labelAnsMinus.layer.borderColor = UIColor.black.cgColor
////                            ticketCell.labelAnsMinus.layer.borderWidth = 3
////                            ticketCell.labelAnsZero.layer.borderWidth = 0
////                            ticketCell.labelAnsPlus.layer.borderWidth = 0
//                            
//                            func anotherFuncname() {
//                                    //statements of inner function
//                                ticketCell.contentView.backgroundColor = UIColor.white
//                                UIView.animate(withDuration: 1.0,
//                                    animations: {
//                                        ticketCell.labelAnsMinus.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
//                                    },
//                                    completion: { _ in
//                                        UIView.animate(withDuration: 1.0) {
//                                            ticketCell.labelAnsMinus.transform = CGAffineTransform.identity
//                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                                                anotherFuncname()
//                                            }
//                                            
//                                        }
//                                    })
//
//                                }
//                            anotherFuncname()
//                        }
//                        else if (strValue == "Blue win" || strValue == "7 To 9") && isfirstarr[indexPath.row] == true
//                        {
//                            isfirstarr[indexPath.row] = false
////                            ticketCell.labelAnsPlus.layer.borderColor = UIColor.black.cgColor
////                            ticketCell.labelAnsMinus.layer.borderWidth = 0
////                            ticketCell.labelAnsZero.layer.borderWidth = 0
////                            ticketCell.labelAnsPlus.layer.borderWidth = 3
//                            
//                            func anotherFuncname() {
//                                UIView.animate(withDuration: 1.0,
//                                    animations: {
//                                        ticketCell.labelAnsPlus.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
//                                    },
//                                    completion: { _ in
//                                        UIView.animate(withDuration: 1.0) {
//                                            ticketCell.labelAnsPlus.transform = CGAffineTransform.identity
//                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                                                anotherFuncname()
//                                            }
//                                            
//                                        }
//                                    })
//
//                                }
//                            anotherFuncname()
//                        }
//                        else if (strValue == "Draw" || strValue == "4 To 6")  && isfirstarr[indexPath.row] == true
//                        {
//                            isfirstarr[indexPath.row] = false
////                            ticketCell.labelAnsZero.layer.borderColor = UIColor.black.cgColor
////                            ticketCell.labelAnsMinus.layer.borderWidth = 0
////                            ticketCell.labelAnsZero.layer.borderWidth = 3
////                            ticketCell.labelAnsPlus.layer.borderWidth = 0
//                            
//                            func anotherFuncname() {
//                                UIView.animate(withDuration: 1.0,
//                                    animations: {
//                                        ticketCell.labelAnsZero.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
//                                    },
//                                    completion: { _ in
//                                        UIView.animate(withDuration: 1.0) {
//                                            ticketCell.labelAnsZero.transform = CGAffineTransform.identity
//                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                                                anotherFuncname()
//                                            }
//                                            
//                                        }
//                                    })
//
//                                }
//                            anotherFuncname()
//                        }
//                        else
//                        {
////                            ticketCell.labelAnsMinus.layer.borderWidth = 0
////                            ticketCell.labelAnsZero.layer.borderWidth = 0
////                            ticketCell.labelAnsPlus.layer.borderWidth = 0
//
//                        }
                
                let isLock = arrSelectedTickets[indexPath.row]["isLock"] as? Bool ?? false
                
                if isLock {
                    ticketCell.labelAnswer.text = "Your Selection  \(strValue)"
                    ticketCell.labelLoackedAt.text = "Locked At  \(arrSelectedTickets[indexPath.row]["lockTime"] as? String ?? "--:--:--")"
                } else {
                    ticketCell.labelAnswer.text = "\(strValue)"
                    ticketCell.labelLoackedAt.text = ""
                    
                }
                
                let isCancel = arrSelectedTickets[indexPath.row]["isCancel"] as? Bool ?? false
                
                if isCancel {
                    ticketCell.buttonSelectTicket.backgroundColor = UIColor.red
                    ticketCell.buttonSelectTicket.setTitleColor(UIColor.white, for: .normal)
                    ticketCell.buttonSelectTicket.setTitle("Cancelled", for: .normal)
                    ticketCell.buttonSelectTicket.removeTarget(self, action: nil, for: .touchUpInside)
                    ticketCell.labelAnswer.text = ""
                    ticketCell.labelLoackedAt.text = ""
                    
                } else {
                    ticketCell.buttonSelectTicket.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
                    ticketCell.buttonSelectTicket.setTitleColor( #colorLiteral(red: 0, green: 0.4, blue: 0.5725490196, alpha: 1), for: .normal)
                    ticketCell.buttonSelectTicket.setTitle("View Winners", for: .normal)
                    ticketCell.buttonSelectTicket.addTarget(self,
                                                            action: #selector(buttonViewWinners(_:)),
                                                            for: .touchUpInside)
                    ticketCell.buttonSelectTicket.tag = indexPath.row
                }
                
                
          
                
                
                return ticketCell
            } else {
                let ticketCell = tableView.dequeueReusableCell(withIdentifier: "TicketSloteTVC") as! TicketSloteTVC
                self.view.layoutIfNeeded()
                
                
                let strAmonut = "\(arrSelectedTickets[indexPath.row]["amount"] as? Double ?? 0.0)"
                let test = Double(strAmonut) ?? 0.00
                ticketCell.labelEntryFees.text = String(format: "₹ %.02f", test)
                //ticketCell.labelEntryFees.text = "₹\(MyModel().getNumbers(value: Double(strAmonut)!))"
                let strTickets = "\(arrSelectedTickets[indexPath.row]["totalTickets"] as? Int ?? 0)"
                ticketCell.labelTotalTickets.text = "\(MyModel().getNumbers(value: Double(strTickets)!))"
                
                let totalTicket = arrSelectedTickets[indexPath.row]["totalTickets"] as? Int ?? 0
                
                
                let minJoin = arrSelectedTickets[indexPath.row]["minJoin"] as? Int ?? 0
                if MyModel().isSetNA(totalTickets: totalTicket, minJoin: minJoin) {
                    ticketCell.labelWinningAmount.text = "N/A"
                    
                    ticketCell.labelMaxWinner.text = "N/A(\(arrSelectedTickets[indexPath.row]["maxWinnersPrc"] as? Int ?? 0)%)"
                    
                } else {
                    
                    let strWinning = "\(arrSelectedTickets[indexPath.row]["totalWinnings"]!)"
                    ticketCell.labelWinningAmount.text = "\(MyModel().getCurrncy(value: Double(strWinning)!))"
                    
                    let strWinners = "\(arrSelectedTickets[indexPath.row]["maxWinners"] as? Int ?? 0)"
                    ticketCell.labelMaxWinner.text = "\(MyModel().getNumbers(value: Double(strWinners)!))(\(arrSelectedTickets[indexPath.row]["maxWinnersPrc"] as? Int ?? 0)%)"
                    
                    let strWinAmount = "\(arrSelectedTickets[indexPath.row]["winAmount"]!)"
                    ticketCell.labelAmount.text = "Win: \(MyModel().getCurrncy(value: Double(strWinAmount)!))"
                }
                ticketCell.arrData = nil
                ticketCell.arrData = arrSelectedTickets[indexPath.row]["slotes"] as? [[String: Any]]
                self.view.layoutIfNeeded()
                
                
                let dictSelectedData = arrSelectedTickets[indexPath.row]["user_select"] as! [String: Any]
                let strValue = "\(dictSelectedData["displayValue"] as? String ?? "0")"
                let isLock = arrSelectedTickets[indexPath.row]["isLock"] as? Bool ?? false
                
                if isLock {
                    ticketCell.labelAnswer.text = "Your Selection  \(strValue)"
                    ticketCell.labelLoackedAt.text = "Locked At  \(arrSelectedTickets[indexPath.row]["lockTime"] as? String ?? "--:--:--")"
                } else {
                    ticketCell.labelAnswer.text = "\(strValue)"
                    ticketCell.labelLoackedAt.text = ""
                    
                }
                
                let isCancel = arrSelectedTickets[indexPath.row]["isCancel"] as? Bool ?? false
                
                if isCancel {
                    ticketCell.buttonSelectTicket.backgroundColor = UIColor.red
                    ticketCell.buttonSelectTicket.setTitleColor(UIColor.white, for: .normal)
                    ticketCell.buttonSelectTicket.setTitle("Cancelled", for: .normal)
                    ticketCell.buttonSelectTicket.removeTarget(self, action: nil, for: .touchUpInside)
                    ticketCell.labelAnswer.text = ""
                    ticketCell.labelLoackedAt.text = ""
                    
                } else {
                    ticketCell.buttonSelectTicket.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
                    ticketCell.buttonSelectTicket.setTitleColor( #colorLiteral(red: 0, green: 0.4, blue: 0.5725490196, alpha: 1), for: .normal)
                    ticketCell.buttonSelectTicket.setTitle("View Winners", for: .normal)
                    ticketCell.buttonSelectTicket.addTarget(self,
                                                            action: #selector(buttonViewWinners(_:)),
                                                            for: .touchUpInside)
                    ticketCell.buttonSelectTicket.tag = indexPath.row
                }
                
                
                return ticketCell
            }
            
        }
    }
    
    //    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //        let resultCell = tableView.dequeueReusableCell(withIdentifier: "GameResultTVC") as! GameResultTVC
    //
    //        let strAmount = "\(arrSelectedTickets[indexPath.row]["amount"] as? Double ?? 0.0)"
    //        //resultCell.labelEntryFees.text = "₹\(MyModel().getNumbers(value: Double(strAmount)!))"
    //        let test = Double(strAmount) ?? 0.00
    //        resultCell.labelEntryFees.text = String(format: "₹ %.02f", test)
    //
    //        let strTickets = "\(arrSelectedTickets[indexPath.row]["totalTickets"]!)"
    //        resultCell.labelTotalTickets.text = "\(MyModel().getNumbers(value: Double(strTickets)!))"
    //        let strWinnings = "\(arrSelectedTickets[indexPath.row]["totalWinnings"]!)"
    //        resultCell.labelTotalWinnings.text = "\(MyModel().getCurrncy(value: Double(strWinnings)!))"
    //        let strWinners = "\(arrSelectedTickets[indexPath.row]["maxWinners"]!)"
    //        resultCell.labelMaxWinner.text = "\(MyModel().getNumbers(value: Double(strWinners)!))"
    //
    //        let dictSelectedData = arrSelectedTickets[indexPath.row]["user_select"] as! [String: Any]
    //        print("Data: \(dictSelectedData)")
    //        let strValue = "\(dictSelectedData["displayValue"] as? String ?? "0")"
    //
    //        if strValue == "Red win"
    //        {
    //            resultCell.btnred.layer.borderColor = UIColor.black.cgColor
    //            resultCell.btnred.layer.borderWidth = 2
    //            resultCell.btndraw.layer.borderWidth = 0
    //            resultCell.btnblue.layer.borderWidth = 0
    //        }
    //        else if strValue == "Blue win"
    //        {
    //            resultCell.btnblue.layer.borderColor = UIColor.black.cgColor
    //            resultCell.btnred.layer.borderWidth = 0
    //            resultCell.btndraw.layer.borderWidth = 0
    //            resultCell.btnblue.layer.borderWidth = 2
    //        }
    //        else
    //        {
    //            resultCell.btndraw.layer.borderColor = UIColor.black.cgColor
    //            resultCell.btnred.layer.borderWidth = 0
    //            resultCell.btndraw.layer.borderWidth = 2
    //            resultCell.btnblue.layer.borderWidth = 0
    //        }
    //
    //        let isLock = arrSelectedTickets[indexPath.row]["isLock"] as? Bool ?? false
    //
    //        if isLock {
    //            resultCell.labelAnswer.text = "Your Selection  \(strValue)"
    //            resultCell.labelLoackedAt.text = "Locked At  \(arrSelectedTickets[indexPath.row]["lockTime"] as? String ?? "--:--:--")"
    //        } else {
    //            resultCell.labelAnswer.text = "\(strValue)"
    //            resultCell.labelLoackedAt.text = ""
    //
    //        }
    //
    //        let isCancel = arrSelectedTickets[indexPath.row]["isCancel"] as? Bool ?? false
    //
    //        if isCancel {
    //            resultCell.buttonViewWinners.backgroundColor = UIColor.red
    //            resultCell.labelViewWinners.textColor = UIColor.white
    //            resultCell.labelViewWinners.text = "Cancelled"
    //            resultCell.buttonViewWinners.removeTarget(self, action: nil, for: .touchUpInside)
    //            resultCell.labelAnswer.text = ""
    //            resultCell.labelLoackedAt.text = ""
    //
    //        } else {
    //            resultCell.buttonViewWinners.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
    //            resultCell.labelViewWinners.textColor = #colorLiteral(red: 0, green: 0.4, blue: 0.5725490196, alpha: 1)
    //            resultCell.labelViewWinners.text = "View Winners"
    //            resultCell.buttonViewWinners.addTarget(self,
    //                                                   action: #selector(buttonViewWinners(_:)),
    //                                                   for: .touchUpInside)
    //            resultCell.buttonViewWinners.tag = indexPath.row
    //        }
    //
    //        let totalTicket = arrSelectedTickets[indexPath.row]["totalTickets"] as? Int ?? 0
    //
    //        if MyModel().isSetNA(totalTickets: totalTicket) {
    //            resultCell.labelTotalWinnings.text = "N/A"
    //            resultCell.labelMaxWinner.text = "N/A"
    //        } else {
    //            resultCell.labelTotalWinnings.text = "₹\(arrSelectedTickets[indexPath.row]["totalWinnings"]!)"
    //            resultCell.labelMaxWinner.text = "\(arrSelectedTickets[indexPath.row]["maxWinners"]!)"
    //            let strWinAmount = "\(arrSelectedTickets[indexPath.row]["winAmount"]!)"
    //            resultCell.labelAmount.text = "Win: \(MyModel().getCurrncy(value: Double(strWinAmount)!))"
    //        }
    //
    //        return resultCell
    //    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MAKR: - TableView Button
    @objc func buttonViewWinners(_ sender: UIButton) {
        let index = sender.tag
        let winnerVC = self.storyboard?.instantiateViewController(withIdentifier: "ViewWinnersVC") as! ViewWinnersVC
        winnerVC.dictTicket = arrSelectedTickets[index]
        let startDate = MyModel().converStringToDate(strDate: dictContestDetail["startDate"] as! String,
                                                     getFormate: "yyyy-MM-dd HH:mm:ss")
        
        winnerVC.startDate = startDate
        winnerVC.dictContest = dictContest
        self.navigationController?.pushViewController(winnerVC, animated: true)
    }
}
//MARK: - API
extension GameResultVC {
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
                //                Alert().showAlert(title: "Error",
                //                                  message: Define.ERROR_SERVER,
                //                                  viewController: self)
                self.getContestDetail()
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
                                      message: result!["message"] as! String,
                                      viewController: self)
                }
            }
        }
    }
}

//MARK: - Notifcation Delegate Method
extension GameResultVC: UNUserNotificationCenterDelegate {
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
extension GameResultVC {
    func retry() {
        let alertController = UIAlertController(title: Define.ERROR_TITLE,
                                                message: Define.ERROR_SERVER,
                                                preferredStyle: .alert)
        let buttonRetry = UIAlertAction(title: "Retry",
                                        style: .default)
        { _ in
            self.getContestDetail()
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

//MAKR: - TableView Cell Class
class GameResultTVC: UITableViewCell {
    
    @IBOutlet weak var labelEntryFees: LableWithLightBG!
    @IBOutlet weak var labelTotalTickets: LableWithLightBG!
    @IBOutlet weak var labelTotalWinnings: LableWithLightBG!
    @IBOutlet weak var labelMaxWinner: LableWithLightBG!
    @IBOutlet weak var labelLoackedAt: UILabel!
    @IBOutlet weak var labelAnswer: UILabel!
    @IBOutlet weak var labelAmount: UILabel!
    @IBOutlet weak var buttonViewWinners: UIButton!
    @IBOutlet weak var labelViewWinners: UILabel!
    @IBOutlet weak var btnred: ButtonWithRadius!
    @IBOutlet weak var btndraw: ButtonWithRadius!
    @IBOutlet weak var btnblue: ButtonWithRadius!
    @IBOutlet weak var img0: UIImageView!
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var lblplaypending: UILabel!
    @IBOutlet weak var lblgameno: UILabel!
    @IBOutlet weak var imgselectedans: UIImageView!
    
    
    @IBOutlet weak var collectionlist: UICollectionView!
    
    var arrSloats = [[String: Any]]()
    var strDisplayValue = String()
    
    //    var arrData:[[String: Any]]? {
    //        didSet {
    //            guard let arrList = arrData else { return }
    //            arrSloats = arrList
    //            collectionlist.reloadData()
    //        }
    //    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        buttonViewWinners.layer.cornerRadius = 5
        buttonViewWinners.layer.masksToBounds = true
        
        collectionlist?.delegate = self
        collectionlist?.dataSource = self
        self.viewDidLayoutSubviews()
//        collectionlist.layer.cornerRadius = 10
//        collectionlist.layer.borderWidth = 2
//        collectionlist.layer.borderColor = UIColor.black.cgColor
        
        
    }
    
    func viewDidLayoutSubviews() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let section = 0
        let lastItemIndex = self.collectionlist.numberOfItems(inSection: section) - 1
        let indexPath:NSIndexPath = NSIndexPath.init(item: lastItemIndex, section: section)
        self.collectionlist.scrollToItem(at: indexPath as IndexPath, at: .right, animated: true)
        }
       }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}

extension GameResultTVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrSloats.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if arrSloats.count == 2 {
            return CGSize(width: 50, height: 50)
        } else {
            return CGSize(width: 50, height: 50)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let lockcell = collectionView.dequeueReusableCell(withReuseIdentifier: "lockallcell", for: indexPath) as! lockallcell
        
        if strDisplayValue == arrSloats[indexPath.row]["displayValue"] as? String ?? "" {
//            lockcell.contentView.layer.borderColor = UIColor.black.cgColor
//            lockcell.contentView.layer.borderWidth = 2
        }
        else
        {
//            lockcell.contentView.layer.borderColor = UIColor.black.cgColor
//            lockcell.contentView.layer.borderWidth = 0
        }
        
        let strDisplayValue = arrSloats[indexPath.row]["displayValue"] as! String
        
        if strDisplayValue == "Draw" {
            let strMainString = strDisplayValue.replacingOccurrences(of: " ", with: "\n")
            lockcell.labelDisplayValue.text = strMainString
            lockcell.labelDisplayValue.isHidden = false
            lockcell.img.isHidden = true
        }
        else
        {
            lockcell.labelDisplayValue.isHidden = true
            lockcell.img.isHidden = false
            let localimg = loadImageFromDocumentDirectory(nameOfImage: arrSloats[indexPath.row]["displayValue"] as! String)
            lockcell.img.image =  localimg//.imageByMakingWhiteBackgroundTransparent()
        }
        
        return lockcell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        //Where elements_count is the count of all your items in that
        //Collection view...
        if collectionView == collectionlist {
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
            let image    = UIImage(contentsOfFile: imageURL.path) ?? UIImage()
            return image
        }
        return UIImage.init(named: "default.png")!
    }
}

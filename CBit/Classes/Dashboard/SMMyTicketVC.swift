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
    
    var dictContest = [String: Any]()

    private var dictContestDetail = [String: Any]()
    private var arrTickets = [[String: Any]]()
    private var arrSelectedTikets = [[String: Any]]()
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        labelContestName.text = dictContest["name"] as? String ?? "No Name"
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
    
    //MARK: - Button Method
    @IBAction func buttonBack(_ sender: Any) {
        NotificationCenter.default.removeObserver(self)
        navigationController?.popViewController(animated: true)
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSelectedTikets.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
            
            if MyModel().isSetNA(totalTickets: totalTicket) {
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
                               
                                             
                                             if MyModel().isSetNA(totalTickets: totalTicket) {
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let userVC = self.storyboard?.instantiateViewController(withIdentifier: "UserListVC") as! UserListVC
        userVC.dictContestData = dictContest
        userVC.dictTicketData = arrSelectedTikets[indexPath.row]
        self.navigationController?.pushViewController(userVC, animated: true)
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

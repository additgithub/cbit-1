//
//  NewCGGameResultVC.swift
//  CBit
//
//  Created by Mobcast on 14/05/22.
//  Copyright © 2022 Bhavik Kothari. All rights reserved.
//

import UIKit

class NewCGGameResultVC: UIViewController {
    //MARK: - øL,.Properties
    
    
    @IBOutlet weak var totalblue: UILabel!
    @IBOutlet weak var totalred: UILabel!
    @IBOutlet weak var labelContestName: UILabel!
    @IBOutlet weak var collectionGameView: UICollectionView!
    @IBOutlet weak var labelAnswer: UILabel!
    @IBOutlet weak var tableResult: UITableView!
    
    @IBOutlet weak var constraintCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var lblgamename: UILabel!
    @IBOutlet weak var lblcontestname: UILabel!
    var dictContest = [String: Any]()
    var gamelevel = Int()
    
    var arrBrackets = [[String: Any]]()
    var arrTiclets = [[String: Any]]()
    var arrSelectedTickets = [[String: Any]]()
    
    var dictContestDetail = [String: Any]()
    var isfromhistory = false
    var arrSelectedTikets = [[String: Any]]()
    var gametype = String()
    
    //MARK: - Default Method
    override func viewDidLoad() {
        super.viewDidLoad()
        tableResult.rowHeight = UITableView.automaticDimension
        tableResult.tableFooterView = UIView()
      //  UNUserNotificationCenter.current().delegate = self
        
        if isfromhistory {
            getContestDetailHistory()
        }
        else
        {
            getContestDetail()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    func setDetail() {
      gametype = "\(dictContestDetail["game_type"]!)"
        
        
    if gametype == "0-9"
    {
         labelAnswer.text = "Blue - Red = \(dictContestDetail["answer"]!)"
        lblcontestname.text = "Blue - Red"
        lblgamename.text = "Blue - Red"

        }
    else{
        labelAnswer.isHidden = true
        lblcontestname.text = "Which Colour has a bigger total?"
        lblgamename.text = "Which Colour has a bigger total?"
        }
        
       
        
        totalred.text = "Blue Total : \(dictContestDetail["blue"]!)"
        totalblue.text = "Red Total : \(dictContestDetail["red"]!)"
        
        
        arrBrackets = dictContestDetail["boxJson"] as! [[String: Any]]
        arrTiclets = dictContestDetail["tickets"] as! [[String: Any]]
//        let winAmount = Double(dictContestDetail["totalWinAmount"] as? String ?? "0.0")!
//        let NowinAmount = Double(dictContestDetail["nowin"] as? String ?? "0.0")!
//        labelWinningAmount.text = "You win ₹\(winAmount)"
//        lblnowin.text = "No win ₹\(NowinAmount)"
//
//        let winCCAmount = Double(dictContestDetail["totalCCWinAmount"] as? String ?? "0.0")!
//        ccwinning.text = "You win CC \(winCCAmount)"
        
        
        for item in arrTiclets {
            let isPurchased = item["isPurchased"] as? Bool ?? false
            if isPurchased {
                arrSelectedTickets.append(item)
            }
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
extension NewCGGameResultVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
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
extension NewCGGameResultVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSelectedTickets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let resultCell = tableView.dequeueReusableCell(withIdentifier: "GameResultTVC") as! GameResultTVC

        if gametype == "rdb" {
            resultCell.vwrdb.isHidden = false
            resultCell.vwnumberslot.isHidden = true
            resultCell.labelAnsMinus.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            resultCell.labelAnsZero.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
            resultCell.labelAnsPlus.backgroundColor = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
            
            resultCell.labelAnsMinus.text = "Red Win"
            resultCell.labelAnsZero.text = "Draw"
            resultCell.labelAnsPlus.text = "Blue Win"
            
         //   resultCell.vwrdb.backgroundColor = UIColor.lightGray
            resultCell.labelAnsMinus.textColor = UIColor.white
            resultCell.labelAnsZero.textColor = UIColor.black
            resultCell.labelAnsPlus.textColor = UIColor.white
           
            view.layoutIfNeeded()

        }
        else
        {
            resultCell.vwrdb.isHidden = true
            resultCell.vwnumberslot.isHidden = false
            self.view.layoutIfNeeded()
            resultCell.isfromnumberslot = true
            resultCell.arrData = nil
           // var ticketdataarr = [[String:Any]]()
            
//        let slotes = arrSelectedTickets[indexPath.row]["slotes"] as? String ?? "0"
//                if slotes == "3" {
//                    ticketdataarr.append(["displayValue":"0 to 3"])
//                    ticketdataarr.append(["displayValue":"4 to 6"])
//                    ticketdataarr.append(["displayValue":"7 to 9"])
//                }
//                else
//                {
//                    ticketdataarr.append(["displayValue":"0 to 5"])
//                    ticketdataarr.append(["displayValue":"6 to 9"])
//                }
            resultCell.arrData = arrSelectedTickets[indexPath.row]["slotes"] as? [[String:Any]] ?? []
                
                self.view.layoutIfNeeded()
            
        }
        
        let game_no = arrSelectedTickets[indexPath.row]["game_no"] as? Int ?? 0
        
        resultCell.lblgameno.text = "Game No: \(game_no)"
        resultCell.lblplaypending.text = "\(arrSelectedTickets[indexPath.row]["played"]!) Played /\(arrSelectedTickets[indexPath.row]["pending"]!) Pending"
        
        let strAmount = "\(arrSelectedTickets[indexPath.row]["amount"] as? Double ?? 0.0)"
        //resultCell.labelEntryFees.text = "₹\(MyModel().getNumbers(value: Double(strAmount)!))"
        let test = Double(strAmount) ?? 0.00
        resultCell.labelEntryFees.text = String(format: "₹ %.02f", test)
        
        let strTickets = "\(arrSelectedTickets[indexPath.row]["no_of_players"]!)"
        resultCell.labelTotalTickets.text = "\(MyModel().getNumbers(value: Double(strTickets)!))"
        let strWinnings = "\(arrSelectedTickets[indexPath.row]["totalWinnings"]!)"
        resultCell.labelTotalWinnings.text = "\(MyModel().getCurrncy(value: Double(strWinnings)!))"
        let strWinners = "\(arrSelectedTickets[indexPath.row]["maxWinners"]!)"
        resultCell.labelMaxWinner.text = "\(MyModel().getNumbers(value: Double(strWinners)!))"
        
        let dictSelectedData = arrSelectedTickets[indexPath.row]["user_select"] as! [String: Any]
        print("Data: \(dictSelectedData)")
        let strValue = "\(dictSelectedData["selectValue"] as? String ?? "0")"
        
        if strValue == "Red"
        {
            resultCell.btnred.layer.borderColor = UIColor.black.cgColor
            resultCell.btnred.layer.borderWidth = 2
            resultCell.btndraw.layer.borderWidth = 0
            resultCell.btnblue.layer.borderWidth = 0
        }
        else if strValue == "Blue"
        {
            resultCell.btnblue.layer.borderColor = UIColor.black.cgColor
            resultCell.btnred.layer.borderWidth = 0
            resultCell.btndraw.layer.borderWidth = 0
            resultCell.btnblue.layer.borderWidth = 2
        }
        else
        {
            resultCell.btndraw.layer.borderColor = UIColor.black.cgColor
            resultCell.btnred.layer.borderWidth = 0
            resultCell.btndraw.layer.borderWidth = 2
            resultCell.btnblue.layer.borderWidth = 0
        }
        
        let isLock = arrSelectedTickets[indexPath.row]["isLock"] as? Bool ?? false
        
        if isLock {
            let win = arrSelectedTickets[indexPath.row]["win"] as? Int ?? 0
            if win == 0
            {
                resultCell.lbllockedtext.text = "You chose wrong answer in \(arrSelectedTickets[indexPath.row]["lockTime"] as? String ?? "--:--:--")"
            }
            else
            {
                resultCell.lbllockedtext.text = "You chose right answer in \(arrSelectedTickets[indexPath.row]["lockTime"] as? String ?? "--:--:--")"
            }
            resultCell.labelAnswer.text = "Your Selection  \(strValue)"
            resultCell.labelLoackedAt.text = "Locked At  \(arrSelectedTickets[indexPath.row]["lockTime"] as? String ?? "--:--:--")"

        } else {
            resultCell.labelAnswer.text = "\(strValue)"
            resultCell.labelLoackedAt.text = ""
            resultCell.lbllockedtext.text = ""
        }
        
        let isCancel = arrSelectedTickets[indexPath.row]["isCancel"] as? Bool ?? false
        
        if isCancel {
            resultCell.buttonViewWinners.backgroundColor = UIColor.red
            resultCell.labelViewWinners.textColor = UIColor.white
            resultCell.labelViewWinners.text = "Cancelled"
            resultCell.buttonViewWinners.removeTarget(self, action: nil, for: .touchUpInside)
            resultCell.labelAnswer.text = ""
            resultCell.labelLoackedAt.text = ""
            
        } else {
            resultCell.buttonViewWinners.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
            resultCell.labelViewWinners.textColor = #colorLiteral(red: 0, green: 0.4, blue: 0.5725490196, alpha: 1)
            resultCell.labelViewWinners.text = "View Winners"
            resultCell.buttonViewWinners.addTarget(self,
                                                   action: #selector(buttonViewWinners(_:)),
                                                   for: .touchUpInside)
            resultCell.buttonViewWinners.tag = indexPath.row
        }
        
        let totalTicket = arrSelectedTickets[indexPath.row]["totalTickets"] as? Int ?? 0
        
        let minJoin = arrSelectedTickets[indexPath.row]["minJoin"] as? Int ?? 0
        if MyModel().isSetNA(totalTickets: totalTicket, minJoin: minJoin) {
            resultCell.labelTotalWinnings.text = "N/A"
            resultCell.labelMaxWinner.text = "N/A"
        } else {
            resultCell.labelTotalWinnings.text = "₹\(arrSelectedTickets[indexPath.row]["totalWinnings"]!)"
            resultCell.labelMaxWinner.text = "\(arrSelectedTickets[indexPath.row]["maxWinners"]!)"
            let strWinAmount = "\(arrSelectedTickets[indexPath.row]["totalCCWinAmount"]!)"
            resultCell.labelAmount.text = "Points : CC \(MyModel().getCurrncy(value: Double(strWinAmount)!))"
        }
        if ("\(arrSelectedTickets[indexPath.row]["pending"]!)" == "0") {
//                    viewHolder.tvViewWinner.setVisibility(View.VISIBLE);
//                    viewHolder.tvWinnings.setVisibility(View.VISIBLE);
            resultCell.vwwinamount.isHidden = false
            resultCell.buttonViewWinners.isHidden = false
            resultCell.labelViewWinners.isHidden = false

                    if ("\(arrSelectedTickets[indexPath.row]["totalCCWinAmount"]!)" != "0") {
                      //  viewHolder.tvWinnings.setText("Points : CC " + ticketList.get(i).getTotalCCWinAmount());
                        resultCell.labelAmount.text = "Points : CC \(arrSelectedTickets[indexPath.row]["totalCCWinAmount"]!)"

                    } else if ("\(arrSelectedTickets[indexPath.row]["nowin"]!)" != "0") {
                       // viewHolder.tvWinnings.setText("Refund : " + ticketList.get(i).getNowin());
                        resultCell.labelAmount.text = "Refund : \(arrSelectedTickets[indexPath.row]["nowin"]!)"

                    }  else if ("\(arrSelectedTickets[indexPath.row]["winAmount"]!)" != "0") {
                      //  viewHolder.tvWinnings.setText("Win : " + Utils.getCurrencyFormat(String.valueOf(ticketList.get(i).getWinAmount())));
                        resultCell.labelAmount.text = "Win : \(arrSelectedTickets[indexPath.row]["winAmount"]!)"

                    }else {
                       // viewHolder.tvWinnings.setText("Win : " + Utils.getCurrencyFormat(String.valueOf(ticketList.get(i).getWinAmount())));
                        resultCell.labelAmount.text = "Win : \(arrSelectedTickets[indexPath.row]["winAmount"]!)"
                    }
            //07944444121 - 20003847183
                }
        else
        {
            resultCell.vwwinamount.isHidden = true
            resultCell.buttonViewWinners.isHidden = true
            resultCell.labelViewWinners.isHidden = true
        }
        return resultCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MAKR: - TableView Button
    @objc func buttonViewWinners(_ sender: UIButton) {
        let index = sender.tag
        let storyBoard : UIStoryboard = UIStoryboard(name: "Dashboard", bundle:nil)
        let winnerVC = storyBoard.instantiateViewController(withIdentifier: "ViewWinnersVC") as! ViewWinnersVC
        winnerVC.dictTicket = arrSelectedTickets[index]
//        let startDate = MyModel().converStringToDate(strDate: dictContestDetail["startDate"] as! String,
//                                                     getFormate: "yyyy-MM-dd HH:mm:ss")
//        
//        winnerVC.startDate = startDate
        winnerVC.dictContest = dictContest
        winnerVC.isfromanytime = true

        self.navigationController?.pushViewController(winnerVC, animated: true)
    }
}
//MARK: - API
extension NewCGGameResultVC {
    func getContestDetail() {
        Loading().showLoading(viewController: self)
      //  let parameter: [String: Any] = ["contest_id": dictContest["id"]!]
        var arrSelectedcontestid = [String]()
        var arrSelectedticketsIds = [String]()
        var arrallselected = [[String:Any]]()
        var selecteddict = [String:Any]()
       var arrgameno =  [String]()
        
        for item in arrSelectedTikets {
            let isSelected = item["isPurchased"] as! Bool
            if isSelected {
                let strID = "\(item["contestpriceID"]!)"
                arrSelectedticketsIds.append(strID)
                
                let strcontestId = "\(item["contestId"]!)"
                arrSelectedcontestid.append(strcontestId)
                
                let strgame_played = "\(item["game_played"]!)"
                arrgameno.append(strgame_played)
                
                selecteddict["game_no"] = strgame_played
                selecteddict["contestPriceId"] = strID
//                let newdict = NSMutableDictionary()
//                newdict.setObject(strgame_played, forKey: "game_no" as NSCopying)
//                newdict.setObject(strID, forKey: "contestPriceId" as NSCopying)
                arrallselected.append(selecteddict)
            }
        }
        
        let strSelectedID = arrSelectedcontestid.joined(separator: ",")
        let strSelectedID1 = arrSelectedticketsIds.joined(separator: ",")
        let strSelectedID2 = arrgameno.joined(separator: ",")
        
        
        let parameter:[String: Any] = [ "contest_id": strSelectedID, "GameNo":strSelectedID2,"contest_price_id":strSelectedID1,"contest_price_game_list":MyModel().getJSONString(object: arrallselected)!]
        
        print("Parameter: \(parameter)")
        
        let jsonString = MyModel().getJSONString(object: parameter)
        let encriptString = MyModel().encrypting(strData: jsonString!, strKey: Define.KEY)
        let strBase64 = encriptString.toBase64()
        let sendRequestTime = Date()
           
            let strURL = Define.APP_URL + Define.API_CONTEST_DETAILANYTIME
            
//            let jsonString = MyModel().getJSONString(object: parameter)
//            let encriptString = MyModel().encrypting(strData: jsonString!, strKey: Define.KEY)
//            let strBase64 = encriptString.toBase64()


        SwiftAPI().postMethodSecure(stringURL: strURL,
                                    parameters: ["data":strBase64!],
                                    header: Define.USERDEFAULT.value(forKey: "AccessToken") as? String,
                                    auther: Define.USERDEFAULT.value(forKey: "UserID") as? String)
        { [self] (result, error) in
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

                    labelContestName.text = dictContestDetail["name"] as? String ?? "No Name"
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
    func getContestDetailHistory()
    {
        Loading().showLoading(viewController: self)
        var dict = [String:Any]()
        dict["game_no"] = dictContest["game_no"]!
        dict["contestPriceId"] = dictContest["contestPriceID"]!
        var arrallselected = [[String:Any]]()
        arrallselected.append(dict)
        let parameter: [String: Any] = ["contest_id": dictContest["id"]!,
                                        "GameNo": dictContest["game_no"]!,
                                        "contest_price_id": dictContest["contestPriceID"]!,
                                        "contest_price_game_list": MyModel().getJSONString(object: arrallselected)!]
//        let parameter: [String: Any] = ["contest_id": dictContest["id"]!,
//                                        "GameNo": dictContest["game_no"]!,
//                                        "contest_price_id": dictContest["contestPriceID"]!
//        ]
        let strURL = Define.APP_URL + Define.contestDetailsAnyTimeGame
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
                self.getContestDetailHistory()
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
//extension CGGameResultVC: UNUserNotificationCenterDelegate {
//    func userNotificationCenter(_ center: UNUserNotificationCenter,
//                                willPresent notification: UNNotification,
//                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        completionHandler([.alert, .sound])
//    }
//    func userNotificationCenter(_ center: UNUserNotificationCenter,
//                                didReceive response: UNNotificationResponse,
//                                withCompletionHandler completionHandler: @escaping () -> Void) {
//        switch response.actionIdentifier {
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
//}

//MARK: - Alert Contollert
extension NewCGGameResultVC {
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
//
//  CGGameResultVC.swift
//  CBit
//
//  Created by Nirmal Bodar on 22/02/21.
//  Copyright © 2021 Bhavik Kothari. All rights reserved.
//

import UIKit

class CGGameResultVC: UIViewController {
    //MARK: - Properties
    
    
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
        labelWinningAmount.text = "You win ₹\(winAmount)"
        lblnowin.text = "No win ₹\(NowinAmount)"
        
        let winCCAmount = Double(dictContestDetail["totalCCWinAmount"] as? String ?? "0.0")!
        ccwinning.text = "You win CC \(winCCAmount)"
        
        
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
extension CGGameResultVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
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
extension CGGameResultVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSelectedTickets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let resultCell = tableView.dequeueReusableCell(withIdentifier: "GameResultTVC") as! GameResultTVC
        
        let strAmount = "\(arrSelectedTickets[indexPath.row]["amount"] as? Double ?? 0.0)"
        //resultCell.labelEntryFees.text = "₹\(MyModel().getNumbers(value: Double(strAmount)!))"
        let test = Double(strAmount) ?? 0.00
        resultCell.labelEntryFees.text = String(format: "₹ %.02f", test)
        
        let strTickets = "\(arrSelectedTickets[indexPath.row]["totalTickets"]!)"
        resultCell.labelTotalTickets.text = "\(MyModel().getNumbers(value: Double(strTickets)!))"
        let strWinnings = "\(arrSelectedTickets[indexPath.row]["totalWinnings"]!)"
        resultCell.labelTotalWinnings.text = "\(MyModel().getCurrncy(value: Double(strWinnings)!))"
        let strWinners = "\(arrSelectedTickets[indexPath.row]["maxWinners"]!)"
        resultCell.labelMaxWinner.text = "\(MyModel().getNumbers(value: Double(strWinners)!))"
        
        let dictSelectedData = arrSelectedTickets[indexPath.row]["user_select"] as! [String: Any]
        print("Data: \(dictSelectedData)")
        let strValue = "\(dictSelectedData["displayValue"] as? String ?? "0")"
        
        if strValue == "Red win"
        {
            resultCell.btnred.layer.borderColor = UIColor.black.cgColor
            resultCell.btnred.layer.borderWidth = 2
            resultCell.btndraw.layer.borderWidth = 0
            resultCell.btnblue.layer.borderWidth = 0
        }
        else if strValue == "Blue win"
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
            resultCell.labelAnswer.text = "Your Selection  \(strValue)"
            resultCell.labelLoackedAt.text = "Locked At  \(arrSelectedTickets[indexPath.row]["lockTime"] as? String ?? "--:--:--")"
        } else {
            resultCell.labelAnswer.text = "\(strValue)"
            resultCell.labelLoackedAt.text = ""
            
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
        
        if MyModel().isSetNA(totalTickets: totalTicket) {
            resultCell.labelTotalWinnings.text = "N/A"
            resultCell.labelMaxWinner.text = "N/A"
        } else {
            resultCell.labelTotalWinnings.text = "₹\(arrSelectedTickets[indexPath.row]["totalWinnings"]!)"
            resultCell.labelMaxWinner.text = "\(arrSelectedTickets[indexPath.row]["maxWinners"]!)"
//            let strWinAmount = "\(arrSelectedTickets[indexPath.row]["winAmount"]!)"
//            resultCell.labelAmount.text = "Win: \(MyModel().getCurrncy(value: Double(strWinAmount)!))"
        }
        
        return resultCell
    }
    
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
extension CGGameResultVC {
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
extension CGGameResultVC: UNUserNotificationCenterDelegate {
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
extension CGGameResultVC {
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

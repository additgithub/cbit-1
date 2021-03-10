//
//  CreatePrivateGroupVC.swift
//  CBit
//
//  Created by Emp-Mac-1 on 29/01/21.
//  Copyright © 2021 Bhavik Kothari. All rights reserved.
//

import UIKit
import M13Checkbox
import DropDown

class CreatePrivateGroupVC: UIViewController {

    @IBOutlet weak var chkeasy: M13Checkbox!
    @IBOutlet weak var chkmoderate: M13Checkbox!
    @IBOutlet weak var chkpro: M13Checkbox!
    @IBOutlet weak var chk1: M13Checkbox!
    @IBOutlet weak var chk2: M13Checkbox!
    @IBOutlet weak var chk3: M13Checkbox!
    
    @IBOutlet weak var chkClassic: M13Checkbox!
    @IBOutlet weak var chkSpinning: M13Checkbox!
    
    private var arrUserGroupList = [AllUserListData]()
    
    @IBOutlet weak var img_spinningmachine: UIImageView!
    @IBOutlet weak var collectionviewtickets: UICollectionView!
    private var arrRandomNumbers = [Int]()
    var arrBarcketColor = [BracketData]()
    var startTimer: Timer?
    var timer: Timer?
    var seconds = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        SetRandomNumber()
        setStartTimer()
        
        img_spinningmachine.isHidden = true
        collectionviewtickets.isHidden = true
        
        let chkarr = [chk1,chk2,chk3,chkeasy,chkmoderate,chkpro,chkClassic,chkSpinning]
        
        for chk in chkarr {
            chk?.markType = .radio
            chk?.boxType = .circle
            chk?.tintColor = #colorLiteral(red: 0.1019607843, green: 0.3098039216, blue: 0.3647058824, alpha: 1)
            chk?.secondaryTintColor = #colorLiteral(red: 0.1019607843, green: 0.3098039216, blue: 0.3647058824, alpha: 1)
            chk?.stateChangeAnimation = .fill
        }
        
        chk1.checkState = .checked
        chkeasy.checkState = .checked
        
        
        MyUserGroupList()
        
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
    
    @IBAction func btn_CHOOSE_GAME(_ sender: M13Checkbox) {
        if sender.tag == 0
        {
            chkClassic.checkState = .checked
            chkSpinning.checkState = .unchecked
            img_spinningmachine.isHidden = true
            collectionviewtickets.isHidden = false
        }
        else
        {
            chkClassic.checkState = .unchecked
            chkSpinning.checkState = .checked
            img_spinningmachine.isHidden = false
            collectionviewtickets.isHidden = true
        }
    }
    
    @IBAction func easy_click(_ sender: M13Checkbox) {
        chkeasy.checkState = .checked
        chkmoderate.checkState = .unchecked
        chkpro.checkState = .unchecked
    }
    @IBAction func moderate_click(_ sender: M13Checkbox) {
        chkeasy.checkState = .unchecked
        chkmoderate.checkState = .checked
        chkpro.checkState = .unchecked
    }
    @IBAction func pro_click(_ sender: M13Checkbox) {
        chkeasy.checkState = .unchecked
        chkmoderate.checkState = .unchecked
        chkpro.checkState = .checked
    }
    @IBAction func chk1_click(_ sender: M13Checkbox) {
        chk1.checkState = .checked
        chk2.checkState = .unchecked
        chk3.checkState = .unchecked
    }
    @IBAction func chk2_click(_ sender: M13Checkbox) {
        chk1.checkState = .unchecked
        chk2.checkState = .checked
        chk3.checkState = .unchecked
    }
    @IBAction func chk3_click(_ sender: M13Checkbox) {
        chk1.checkState = .unchecked
        chk2.checkState = .unchecked
        chk3.checkState = .checked
    }
    
    
    

    @IBAction func back_click(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func choosegame_click(_ sender: UIButton) {
        let  dropDown1 = DropDown()
                
             // dropDown1.dataSource = self.TimeList.compactMap{$0["StartTime"] as? String}
        let pgname = arrUserGroupList.map { $0.privateGroupName }
        
        dropDown1.dataSource = pgname as! [String]
        dropDown1.anchorView =  sender
              
                dropDown1.selectionAction = {
                  
                  [unowned self] (index: Int, item: String) in
                  print("Selected item: \(item) at index: \(index)")
                    sender.setTitle(item, for: .normal)
              }
              dropDown1.show()
    }
    @IBAction func numberofoption_click(_ sender: UIButton) {
        let  dropDown1 = DropDown()
                
             // dropDown1.dataSource = self.TimeList.compactMap{$0["StartTime"] as? String}
        
        dropDown1.dataSource = ["Game","Classic Grids","Spinning Machine"]
        dropDown1.anchorView =  sender
              
                dropDown1.selectionAction = {
                  
                  [unowned self] (index: Int, item: String) in
                  print("Selected item: \(item) at index: \(index)")
                    sender.setTitle(item, for: .normal)
              }
              dropDown1.show()
    }
    @IBAction func numberofitem_click(_ sender: UIButton) {
        let  dropDown1 = DropDown()
                
             // dropDown1.dataSource = self.TimeList.compactMap{$0["StartTime"] as? String}
        
        dropDown1.dataSource = ["1","2","3","4","5","6","7","8"]
        dropDown1.anchorView =  sender
              
                dropDown1.selectionAction = {
                  
                  [unowned self] (index: Int, item: String) in
                  print("Selected item: \(item) at index: \(index)")
                    sender.setTitle(item, for: .normal)
              }
              dropDown1.show()
    }
    @IBAction func numberof_click(_ sender: UIButton) {
        let  dropDown1 = DropDown()
                
             // dropDown1.dataSource = self.TimeList.compactMap{$0["StartTime"] as? String}
        
        dropDown1.dataSource = ["Win,draw,win","Win,win,win","Win,win,win,win","Win,win,win,win,win"]
        dropDown1.anchorView =  sender
              
                dropDown1.selectionAction = {
                  
                  [unowned self] (index: Int, item: String) in
                  print("Selected item: \(item) at index: \(index)")
                    sender.setTitle(item, for: .normal)
              }
              dropDown1.show()
    }
    @IBAction func next_click(_ sender: UIButton) {
    }
    
    
    func MyUserGroupList() {
        Loading().showLoading(viewController: self)
        let parameter: [String: Any] = [
            "userID":Define.USERDEFAULT.value(forKey: "UserID") as? String ?? ""
        ]
        let strURL = Define.APP_URL + Define.ALL_USER_PRIVATE_GROUP
        print("Parameter: \(parameter)\nURL: \(strURL)")
        
        let jsonString = MyModel().getJSONString(object: parameter)
        let encriptString = MyModel().encrypting(strData: jsonString!, strKey: Define.KEY)
        let strBase64 = encriptString.toBase64()
        
        SwiftAPI().postMethodSecure(stringURL: strURL,
                                    parameters: ["data": strBase64!],
                                    header: Define.USERDEFAULT.value(forKey: "AccessToken") as? String,
                                    auther: Define.USERDEFAULT.value(forKey: "UserID") as? String)
        { (result, error) in
            if error != nil {
                Loading().hideLoading(viewController: self)
                print("Error: \(error!.localizedDescription)")
                self.retry()
            } else {
                Loading().hideLoading(viewController: self)
                print("Result: \(result!)")
                let status = result!["statusCode"] as? Int ?? 0
                if status == 200 {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: result!, options: .prettyPrinted)
                        // here "jsonData" is the dictionary encoded in JSON data

                        let allUserListModel = try? JSONDecoder().decode(AllUserListModel.self, from: jsonData)
                        
                        self.arrUserGroupList = allUserListModel?.content ?? [AllUserListData]()
                        
                        
                    } catch {
                        print(error.localizedDescription)
                    }
                    
                    
                    
                } else if status == 401 {
                    Define.APPDELEGATE.handleLogout()
                } else {
                    Alert().showAlert(title: "Alert",
                                      message: result!["message"] as! String,
                                      viewController: self)
                }
            }
        }
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
                let rangeMinNumber = 0
                let rangeMaxNumber = 99
                
            let gamelevel = 1
          
                if gamelevel == 1 {
                    arrRandomNumbers = MyModel().createRandomNumbers(number: 8, minRange: rangeMinNumber, maxRange: rangeMaxNumber)
                    arrBarcketColor = MyDataType().getArrayBrackets(index: 8)
                    //constraintCollectionViewHeight.constant = 50
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

extension CreatePrivateGroupVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       

        return arrRandomNumbers.count
    
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionviewtickets.frame.width / 4, height: 25)
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

extension CreatePrivateGroupVC {
    func retry() {
        let alertController = UIAlertController(title: Define.ERROR_TITLE,
                                                message: Define.ERROR_SERVER,
                                                preferredStyle: .alert)
        let buttonRetry = UIAlertAction(title: "Retry",
                                        style: .default)
        { _ in
            self.MyUserGroupList()
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

//
//  JTredingVC.swift
//  CBit
//
//  Created by Nirmal Bodar on 21/09/21.
//  Copyright © 2021 Bhavik Kothari. All rights reserved.
//

import UIKit

class sectioncollcell: UICollectionViewCell {
    @IBOutlet weak var lblsection: UILabel!
    @IBOutlet weak var lblvalue: UILabel!
    
}

class demandcollcell: UICollectionViewCell {
    @IBOutlet weak var lblsection: UILabel!
    @IBOutlet weak var lblpercent: UILabel!
    @IBOutlet weak var lblJT: UILabel!
    
}

class supplycollcell: UICollectionViewCell {
    @IBOutlet weak var lblsection: UILabel!
    @IBOutlet weak var lblpercent: UILabel!
    @IBOutlet weak var lblJT: UILabel!
}

class JTredingVC: UIViewController {

    @IBOutlet weak var lblgreenzone: UILabel!

    @IBOutlet weak var collectionsection: UICollectionView!
    @IBOutlet weak var collectiondemand: UICollectionView!
    @IBOutlet weak var collectionsupply: UICollectionView!
    @IBOutlet weak var collsectionheight: NSLayoutConstraint!
    
    var ticketid = String()
    var DemandTArr = [[String:Any]]()
    var SectionsArr = [[String:Any]]()
    var SupplyTArr = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let width = ((collectionsection.frame.width)/2)
        let layoutsection = collectionsection?.collectionViewLayout as! UICollectionViewFlowLayout
        layoutsection.itemSize = CGSize(width: width, height: 80)
        
        let layoutdemand = collectiondemand?.collectionViewLayout as! UICollectionViewFlowLayout
        layoutdemand.itemSize = CGSize(width: 60, height: 70)
        
        let layoutsupply = collectionsupply?.collectionViewLayout as! UICollectionViewFlowLayout
        layoutsupply.itemSize = CGSize(width: 60, height: 70)
        
        getjtradingInfo()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collsectionheight.constant = collectionsection.collectionViewLayout.collectionViewContentSize.height
        print("Height:",collectionsection.contentSize.height)
        collectionsection.setNeedsLayout()
        collectionsection.layoutIfNeeded()
        self.view.layoutIfNeeded()
    }
    
    // MARK: - Button Action Method
    
    @IBAction func Back_click(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func exclusive_click(_ sender: UIButton) {
    }
    
}

// MARK: - CollectionView DataSource
extension JTredingVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionsection {
            return SectionsArr.count
        }
        if collectionView == collectiondemand {
            return DemandTArr.count
        }
        if collectionView == collectionsupply {
            return SupplyTArr.count
        }
        return 0
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionsection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sectioncollcell", for: indexPath) as! sectioncollcell
            cell.lblsection.text = SectionsArr[indexPath.row]["section"] as? String
            cell.lblvalue.text = SectionsArr[indexPath.row]["value"] as? String
            cell.layoutIfNeeded()
            return cell
        }
        if collectionView == collectiondemand {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "demandcollcell", for: indexPath) as! demandcollcell
            cell.lblsection.text = DemandTArr[indexPath.row]["Section_alias"] as? String
            cell.lblpercent.text = DemandTArr[indexPath.row]["trade_percentage"] as? String
            cell.lblJT.text = "(\(DemandTArr[indexPath.row]["trade_quantity"] as? String ?? "") JT)"
            return cell
        }
        if collectionView == collectionsupply {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "supplycollcell", for: indexPath) as! supplycollcell
            cell.lblsection.text = SupplyTArr[indexPath.row]["Section_alias"] as? String
            cell.lblpercent.text = SupplyTArr[indexPath.row]["supply_percentage"] as? String
            cell.lblJT.text = "(\(SupplyTArr[indexPath.row]["supply_quantity"] as? String ?? "") JT)"
            return cell
        }
       return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collectionsection {
            let sectionid =  (SectionsArr[indexPath.row] as AnyObject).value(forKey: "section_id") as! Int
            let JTredingDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "JTredingDetailVC") as! JTredingDetailVC
            JTredingDetailVC.modalPresentationStyle = .fullScreen
            JTredingDetailVC.section_id = String(sectionid)
            self.present(JTredingDetailVC, animated: true, completion: nil)

        }
//        if collectionView == collectiondemand {
//            let sectionid =  (DemandTArr[indexPath.row] as AnyObject).value(forKey: "section_id") as! Int
//            let JTredingDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "JTredingDetailVC") as! JTredingDetailVC
//            JTredingDetailVC.modalPresentationStyle = .fullScreen
//            JTredingDetailVC.section_id = String(sectionid)
//            self.present(JTredingDetailVC, animated: true, completion: nil)
//        }
//        if collectionView == collectionsupply {
//            let sectionid =  (SupplyTArr[indexPath.row] as AnyObject).value(forKey: "section_id") as! Int
//            let JTredingDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "JTredingDetailVC") as! JTredingDetailVC
//            JTredingDetailVC.modalPresentationStyle = .fullScreen
//            JTredingDetailVC.section_id = String(sectionid)
//            self.present(JTredingDetailVC, animated: true, completion: nil)
//        }
    }
}

// MARK: - API
extension JTredingVC
{
    func getjtradingInfo() {
      
        Loading().showLoading(viewController: self)
        
        let parameter: [String: Any] = [
            "ticket_id":ticketid,
        ]
        let strURL = Define.APP_URL + Define.jtradingInfo
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
            } else {
                Loading().hideLoading(viewController: self)
                print("Result: \(result!)")
                let status = result!["statusCode"] as? Int ?? 0
                if status == 200 {
                    
                    let content = result!["content"] as! [String: Any]
                    self.SupplyTArr = content["supplytradings"] as? [[String : Any]] ?? [[:]]
                    self.DemandTArr = content["demandtradings"] as? [[String : Any]] ?? [[:]]
                    self.SectionsArr = content["sections"] as? [[String : Any]] ?? [[:]]
                    
                    DispatchQueue.main.async {
                        self.collectiondemand.reloadData()
                        self.collectionsupply.reloadData()
                        self.collectionsection.reloadData()
                        self.viewDidLayoutSubviews()
                        self.lblgreenzone.text = content["sections"] as? String
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
//                            // Put your code which should be executed with a delay here
//                           
//                        }
                        
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
}



 extension String {
     func toDate() -> Date? {
        // return Date()
         let formatter1 = DateFormatter()
         let formatter2 = DateFormatter()
         let formatter3 = DateFormatter()
          formatter1.dateFormat = "dd MMM yyyy HH:mm:ss" // YOUR DATE FORMATE
         formatter2.dateFormat = "EEEE dd/MMMM/yyyy" // YOUR DATE FORMATE
         formatter3.dateFormat = "d(EEE).M(MMM).yyyy" // YOUR DATE FORMATE

          if  let date1 = formatter1.date(from: self) {
                // IT CONTAIN YOUR DATE FORMATE
              return date1
          }
         else if let date2 = formatter2.date(from: self) {
             // IT CONTAIN YOUR DATE FORMATE
           return date2
       }
         else if let date3 = formatter3.date(from: self) {
                 // IT CONTAIN YOUR DATE FORMATE
               return date3
           }
                 else
                 {
                     return nil
                 }
     }

 }


extension Date {
    var day: Int? {
       let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    dateFormatter.dateFormat = "dd"
    let strdate = dateFormatter.string(from: self as Date)
    return Int(strdate)!
    }

    var nameOfDay: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    dateFormatter.dateFormat = "EEEE"
    return dateFormatter.string(from: self as Date)
    }

    var month: Int? {
       let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    dateFormatter.dateFormat = "MM"
    let getmonth = dateFormatter.string(from: self as Date)
    return Int(getmonth)!
    }

    var nameOfTheMonth: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    dateFormatter.dateFormat = "MMMM"
    return dateFormatter.string(from: self as Date)
    }

    var year: Int? {
       let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    dateFormatter.dateFormat = "yy"
    let getyear = dateFormatter.string(from: self as Date)
    return Int(getyear)!
    }

    static func numberOfDaysBetween(_ date: Date, and date2: Date) -> Int? {
        // let fromDate = startOfDay(for: date) // <1>
        // let toDate = startOfDay(for: date2) // <2>
        // let numberOfDays = dateComponents([.day], from: fromDate, to: toDate) // <3>
       return Calendar.current.dateComponents([.day], from: date, to: date2).day
        //return numberOfDays.day!
    }
}

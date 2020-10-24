//
//  ReferrallistingViewController.swift
//  CBit
//
//  Created by My Mac on 16/12/19.
//  Copyright © 2019 Bhavik Kothari. All rights reserved.
//

import UIKit
import UserNotifications

class ReferrallistingViewController: UIViewController {

    
    @IBOutlet weak var tableRefferedList: UITableView!
    @IBOutlet weak var labelContestName: UILabel!
    @IBOutlet weak var viewNoData: UIView!
    
    var dictContest = [String: Any]()
    
    var arrUsers = [[String: Any]]()
    
    //MARK: - Default Method
    override func viewDidLoad() {
        super.viewDidLoad()
        tableRefferedList.rowHeight = UITableView.automaticDimension
        tableRefferedList.tableFooterView = UIView()
      //  UNUserNotificationCenter.current().delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      //  labelContestName.text = dictContest["name"] as? String ?? "No Name"
    }
    
    //MARK: - Button Method
    @IBAction func buttonBack(_ sender: Any) {
        
      self.dismiss(animated: true)
        
    }
}

//MARK: - TableView Delegate Method
extension ReferrallistingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userCell = tableView.dequeueReusableCell(withIdentifier: "Referrallisting") as! Referrallisting
        
//        let imageURL = URL(string: arrUsers[indexPath.row]["profile_image"] as? String ?? "")
//        userCell.imageUser.sd_setImage(with: imageURL,
//                                       placeholderImage: Define.PLACEHOLDER_PROFILE_IMAGE)
        
       let firstname = arrUsers[indexPath.row]["firstName"] as? String ?? "No name"
       let middlename = arrUsers[indexPath.row]["middelName"] as? String ?? "No name"
       let lastname = arrUsers[indexPath.row]["lastName"] as? String ?? "No name"
        
//
        userCell.labelUserName.text = firstname + " " + middlename + " " + lastname
        
        let imageURL = URL(string:"")
       
        userCell.imageUser.sd_setImage(with: imageURL,placeholderImage: Define.PLACEHOLDER_PROFILE_IMAGE)
       
        return userCell
        
        
    }
}

//MARK: - Notifcation Delegate Method
//extension ReferrallistingViewController: UNUserNotificationCenterDelegate {
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

//MARK: - Cell Class
class Referrallisting: UITableViewCell {
    
    @IBOutlet weak var imageUser: ImageViewProfile!
    @IBOutlet weak var labelUserName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}

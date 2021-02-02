//
//  PrivateGroupViewController.swift
//  CBit
//
//  Created by My Mac on 06/11/20.
//  Copyright © 2020 Bhavik Kothari. All rights reserved.
//

import UIKit

class privategroupcell: UITableViewCell {
    @IBOutlet var lblgroupname: UILabel!
    @IBOutlet var btnjoincontest: UIButton!
    
    @IBOutlet var topvw: UIView!
    @IBOutlet var bottomvw: UIView!
    
    @IBOutlet var lbltitle: UILabel!
    @IBOutlet var lbllockstyle: UILabel!
    
}

class PrivateGroupViewController: UIViewController {

    @IBOutlet var lbltitle: UILabel!
    @IBOutlet var lbldate: UILabel!
    @IBOutlet var lblgametime: UILabel!
    @IBOutlet var lblremainingtime: UILabel!
    @IBOutlet var lblentryclosing: UILabel!
    
    @IBOutlet var tbllist: UITableView!
    var GroupList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        GroupList = ["Happy family","Cousion","Friends Forever","Top 20","Land On moon","Old is Gold"]
    }
    

 
    @IBAction func back_click(_ sender: UIButton) {
         self.navigationController?.popViewController(animated: true)
    }
    @IBAction func searchgroup_click(_ sender: UIButton) {
    }
    @IBAction func creategroup_click(_ sender: UIButton) {
        let CreatePrivateGroupVC = self.storyboard?.instantiateViewController(withIdentifier: "CreatePrivateGroupVC") as! CreatePrivateGroupVC
        self.navigationController?.pushViewController(CreatePrivateGroupVC, animated: true)
    }
    
}


//MARK: - TableView Delegate Method
extension PrivateGroupViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GroupList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "privategroupcell") as! privategroupcell
        
        //Set Data
       
        
        //Set Button
        cell.btnjoincontest.addTarget(self, action: #selector(buttonJoinContest(_:)), for: .touchUpInside)
        cell.btnjoincontest.tag = indexPath.row
        
        cell.lblgroupname.text = GroupList[indexPath.row]
        
        DispatchQueue.main.async {
            MyModel().roundCorners(corners: [.topRight,.topLeft,.bottomRight, .bottomLeft], radius: 10, view: cell.topvw)
            MyModel().roundCorners(corners: [.topRight,.topLeft,.bottomRight, .bottomLeft], radius: 10, view: cell.bottomvw)
            MyModel().roundCorners(corners: [.bottomLeft], radius: 10, view: cell.btnjoincontest)
            cell.bottomvw.createDottedLine(width: 3, color: UIColor.black.cgColor)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
       
//        let ticketVC = self.storyboard?.instantiateViewController(withIdentifier: "TicketVC") as! TicketVC
//        ticketVC.dictContest = arrContest[indexPath.row]
//        self.navigationController?.pushViewController(ticketVC, animated: true)
    }
    
    //MARK: - Tableview Button Mathod
    @objc func buttonJoinContest(_ sender: UIButton) {
//        isVisible = false
//        let index = sender.tag
//        let ticketVC = self.storyboard?.instantiateViewController(withIdentifier: "TicketVC") as! TicketVC
//        ticketVC.dictContest = arrContest[index]
//        ticketVC.isFromMyTickets = false
//        self.navigationController?.pushViewController(ticketVC, animated: true)
    }
}

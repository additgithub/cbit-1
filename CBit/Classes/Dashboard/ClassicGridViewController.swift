//
//  ClassicGridViewController.swift
//  CBit
//
//  Created by Emp-Mac-1 on 20/01/21.
//  Copyright © 2021 Bhavik Kothari. All rights reserved.
//

import UIKit

class GridCell: UITableViewCell {
    @IBOutlet weak var lblentryfee: UILabel!
    @IBOutlet weak var lblplayer: UILabel!
    @IBOutlet weak var lblwinnings: UILabel!
    @IBOutlet weak var lblmaxwinner: UILabel!
    @IBOutlet weak var lblplay_pending: UILabel!
    @IBOutlet weak var lbllockstyle: UILabel!
    @IBOutlet weak var btnplaynow: UIButton!
    
}

class ClassicGridViewController: UIViewController {

    @IBOutlet weak var tblgridlist: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func back_click(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func completein_click(_ sender: UIButton) {
        let HostGameVC = self.storyboard?.instantiateViewController(withIdentifier: "HostGameVC") as! HostGameVC
        self.navigationController?.pushViewController(HostGameVC, animated: true)
    }
    

}

//MARK: - TableView Delegate Method
extension ClassicGridViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GridCell") as! GridCell
        
        //Set Data
       
        
        //Set Button
        cell.btnplaynow.addTarget(self, action: #selector(buttonJoinContest(_:)), for: .touchUpInside)
        cell.btnplaynow.tag = indexPath.row
        
        DispatchQueue.main.async {
            MyModel().roundCorners(corners: [.topRight,.topLeft,.bottomRight, .bottomLeft], radius: 5, view: cell.btnplaynow)
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

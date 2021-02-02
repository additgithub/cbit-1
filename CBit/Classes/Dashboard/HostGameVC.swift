//
//  HostGameVC.swift
//  CBit
//
//  Created by Emp-Mac-1 on 25/01/21.
//  Copyright © 2021 Bhavik Kothari. All rights reserved.
//

import UIKit
import DropDown

class HostGameVC: UIViewController {

    @IBOutlet weak var txttablesize: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

 
    @IBAction func back_click(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func group_click(_ sender: UIButton) {
        let  dropDown1 = DropDown()
                
             // dropDown1.dataSource = self.TimeList.compactMap{$0["StartTime"] as? String}
        
        dropDown1.dataSource = ["Group","Happy Family(40)","Old is Gold(25)","Family Forever(33)","Create Group"]
        dropDown1.anchorView =  sender
              
                dropDown1.selectionAction = {
                  
                  [unowned self] (index: Int, item: String) in
                  print("Selected item: \(item) at index: \(index)")
                    if item == "Create Group" {
                        DispatchQueue.main.async {
                            let NextVC = self.storyboard?.instantiateViewController(withIdentifier: "CreatePrivateGroupViewController") as! CreatePrivateGroupViewController
                            self.navigationController?.pushViewController(NextVC, animated: true)
                        }
                       
                    }
                    
                        sender.setTitle(item, for: .normal)
                    
                    
              }
              dropDown1.show()
    }
    @IBAction func game_click(_ sender: UIButton) {
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
    @IBAction func level_click(_ sender: UIButton) {
        let  dropDown1 = DropDown()
                
             // dropDown1.dataSource = self.TimeList.compactMap{$0["StartTime"] as? String}
        
        dropDown1.dataSource = ["Easy","Moderate","Pro"]
        dropDown1.anchorView =  sender
              
                dropDown1.selectionAction = {
                  
                  [unowned self] (index: Int, item: String) in
                  print("Selected item: \(item) at index: \(index)")
                    sender.setTitle(item, for: .normal)
              }
              dropDown1.show()
    }
    @IBAction func noofoption_click(_ sender: UIButton) {
        let  dropDown1 = DropDown()
                
             // dropDown1.dataSource = self.TimeList.compactMap{$0["StartTime"] as? String}
        
        dropDown1.dataSource = ["Red Draw Blue","Numeric Slot"]
        dropDown1.anchorView =  sender
              
                dropDown1.selectionAction = {
                  
                  [unowned self] (index: Int, item: String) in
                  print("Selected item: \(item) at index: \(index)")
                    sender.setTitle(item, for: .normal)
              }
              dropDown1.show()
    }
    @IBAction func lockstyle_click(_ sender: UIButton) {
        let  dropDown1 = DropDown()
                
             // dropDown1.dataSource = self.TimeList.compactMap{$0["StartTime"] as? String}
        
        dropDown1.dataSource = ["Basic","Paper Chit","Catch the object"]
        dropDown1.anchorView =  sender
              
                dropDown1.selectionAction = {
                  
                  [unowned self] (index: Int, item: String) in
                  print("Selected item: \(item) at index: \(index)")
                    sender.setTitle(item, for: .normal)
              }
              dropDown1.show()
    }
    @IBAction func gamemode_click(_ sender: UIButton) {
        let  dropDown1 = DropDown()
                
             // dropDown1.dataSource = self.TimeList.compactMap{$0["StartTime"] as? String}
        
        dropDown1.dataSource = ["Single Game","Back to Back Game","Best of all","Series"]
        dropDown1.anchorView =  sender
              
                dropDown1.selectionAction = {
                  
                  [unowned self] (index: Int, item: String) in
                  print("Selected item: \(item) at index: \(index)")
                    sender.setTitle(item, for: .normal)
              }
              dropDown1.show()
    }
    @IBAction func launchgame_click(_ sender: UIButton) {
    }
    
}

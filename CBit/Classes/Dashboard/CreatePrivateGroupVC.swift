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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let chkarr = [chk1,chk2,chk3,chkeasy,chkmoderate,chkpro]
        
        for chk in chkarr {
            chk?.markType = .radio
            chk?.boxType = .circle
            chk?.tintColor = #colorLiteral(red: 0.1019607843, green: 0.3098039216, blue: 0.3647058824, alpha: 1)
            chk?.secondaryTintColor = #colorLiteral(red: 0.1019607843, green: 0.3098039216, blue: 0.3647058824, alpha: 1)
            chk?.stateChangeAnimation = .fill
        }
        
        chk1.checkState = .checked
        chkeasy.checkState = .checked
        
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
        
        dropDown1.dataSource = ["Classic Grids","Spinning Machine","Roulette Style","Sky Divers","Up-Down","Traffic Junction"]
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
    

}

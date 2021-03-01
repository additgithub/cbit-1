//
//  JoinGroupVC.swift
//  CBit
//
//  Created by Catlina-Ravi on 01/03/21.
//  Copyright © 2021 Bhavik Kothari. All rights reserved.
//

import UIKit

class JoinGroupVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func btn_BACK(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btn_SEARCH_CREATE_GROUP(_ sender: UIButton) {
        if sender.tag == 11
        {//Search Click
            print("Search Click")
            
        }
        else
        {//Create Click
            print("Create Click")
            
        }
    }
    
    

   
}

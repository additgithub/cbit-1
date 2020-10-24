//
//  LockAll.swift
//  CBit
//
//  Created by Mac on 07/04/20.
//  Copyright © 2020 Bhavik Kothari. All rights reserved.
//

import Foundation
import UIKit
import SwiftGifOrigin

class LockAll: UIView
    
{
@IBOutlet weak var imageAnimation1: UIImageView!
  
  override func awakeFromNib() {
      super.awakeFromNib()
      imageAnimation1.loadGif(name:"lock")
  }
  
  class func instanceFromNib() -> UIView {
      return UINib(nibName: "LockAll",
                   bundle: nil).instantiate(withOwner: self,
                                            options: nil).first as! LockAll
  }
}

//
//  T&CJTicketViewController.swift
//  CBit
//
//  Created by Mac on 13/03/20.
//  Copyright © 2020 Bhavik Kothari. All rights reserved.
//

import UIKit
import WebKit

class T_CJTicketViewController: UIViewController {

    @IBOutlet weak var webViewTermsAndCondition: WKWebView!
    @IBOutlet weak var progressTermsAndCondition: UIProgressView!
    
    override func viewDidLoad() {
       super.viewDidLoad()
        
                webViewTermsAndCondition.uiDelegate = self
        webViewTermsAndCondition.load(URLRequest(url: URL(string: Define.JticketInfo_URl)!))
                
            }
            
            //MARK: - Button Method
            @IBAction func buttonMenu(_ sender: Any) {
                self.dismiss(animated: true, completion: nil)
            }
    @IBAction func btn_back(_ sender: Any) {
        
        self.dismiss(animated: true)
    }
}

        //MARK: - WebView Delegate Method
extension T_CJTicketViewController: WKUIDelegate  {
          
  func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
    
     progressTermsAndCondition.setProgress(0.1, animated: false)
    
  }
  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    
      progressTermsAndCondition.setProgress(1.0, animated: true)
  }
            
            
}

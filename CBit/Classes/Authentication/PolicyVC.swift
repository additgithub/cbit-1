import UIKit
import WebKit

class PolicyVC: UIViewController {

    @IBOutlet weak var webViewTermsAndCondition: WKWebView!
    @IBOutlet weak var progressTermsAndCondition: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
     //   webViewTermsAndCondition.navigationDelegate = self
        webViewTermsAndCondition.load(URLRequest(url: URL(string: Define.LIGALITY_URL)!))
    }
    
    //MARK: - Button Method
    @IBAction func buttonBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}

//MARK: - WebView Delegate Method
extension PolicyVC: WKNavigationDelegate {
      func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
         progressTermsAndCondition.setProgress(0.1, animated: false)
      }
      func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
          progressTermsAndCondition.setProgress(1.0, animated: true)
      }
}

import UIKit

struct Loading {
    func showLoading(viewController: UIViewController)
    {
        let view = UIView()
        let activityController = UIActivityIndicatorView(style: .whiteLarge)
        
        view.frame = viewController.view.bounds
        view.backgroundColor = UIColor.black
        view.tag = 9999
        view.alpha = 0.5
        
        activityController.startAnimating()
        
        view.addSubview(activityController)
        activityController.center = view.center
        
        for view in viewController.view.subviews {
            if view.tag == 9999 {
               return
            }
        }
        
        viewController.view.addSubview(view)
    }
    
    func hideLoading(viewController: UIViewController) {
        for view in viewController.view.subviews {
            if view.tag == 9999 {
                view.removeFromSuperview()
            }
        }
    }
}

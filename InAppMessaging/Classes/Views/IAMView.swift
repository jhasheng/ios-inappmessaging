import UIKit

/**
 * Protocol to define the IAM view.
 */
protocol IAMView {
    func show()
    func dismiss()
    var backgroundView: UIView? { get }
    var dialogView: UIView { get set }
}

extension IAMView where Self: UIView {
    var backgroundView: UIView? { return nil } // Not all views will be using a background view.

    /**
     * Function that finds the presented view controller and add the modal sub view on top.
     */
    internal func show() {
        let viewIdentifier = "IAMView"
        self.accessibilityIdentifier = viewIdentifier
        
        // Check to see if any other IAMViews are presented.
        if let subviews = UIApplication.shared.keyWindow?.subviews {
            for subview in subviews {
                if subview.accessibilityIdentifier == viewIdentifier {
                    return
                }
            }
        }
        
        if let window =  UIApplication.shared.keyWindow {
            window.addSubview(self)
        }
    }
    
    /**
     * Function that dismisses the presented IAM view.
     */
    internal func dismiss() {
        self.removeFromSuperview()
        WorkScheduler.scheduleTask(5000, closure: InAppMessagingViewController.display)
    }
}

extension IAMView where Self: SlideUpView {    
    func show() {
        if let window =  UIApplication.shared.keyWindow {
            window.addSubview(self)
        }
        
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut,
                       animations: {
                        self.center.y -= self.slideUpHeight / 2
                        self.layoutIfNeeded()
        }, completion: nil)
////        self.isHidden = false
    }
//    func animHide(){
//        UIView.animate(withDuration: 2, delay: 0, options: [.curveLinear],
//                       animations: {
//                        self.center.y += self.bounds.height
//                        self.layoutIfNeeded()
//
//        },  completion: {(_ completed: Bool) -> Void in
//            self.isHidden = true
//        })
//    }
    
    func dismiss() {
        
    }
}

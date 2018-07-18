import UIKit

/**
 * Protocol to define the modal view.
 */
protocol Modal {
    func show()
    func dismiss()
    var backgroundView:UIView { get }
    var dialogView:UIView { get set }
}

extension Modal where Self:UIView {
    
    /**
     * Function that finds the presented view controller and add the modal sub view on top.
     */
    internal func show() {
        self.backgroundView.alpha = 0.66
        self.dialogView.center  = self.center
        
        if var topController = UIApplication.shared.delegate?.window??.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            
            topController.view.addSubview(self)
        }
    }
    
    /**
     * Function that dismisses the presented modal view.
     */
    internal func dismiss() {
        self.removeFromSuperview()
    }
}
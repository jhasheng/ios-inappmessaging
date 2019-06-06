import UIKit

/**
 * Protocol to define the modal view.
 */
protocol Modal {
    func show()
    func dismiss()
    var backgroundView: UIView { get }
    var dialogView: UIView { get set }
}

extension Modal where Self: UIView {
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
     * Function that dismisses the presented modal view.
     */
    internal func dismiss() {
        self.removeFromSuperview()
        WorkScheduler.scheduleTask(5000, closure: InAppMessagingViewController.display)
    }
}

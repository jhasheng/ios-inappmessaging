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
        if let window =  UIApplication.shared.keyWindow {
            InAppMessagingViewController.isRunning = true
            window.addSubview(self)
        }
    }
    
    /**
     * Function that dismisses the presented IAM view.
     */
    internal func dismiss() {
        self.removeFromSuperview()
        InAppMessagingViewController.isRunning = false

        WorkScheduler.scheduleTask(5000, closure: InAppMessagingViewController.display)
    }
}

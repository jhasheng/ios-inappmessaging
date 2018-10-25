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
        //TODO(Daniel Tam) Clarify on the time between showing campaigns.
//        WorkScheduler.scheduleTask(5000, closure: InAppMessagingViewController.displayIndividualCampaign)
    }
}

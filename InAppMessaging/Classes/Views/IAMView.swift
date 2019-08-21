import UIKit

/**
 * Protocol to define the IAM view.
 */
protocol IAMView {
    func show()
    func dismiss()
    var backgroundView: UIView? { get }
    var optOutCheckbox: Checkbox? { get }
    var dialogView: UIView { get set }
    var viewIdentifier: String { get }
}

extension IAMView where Self: UIView {
    var backgroundView: UIView? { return nil } // Not all views will be using a background view.
    var optOutCheckbox: Checkbox? { return nil } // Not all views will require an opt-out checkbox.
    var viewIdentifier: String { return "IAMView" }

    /**
     * Function that handles the login for displaying Modal/Fullscreen IAM views.
     */
    func show() {
        displayView()
    }
    
    /**
     * Function that finds the presented view controller and add the IAMView on top.
     */
    func displayView() {
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
    func dismiss() {
        self.removeFromSuperview()
        WorkScheduler.scheduleTask(5000, closure: InAppMessagingViewController.display)
    }
}

extension IAMView where Self: SlideUpView {
    /**
     * Handles logic for displaying a SlideUpView.
     */
    func show() {
        displayView()
        animateSlideUp()
    }
    
    /**
     * Handles the animation of the SlideUpView.
     */
    func animateSlideUp() {
        guard let direction = self.slideFromDirection else {
            return
        }
        
        //TODO: Support TOP direction for slide-up
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut, animations: {
            switch direction {
                case .BOTTOM:
                    self.center.y -= self.slideUpHeight
                case .LEFT:
                    self.center.x = self.screenWidth / 2
                case .RIGHT:
                    self.center.x = self.screenWidth / 2
                case .TOP:
                    break
            }
            
            self.layoutIfNeeded()
        })
    }
}

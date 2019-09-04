/**
 * Protocol for properties required for SlideUpView.
 */
protocol IAMSlideUpView: IAMView {}

extension IAMSlideUpView where Self: SlideUpView {
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
        
        //TODO: (Daniel Tam) - Support TOP direction for slide-up
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut, animations: {
            switch direction {
            case .BOTTOM:
                self.center.y -= self.slideUpHeight
            case .LEFT, .RIGHT:
                self.center.x = self.screenWidth / 2
            case .TOP:
                break
            }
            
            self.layoutIfNeeded()
        })
    }
}

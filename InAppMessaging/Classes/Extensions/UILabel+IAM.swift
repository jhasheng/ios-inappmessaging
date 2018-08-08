/**
 * Extension to UILabel class to provide computed properties required by InAppMessaging.
 */
extension UILabel
{
    /**
     * Optimal height of label to use based on the current font size and number of line breaks.
     */
    var optimalHeight : CGFloat { get
    {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: .greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = self.lineBreakMode
        label.font = self.font
        label.text = self.text
        label.sizeToFit()
        
        return label.frame.height
        }
    }
}

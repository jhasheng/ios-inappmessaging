/**
 * Extension to UILabel class to provide computed properties required by InAppMessaging.
 */
extension UILabel
{
    /**
     * Optimal height of label to use based on the current font size and number of line breaks.
     */
    var optimalHeight : CGFloat { get {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: .greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = self.lineBreakMode
        label.font = self.font
        label.text = self.text
        label.setLineSpacing(lineSpacing: 3.0)
        label.sizeToFit()
        
        return label.frame.height
    }}
    
    /**
     * Set the line spacing when a label display is using two or more lines.
     * @param { lineSpacing: CGFloat } the value of the spacing for each line. Defaults to 0.
     */
    func setLineSpacing(lineSpacing: CGFloat = 0.0) {
        
        guard let labelText = self.text else {
            return
        }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        
        let attributedString:NSMutableAttributedString
        if let labelattributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelattributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }
        
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        
        self.attributedText = attributedString
    }
}

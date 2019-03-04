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
        label.sizeToFit()
        
        return label.frame.height
    }}
    
    func setLineSpacing(lineSpacing: CGFloat = 0.0, lineHeightMultiple: CGFloat = 0.0) {
        
        guard let labelText = self.text else { return }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        
        let attributedString:NSMutableAttributedString
        if let labelattributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelattributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }
        
        // (Swift 4.1 and 4.0) Line spacing attribute
        attributedString.addAttribute(NSAttributedStringKey.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        
        self.attributedText = attributedString
    }
}

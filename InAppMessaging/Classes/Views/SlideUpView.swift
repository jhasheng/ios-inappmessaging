import UIKit

/**
 * SlideUpView for InAppMessaging campaign.
 */
class SlideUpView: UIView, IAMView {
    var dialogView = UIView()
    var slideFromDirection: SlideFromEnum?
    
    private var bottomSafeAreaInsets: CGFloat {
        get {
            if #available(iOS 11.0, *) {
                let bottomSafeArea = UIApplication.shared.keyWindow!.safeAreaInsets.bottom
                
                // Lessen the gap from iPhone X and newer phones so that there will be less white space.
                return bottomSafeArea == 0 ? 0 : bottomSafeArea - 20
            }
            
            return 0
        }
    }
    
    let screenWidth: CGFloat = UIScreen.main.bounds.width // Width of the device.
    let slideUpHeight: CGFloat = 89 // Height of the banner window.
    private let slideUpLeftPaddingPercentage: CGFloat = 0.07 // Percentage of the left padding to total width.
    private let slideUpRightPaddingPercentage: CGFloat = 0.17 // Percentage of the right padding to total width.
    private let bodyMessageLabelFontSize: CGFloat = 14 // Font size of the message.
    private let bodyMessageLabelHeight: CGFloat = 61 // Height of the UILabel for the body message.
    private let slideUpContentTopPadding: CGFloat = 12 // Top padding for the content inside the slide up view.
    private let exitButtonSize: CGFloat = 20 // Size of the button.
    private let exitButtonRightPadding: CGFloat = 36 // Amount of padding right of the exit button
    
    convenience init(withCampaign campaign: CampaignData) {
        self.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        guard let direction = campaign.messagePayload.messageSettings.displaySettings.slideFrom else {
            #if DEBUG
                print("InAppMessaging: Error constructing a SlideUpView.")
            #endif
            return
        }
        
        self.slideFromDirection = direction
        
        //TODO: Support other sliding positions other than bottom.
        frame.origin = startingFramePosition(fromSliding: direction)
        frame.size = CGSize(width: screenWidth, height: slideUpHeight + bottomSafeAreaInsets)
        
        initializeView(withCampaign: campaign)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initializeView(withCampaign campaign: CampaignData) {
        dialogView.backgroundColor = UIColor(hexFromString: campaign.messagePayload.messageBodyColor)
        dialogView.frame = CGRect(x: 0,
                                  y: 0,
                                  width: screenWidth,
                                  height: slideUpHeight + bottomSafeAreaInsets
        )
        
        if let bodyMessage = campaign.messagePayload.messageBody {
            appendMessage(with: bodyMessage)
        }
        
        appendExitButton()
        appendSubview()
    }
    
    private func appendMessage(with message: String) {
        let leftPadding = screenWidth * slideUpLeftPaddingPercentage
        let rightPadding = screenWidth * slideUpRightPaddingPercentage
        
        let bodyMessageLabel = UILabel(
            frame: CGRect(x: leftPadding,
                          y: slideUpContentTopPadding,
                          width: screenWidth - (leftPadding + rightPadding),
                          height: bodyMessageLabelHeight
            )
        )
        
        bodyMessageLabel.text = message
        bodyMessageLabel.font = .systemFont(ofSize: bodyMessageLabelFontSize)
        bodyMessageLabel.setLineSpacing(lineSpacing: 3.0)
        bodyMessageLabel.textAlignment = .left
        bodyMessageLabel.numberOfLines = 3
        bodyMessageLabel.lineBreakMode = .byTruncatingTail
        
        dialogView.addSubview(bodyMessageLabel)
    }
    
    private func appendExitButton() {
        let exitButton = UILabel(
            frame: CGRect(x: screenWidth - exitButtonRightPadding,
                          y: slideUpContentTopPadding,
                          width: exitButtonSize,
                          height: exitButtonSize
            )
        )
        
        exitButton.text = "X"
        exitButton.font = .systemFont(ofSize: 14)
        exitButton.backgroundColor = UIColor(red: 0.41, green: 0.41, blue: 0.41, alpha: 1)
        exitButton.textColor = .white
        exitButton.textAlignment = .center
        exitButton.isUserInteractionEnabled = true
        exitButton.layer.cornerRadius = exitButton.frame.width / 2
        exitButton.layer.masksToBounds = true
        exitButton.tag = ImpressionType.EXIT.rawValue
        exitButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapOnExitButton)))
        
        dialogView.addSubview(exitButton)
    }
    
    private func appendSubview() {
        addSubview(dialogView)
    }
    
    /**
     * Find the frame origin depending on the slide direction.
     * @param { direction: SlideFromEnum } direction to slide from.
     * @return { CGPoint } origin of the campaign frame.
     */
    private func startingFramePosition(fromSliding direction: SlideFromEnum) -> CGPoint {
        let yPosition = UIScreen.main.bounds.height
        
        switch direction {
            case .BOTTOM:
                return CGPoint(x: 0, y: yPosition - bottomSafeAreaInsets)
            case .LEFT:
                return CGPoint(x: -screenWidth, y: yPosition - slideUpHeight)
            case .RIGHT:
                return CGPoint(x: screenWidth * 2, y: yPosition - slideUpHeight)
            
        //TODO: Support TOP direction for sliding.
            case .TOP:
                return CGPoint(x: 0, y: 0)
        }
    }
    
    /**
     * Obj-c selector to dismiss the modal view when the 'X' is tapped.
     */
    @objc private func didTapOnExitButton(_ sender: UIGestureRecognizer){
        dismiss()
    }
}

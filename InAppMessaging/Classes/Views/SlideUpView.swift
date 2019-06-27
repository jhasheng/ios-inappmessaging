import UIKit

class SlideUpView: UIView, IAMView {
    
    var dialogView = UIView()
    
    private let screenWidth = UIScreen.main.bounds.width
    
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
    
    let slideUpHeight: CGFloat = 89 // Height of the banner window.
    private let slideUpLeftPaddingPercentage: CGFloat = 0.07 // Percentage of the left padding to total width.
    private let slideUpRightPaddingPercentage: CGFloat = 0.17 // Percentage of the right padding to total width.
    private let bodyMessageLabelFontSize: CGFloat = 14 // Font size of the message.
    private let bodyMessageLabelHeight: CGFloat = 61 // Height of the UILabel for the body message.
    private let bodyMessageLabelTopPadding: CGFloat = 12 // Top padding of the UILabel for the body message.
    
    convenience init(withCampaign campaign: CampaignData) {
        self.init(frame: UIScreen.main.bounds)
        initializeView(withCampaign: campaign)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initializeView(withCampaign campaign: CampaignData) {
        dialogView.backgroundColor = .purple
        dialogView.frame = startingFrame(fromSliding: .BOTTOM)
        
        if let bodyMessage = campaign.messagePayload.messageBody {
            appendMessage(with: bodyMessage)
        }
        
        appendSubview()
    }
    
    private func appendMessage(with message: String) {
        let leftPadding = screenWidth * slideUpLeftPaddingPercentage
        let rightPadding = screenWidth * slideUpRightPaddingPercentage
        
        let bodyMessageLabel = UILabel(frame: CGRect(x: leftPadding,
                                                     y: bodyMessageLabelTopPadding,
                                                     width: screenWidth - (leftPadding + rightPadding),
                                                     height: bodyMessageLabelHeight))
        
        bodyMessageLabel.text = message
        bodyMessageLabel.font = .systemFont(ofSize: bodyMessageLabelFontSize)
        bodyMessageLabel.setLineSpacing(lineSpacing: 3.0)
        bodyMessageLabel.textAlignment = .left
        bodyMessageLabel.numberOfLines = 3
        bodyMessageLabel.lineBreakMode = .byTruncatingTail
        
        dialogView.addSubview(bodyMessageLabel)
        
    }
    
    private func appendSubview() {
        self.addSubview(dialogView)
        self.show()
    }
    
    private func startingFrame(fromSliding direction: SlideFromEnum) -> CGRect {
        switch direction {
            case .BOTTOM:
                print(bottomSafeAreaInsets)
                return CGRect(x: 0,
                              y: UIScreen.main.bounds.height - bottomSafeAreaInsets,
                              width: screenWidth,
                              height: slideUpHeight + bottomSafeAreaInsets)

        //TODO: Support other slide from directions.
            case .TOP, .LEFT, .RIGHT:
                return CGRect(x: 0, y: 0, width: 0, height: 0)
        }
    }
}

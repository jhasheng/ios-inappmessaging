import UIKit

/**
 * Class that initializes the modal view using the passed in campaign information to build the UI.
 */
class ModalView: UIView, Modal {
    var backgroundView = UIView()
    var dialogView = UIView()
    
    convenience init(campaign: CampaignData) {
        self.init(frame: UIScreen.main.bounds)
        initialize(campaign: campaign)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     * Creates the modal view to be displayed using the campaign information.
     * @param { campaign: CampaignData } the campaign to be displayed.
     */
    internal func initialize(campaign: CampaignData){
        
        // Background view.
        backgroundView.frame = frame
        backgroundView.backgroundColor = .black
        self.addSubview(backgroundView)
        
        let dialogViewWidth = frame.width - 64
        
        // Header title.
        let messageHeader = UILabel(frame: CGRect(x: 8, y: 8, width: dialogViewWidth - 16, height: 60))
        messageHeader.text = campaign.messagePayload.header
        messageHeader.textAlignment = .center
        dialogView.addSubview(messageHeader)
        
        // Separator between header title and message body
        let separatorLineView = UIView()
        separatorLineView.frame.origin = CGPoint(x: 8, y: messageHeader.frame.height + 8)
        separatorLineView.frame.size = CGSize(width: dialogViewWidth, height: 1)
        separatorLineView.backgroundColor = .groupTableViewBackground
        dialogView.addSubview(separatorLineView)
        
        let heightAfterSeparator = messageHeader.frame.height + 8 + separatorLineView.frame.height + 8

        // Message body.
        let messageBody = UILabel(frame: CGRect(x: 8, y: heightAfterSeparator, width: dialogViewWidth-16, height: 60))
        messageBody.text = campaign.messagePayload.messageBody
        messageBody.textAlignment = .center
        dialogView.addSubview(messageBody)
        
        // The top right "X" button to dismiss.
        let exitButton = UILabel(frame: CGRect(x: dialogViewWidth - 25, y: 4, width: 20, height: 20))
        exitButton.text = "X"
        exitButton.backgroundColor = .red
        exitButton.textColor = .white
        exitButton.textAlignment = .center
        exitButton.isUserInteractionEnabled = true
        exitButton.layer.cornerRadius = exitButton.frame.width / 2
        exitButton.layer.masksToBounds = true
        exitButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTappedOnExitButton)))
        dialogView.addSubview(exitButton)
        
        // The dialog view which is the rounded rectangle in the center.
        let dialogViewHeight = messageHeader.frame.height + 8 + messageBody.frame.height + 8 + separatorLineView.frame.height + 8
        dialogView.frame.origin = CGPoint(x: 32, y: frame.height)
        dialogView.frame.size = CGSize(width: frame.width - 64, height: dialogViewHeight)
        dialogView.backgroundColor = .white
        dialogView.layer.cornerRadius = 6
        dialogView.clipsToBounds = true
        self.addSubview(dialogView)
    }
    
    /**
     * Obj-c selector to dismiss the modal view when the 'X' is tapped.
     */
    @objc internal func didTappedOnExitButton(){
        dismiss()
    }
}

import UIKit
import SDWebImage

/**
 * Class that initializes the modal view using the passed in campaign information to build the UI.
 */
class ModalView: UIView, Modal {
    var backgroundView = UIView()
    var dialogView = UIView()
    
    convenience init(campaign: CampaignData) {
        self.init(frame: UIScreen.main.bounds)
        
        self.initialize(campaign: campaign)

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
    internal func initialize(campaign: CampaignData) {
        
        
        let semaphore = DispatchSemaphore(value: 0)
        
        // Background view.
        backgroundView.frame = frame
        backgroundView.backgroundColor = .black
        self.addSubview(backgroundView)
        
        let dialogViewWidth = frame.width - 64 // Minus 64 to leave spacing on the left and right side.
        
        var currentHeight: CGFloat = 0
        
        if let imageUrl = campaign.messagePayload.resource.imageUrl {
            let imageView = UIImageView(frame: CGRect(x: 0, y: 8, width: dialogViewWidth, height: 300))
            imageView.contentMode = .scaleAspectFit
            
            imageView.sd_setImage(with: URL(string: "https://i.imgur.com/OS8YlDG.jpg"), placeholderImage: nil) { (image, error, SDImageCacheType, url) in
                semaphore.signal()
            }

            dialogView.addSubview(imageView)
            
            currentHeight += imageView.frame.height + 8
        }

        // Header title.
        if let headerMessage = campaign.messagePayload.header {
            let messageHeaderLabel = UILabel(frame: CGRect(x: 8, y: currentHeight, width: dialogViewWidth - 16, height: 60))
            messageHeaderLabel.text = headerMessage
            messageHeaderLabel.textAlignment = .center
            messageHeaderLabel.font = UIFont.boldSystemFont(ofSize: 16)
            messageHeaderLabel.font = messageHeaderLabel.font.withSize(20)
            dialogView.addSubview(messageHeaderLabel)
            
            currentHeight += messageHeaderLabel.frame.height + 8
        }
        
        if let bodyMessage = campaign.messagePayload.messageBody {
            let messageBody = UILabel(frame: CGRect(x: 8, y: currentHeight, width: dialogViewWidth - 16, height: 60))
            messageBody.text = bodyMessage
            messageBody.textAlignment = .center
            dialogView.addSubview(messageBody)
            
            currentHeight += messageBody.frame.height + 8
        }
        
//        messageHeader.text = campaign.messagePayload.header
//        messageHeader.textAlignment = .center
//        dialogView.addSubview(messageHeader)
        
        // Separator between header title and message body
//        let separatorLineView = UIView()
//        separatorLineView.frame.origin = CGPoint(x: 8, y: currentHeight + 8)
//        separatorLineView.frame.size = CGSize(width: dialogViewWidth, height: 1)
//        separatorLineView.backgroundColor = .groupTableViewBackground
//        dialogView.addSubview(separatorLineView)
        
//        let heightAfterSeparator = messageHeader.frame.height + 8 + separatorLineView.frame.height + 8
//
//        // Message body.
//        let messageBody = UILabel(frame: CGRect(x: 8, y: heightAfterSeparator, width: dialogViewWidth - 16, height: 60))
//        messageBody.text = campaign.messagePayload.messageBody
//        messageBody.textAlignment = .center
//        dialogView.addSubview(messageBody)
//
//        // The top right "X" button to dismiss.
        let exitButton = UILabel(frame: CGRect(x: dialogViewWidth - 25, y: 4, width: 20, height: 20))
        exitButton.text = "X"
        exitButton.backgroundColor = .gray
        exitButton.textColor = .white
        exitButton.textAlignment = .center
        exitButton.isUserInteractionEnabled = true
        exitButton.layer.cornerRadius = exitButton.frame.width / 2
        exitButton.layer.masksToBounds = true
        exitButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTappedOnExitButton)))
        dialogView.addSubview(exitButton)
        
        // The dialog view which is the rounded rectangle in the center.
//        let dialogViewHeight = messageHeader.frame.height + 8 + messageBody.frame.height + 8 + separatorLineView.frame.height + 8
        dialogView.frame.origin = CGPoint(x: 32, y: frame.height)
        dialogView.frame.size = CGSize(width: dialogViewWidth, height: currentHeight)
        dialogView.backgroundColor = .white
        dialogView.layer.cornerRadius = 6
        dialogView.clipsToBounds = true
//        semaphore.wait()
        

        
        self.addSubview(dialogView)
    }
    
    /**
     * Obj-c selector to dismiss the modal view when the 'X' is tapped.
     */
    @objc internal func didTappedOnExitButton(){
        dismiss()
    }
}

import SDWebImage

/**
 * Handle all the displaying logic of the SDK.
 */
class InAppMessagingViewController: UIViewController {
    
    // Flag to make sure only one instance of the display logic is running.
    // This is to prevent multiple campaign showing when events are logged
    // at a rapid session.
    static var isRunning = false

    /**
     * Checks if there are any campaigns in the ReadyCampaignRepository and display them.
     */
    internal class func display() {
        if !isRunning {
            isRunning = true

            // Display first campaign if the ready campaign list is not empty.
            if let firstCampaign = ReadyCampaignRepository.getFirst() {
                ReadyCampaignRepository.removeFirst()
                displayIndividualCampaign(firstCampaign)
            }
            
            isRunning = false
        }
    }
    
    /**
     * Contains logic to display the correct view type -- modal, slideup, fullscreen, html -- and create
     * a view controller to present a single campaign.
     * @param { campaign: Campaign } the campaign object to display.
     */
    internal class func displayIndividualCampaign(_ campaign: Campaign) {
        
        // Display first campaign.
        guard let campaignViewType = CampaignParser.findViewType(campaign: campaign.campaignData) else {
            return
        }
        
        // Skip permission checking if campaign is a test.
        // Permission check here.
        if (!campaign.campaignData.isTest) &&
            (!PermissionClient().checkPermission(withCampaign: campaign.campaignData)) {
            
                return
        }
        
        // Download the image beforehand on the background thread before passing it to the main thread to build UI.
        let semaphore = DispatchSemaphore(value: 0)
        var image: UIImage?
        if let imageUrl = campaign.campaignData.messagePayload.resource.imageUrl {
            SDWebImageDownloader.shared.downloadImage(with: URL(string: imageUrl), options: [], progress: nil) { (downloadedImage, data, error, bool) in
                image = downloadedImage
                semaphore.signal()
            }
            semaphore.wait()
        }
        
        DispatchQueue.main.async {
            var view: NewIAMView?
            
            // TODO(daniel.tam) Add the other view types.
            switch campaignViewType {
            case .modal:
//                view = ModalView(withCampaign: campaign.campaignData, andImage: image)
                break
            case .invalid:
                break
            case .full:
                view = FullScreenView(withCampaign: campaign.campaignData, andImage: image)
                break
            case .slide:
                break
            case .html:
                break
            }
            
            // Display the campaign if the view exists.
            if let viewToDisplay = view {
                DisplayedCampaignRepository.addCampaign(campaign)
                viewToDisplay.show()
            }
        }
    }
}

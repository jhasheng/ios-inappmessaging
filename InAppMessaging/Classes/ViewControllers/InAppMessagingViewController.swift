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
        
        DispatchQueue.main.async {
            var view: Modal?
            
            // TODO(daniel.tam) Add the other view types.
            switch campaignViewType {
            case .modal:
                view = ModalView(campaign.campaignData)
                break
            case .invalid:
                break
            case .full:
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

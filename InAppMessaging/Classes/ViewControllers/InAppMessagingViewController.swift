/**
 * Handle all the displaying logic of the SDK.
 */
class InAppMessagingViewController: UIViewController {

    /**
     * Checks if there are any campaigns in the ReadyCampaignRepository and display them.
     */
    internal class func display() {

        // Display first campaign if the ready campaign list is not empty.
        if let firstCampaign = ReadyCampaignRepository.getFirst() {
            ReadyCampaignRepository.removeFirst()
            displayIndividualCampaign(firstCampaign)
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
        if !campaign.campaignData.isTest {
            //Permission check here.
            if !PermissionClient().checkPermission(withCampaign: campaign.campaignData){
                return
            }
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

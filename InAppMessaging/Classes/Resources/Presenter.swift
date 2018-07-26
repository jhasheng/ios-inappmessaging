/**
 * Handle all the displaying logic of the SDK.
 */
public class Presenter: UIViewController {
    
    /**
     * Contains logic to display the correct view type -- modal, slideup, fullscreen, html -- and create
     * a view controller to present.
     * @param { name: String } name of the view type.
     */
    internal func display(_ name: String) {
        let campaignHelper = CampaignHelper()
        
        // Fetch matching campaign and get its view type.
        guard let campaignToDisplay = campaignHelper.fetchCampaign(withEventName: name),
            let campaignViewType = campaignHelper.findViewType(campaign: campaignToDisplay) else {
            
                return
        }
        
        var view: Modal?

        // TODO(daniel.tam) Add the other view types.
        switch campaignViewType {
            case "MODAL":
                view = ModalView(campaign: campaignToDisplay)
                break;
            case "slideup":
                break;
            case "fullscreen":
                break;
            case "html":
                break;
            default:
                break;
        }
        
        // Display the campaign if the view exists and add the campaign ID to the shown ID list.
        if let viewToDisplay = view {
            viewToDisplay.show()
            campaignHelper.appendShownCampaign(campaignId: campaignToDisplay.campaignId)
        }
    }
}

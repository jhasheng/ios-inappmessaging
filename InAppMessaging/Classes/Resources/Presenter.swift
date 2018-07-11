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
        let campaignParser = CampaignParser()
        
        guard let listOfCampaign = MessageMixerClient.campaign,
            let campaignToDisplay = campaignParser.findMatchingTrigger(trigger: name, campaignListOptional: listOfCampaign),
            let campaignViewType = campaignParser.findViewType(campaign: campaignToDisplay) else {
                return
        }
        
        var campaignViewController: UIViewController?

        // TODO(daniel.tam) Add the other view types.
        switch campaignViewType {
            case "modal":
                campaignViewController = ModalViewController(nibName: nil, bundle: nil, campaign: campaignToDisplay)
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
        
        if let controllerToPresent = campaignViewController {
            let rootViewController = UIApplication.shared.keyWindow!.rootViewController
            rootViewController!.presentViewControllerFromVisibleViewController(controllerToPresent, animated: false, completion: {})
        }
    }
}

/**
 * Extension to include a method to walk down the ViewController for the present view controller.
 */
extension UIViewController {
    func presentViewControllerFromVisibleViewController(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?) {
        if let navigationController = self as? UINavigationController {
            navigationController.topViewController?.presentViewControllerFromVisibleViewController(viewControllerToPresent, animated: flag, completion: completion)
        } else if let tabBarController = self as? UITabBarController {
            tabBarController.selectedViewController?.presentViewControllerFromVisibleViewController(viewControllerToPresent, animated: flag, completion: completion)
        } else if let presentedViewController = presentedViewController {
            presentedViewController.presentViewControllerFromVisibleViewController(viewControllerToPresent, animated: flag, completion: completion)
        } else {
            present(viewControllerToPresent, animated: flag, completion: completion)
        }
    }
}

//
//  Presenter.swift
//  InAppMessaging
//
//  Created by Tam, Daniel a on 6/28/18.
//

import Foundation

public class Presenter: UIViewController {
    
    public func displayModalView(_ name: String) {
        let modalViewController = ModalViewController(nibName: nil, bundle: nil, triggerName: name)
        let viewController = UIApplication.shared.keyWindow!.rootViewController
        viewController!.presentViewControllerFromVisibleViewController(modalViewController, animated: false, completion: {})
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

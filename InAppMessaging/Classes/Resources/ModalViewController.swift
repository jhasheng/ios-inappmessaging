//
//  ModalViewController.swift
//  InAppMessaging
//
//  Created by Tam, Daniel a on 6/28/18.
//

import UIKit

public class ModalViewController: UIViewController {
    
    override init(nibName: String?, bundle: Bundle?) {
        super.init(nibName: nibName, bundle: bundle)
        self.modalPresentationStyle = .popover
//        self.transitioningDelegate = self.transitioner
        let bundle = Bundle(for: self.classForCoder)
//        bundle.loadNibNamed("ModalViewController", owner: nil, options: nil)?.first
        let nib = UINib(nibName: "ModalViewController", bundle: bundle)
        nib.instantiate(withOwner: self, options: nil)

    }
    
    convenience init() {
        self.init(nibName:nil, bundle:nil)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    @IBAction func dismissButton(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true)
    }
}

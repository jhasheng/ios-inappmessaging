//
//  ModalViewController2.swift
//  InAppMessaging
//
//  Created by Tam, Daniel a on 6/28/18.
//

import UIKit

public class ModalViewController2: UIViewController {
    
    let transitioner = Transitioner()
    
    override init(nibName: String?, bundle: Bundle?) {
        super.init(nibName: nibName, bundle: bundle)
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = self.transitioner
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

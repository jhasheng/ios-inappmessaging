//
//  Presenter.swift
//  InAppMessaging
//
//  Created by Tam, Daniel a on 6/28/18.
//

import Foundation

public class Presenter: UIViewController {
    
    public func displayModalView(_ view: UIViewController) {
        let modalViewController = ModalViewController()
        view.present(modalViewController, animated: false)
    }
}

//
//  Locale+IAM.swift
//  InAppMessaging
//
//  Created by Tam, Daniel a on 7/31/18.
//

import Foundation

extension Locale {
    
    static var formattedCode: String? {
        guard let code = "\(Locale.current)".components(separatedBy: " ").first else {
            return "n/a"
        }
        return code
    }
}

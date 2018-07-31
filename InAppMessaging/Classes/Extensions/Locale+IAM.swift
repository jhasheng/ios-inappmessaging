//
//  Locale+IAM.swift
//  InAppMessaging
//
//  Created by Tam, Daniel a on 7/31/18.
//

import Foundation

extension Locale {
    
    static var formattedCode: String? {
        return "\(Locale.current)".components(separatedBy: " ").first
    }
}

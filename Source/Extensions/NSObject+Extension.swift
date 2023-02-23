//
//  NSObject+Extension.swift
//  WalletSDK
//
//  Created by ashahrouj on 15/12/2022.
//

import Foundation

extension NSObject {
    class var className: String {
        return String.init(describing: self)
    }
}

extension String {
    var containsNonEnglishNumbers: Bool {
        return !isEmpty && range(of: "[^0-9].[^0-9]", options: .regularExpression) == nil
    }
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}

//
//  UIFont+Extension.swift
//  WalletSDK
//
//  Created by ashahrouj on 09/12/2022.
//

import Foundation
import UIKit

extension UIFont {
    
    public enum CutomFont: String {
        case regular = "TitilliumWeb-Regular"
        case italic = "TitilliumWeb-Italic"
        case extraLight = "TitilliumWeb-ExtraLight"
        case extraLightItalic = "TitilliumWeb-ExtraLightItalic"
        case light = "TitilliumWeb-Light"
        case lightItalic = "TitilliumWeb-LightItalic"
        case semiBold = "TitilliumWeb-SemiBold"
        case semiBoldItalic = "TitilliumWeb-SemiBoldItalic"
        case bold = "TitilliumWeb-Bold"
        case boldItalic = "TitilliumWeb-BoldItalic"
        case black = "TitilliumWeb-Black"
    }
    
    class func font(name: CutomFont, and size: CGFloat) -> UIFont {
        return UIFont(name: name.rawValue, size: size) ?? UIFont.preferredFont(forTextStyle: .headline)
    }
}

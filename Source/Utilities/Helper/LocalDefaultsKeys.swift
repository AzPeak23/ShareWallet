//
//  LocalDefaultsKeys.swift
//  WalletSDK
//
//  Created by ashahrouj on 09/02/2023.
//

import Foundation

struct DefaultsKeys {
    static let tutorialHomeScreen = "tutorial_home_screen"
    static let userId = "user_id_cache"

    static var shouldDisplayTutorialHomeScreen: Bool {
        !UserDefaults.standard.bool(forKey: DefaultsKeys.tutorialHomeScreen)
    }
    
    static var getUserId: String {
        UserDefaults.standard.string(forKey: DefaultsKeys.userId) ?? ""
    }
}

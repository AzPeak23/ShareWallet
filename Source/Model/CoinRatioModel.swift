//
//  CoinRatioModel.swift
//  WalletSDK
//
//  Created by ashahrouj on 07/02/2023.
//

import Foundation

typealias CoinRatios = [CoinRatioModel]

struct CoinRatioModel: Codable {
    let coinType: Int
    let name: String
    let usd, yuan, euro: Double
    // let usd, yuan, euro: CurrencyRatio //TODO: change to enum

    enum CodingKeys: String, CodingKey {
        case coinType = "id"
        case name = "coin_type"
        case usd, yuan, euro
    }
}

enum CurrencySymbol: Double {
    case usd
    case yuan
    case euro
    
    var symbol: String {
        switch self {
        case .yuan: return "¥"
        case .usd: return "$"
        case .euro: return "€"
        }
    }
}

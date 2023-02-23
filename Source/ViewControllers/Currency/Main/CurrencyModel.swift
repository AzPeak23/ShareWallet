//
//  CurrencyModel.swift
//  WalletSDK
//
//  Created by ashahrouj on 06/01/2023.
//

import Foundation

class CurrencyModel: Codable {
    let coinType: Int
    let name: String
    let description: String
    var balance: Double
    var amount: String { return "\(balance.descriptionFor8Digits)" }
    
    var publicAddress: PublicAddressModel?
    var ratio: CoinRatioModel?
    
    var ratioBalance: Double {
        return (ratio?.yuan ?? 0) * balance
    }
    
    var ratioBalanceForDisplay: String { return ratioBalance.descriptionFor2Digits }
    
    var asset: CurrencyAssetsEnum {
        if name.contains(CurrencyAssetsEnum.btc.name) {
            return .btc
        } else if name.contains(CurrencyAssetsEnum.eth.name) {
            return .eth
        } else if name.contains(CurrencyAssetsEnum.usdtErc20.name) {
            return .usdtErc20
        } else if name.contains(CurrencyAssetsEnum.trx.name) {
            return .trx
        } else if name.contains(CurrencyAssetsEnum.usdtTrc20.name) {
            return .usdtTrc20
        }
        return .empty
    }

    var minersFee: String {
        switch asset {
        case .eth: return "21000"
        case .usdtErc20: return "70000"
        default: return "0"
        }
    }
    
    init(coinType: Int, name: String, description: String, balance: Double = 0) {
        self.coinType = coinType
        self.name = name
        self.description = description
        self.balance = balance
    }
    
    enum CodingKeys: String, CodingKey {
        case coinType = "coin_type"
        case name = "name"
        case description = "description"
        case balance = "balance"
    }
}

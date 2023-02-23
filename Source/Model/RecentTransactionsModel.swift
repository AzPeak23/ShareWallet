//
//  RecentTransactionsModel.swift
//  WalletSDK
//
//  Created by ashahrouj on 10/02/2023.
//

import Foundation

enum RecentTransactionType: String, Codable {
    case received
    case transfer
    
    var title: String {
        switch self {
        case .received: return "recent_records_success_received".localized
        case .transfer: return "recent_records_sent_failed".localized
        }
    }
}

enum RecentTransactionState: String, Codable { //TODO: that should be the same 'TransactionsStatus', needs to refactoring 
    case success
    case failed
    
    var title: String {
        switch self {
        case .success: return "recent_records_sent".localized
        case .failed: return "recent_records_sent_failed".localized
        }
    }
}


struct RecentTransactions: Codable {
    let transactions: [RecentTransactionModel]
    let totalNum, page, pageSize: Int

    enum CodingKeys: String, CodingKey {
        case transactions = "funds_log"
        case totalNum = "total_num"
        case page
        case pageSize = "page_size"
    }
}

// MARK: - FundsLog
struct RecentTransactionModel: Codable {
    let id: Int
    let txid: String
    let uid: Int
    let transactionType: RecentTransactionType
    let merchantUid, userAddress, userAddressName: String
    let oppositeAddress, oppositeAddressName, coinType: String
    let amountOfCoins, usdAmount, yuanAmount, euroAmount: Double
    let networkFee, usdNetworkFee, yuanNetworkFee, euroNetworkFee: Double
    let totalCoinsTransfered, totalUsdTransfered, totalYuanTransfered, totalEuroTransfered: Double
    let creationTime: Double
    let state: RecentTransactionState
    let confirmationTime, gasLimit, gasPrice, gasUsed: Int
    let confirmBlockNumber: Int

    var asset: CurrencyAssetsEnum {
        if coinType.contains(CurrencyAssetsEnum.btc.name) {
            return .btc
        } else if coinType.contains(CurrencyAssetsEnum.eth.name) {
            return .eth
        } else if coinType.contains(CurrencyAssetsEnum.usdtErc20.name) {
            return .usdtErc20
        } else if coinType.contains(CurrencyAssetsEnum.trx.name) {
            return .trx
        } else if coinType.contains(CurrencyAssetsEnum.usdtTrc20.name) {
            return .usdtTrc20
        }
        return .empty
    }
    
    var titleForDisplay: String {
        switch transactionType {
        case .received: return transactionType.title + " \(amountOfCoins.descriptionFor8Digits)" + coinType
        case .transfer:
            switch asset {
            case .usdtErc20, .usdtTrc20: return state.title + " \(amountOfCoins.descriptionFor8Digits) " + coinType
            default: return state.title + " \((amountOfCoins + networkFee).descriptionFor8Digits) " + coinType
            }
        }
    }
    
    var titleForDisplayInList: String {
        switch transactionType {
        case .received: return transactionType.title + " " + coinType
        case .transfer:
            switch asset {
            case .usdtErc20, .usdtTrc20: return state.title + " " + coinType
            default: return state.title + " " + coinType
            }
        }
    }
    
    var amountForDisplayInList: String {
        switch transactionType {
        case .received: return "+\(amountOfCoins.descriptionFor8Digits)"
        case .transfer:
            switch asset {
            case .usdtErc20, .usdtTrc20: return "-\(amountOfCoins.descriptionFor8Digits)"
            default: return "-\((amountOfCoins + networkFee).descriptionFor8Digits)"
            }
        }
    }
    
    var iconForDisplayInList: String {
        switch transactionType {
        case .received: return "success_received_icon"
        case .transfer:
            switch state {
            case .success: return "success_transfer_icon"
            case .failed: return "failed_revecied_icon"
            }
        }
    }
    
    var titleForDisplayCreationTime: String {
        let date = Date(timeIntervalSince1970: creationTime)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd HH:mm"
        //dateFormatter.timeStyle = DateFormatter.Style.medium //Set time style
        //dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
        dateFormatter.timeZone = .current
        let localDate = dateFormatter.string(from: date)
        return localDate
    }
    
    enum CodingKeys: String, CodingKey {
        case id, txid, uid
        case merchantUid = "merchant_uid"
        case transactionType = "transaction_type"
        case userAddress = "user_address"
        case userAddressName = "user_address_name"
        case oppositeAddress = "opposite_address"
        case oppositeAddressName = "opposite_address_name"
        case coinType = "coin_type"
        case amountOfCoins = "amount_of_coins"
        case usdAmount = "usd_amount"
        case yuanAmount = "yuan_amount"
        case euroAmount = "euro_amount"
        case networkFee = "network_fee"
        case usdNetworkFee = "usd_network_fee"
        case yuanNetworkFee = "yuan_network_fee"
        case euroNetworkFee = "euro_network_fee"
        case totalCoinsTransfered = "total_coins_transfered"
        case totalUsdTransfered = "total_usd_transfered"
        case totalYuanTransfered = "total_yuan_transfered"
        case totalEuroTransfered = "total_euro_transfered"
        case creationTime = "creation_time"
        case state
        case confirmationTime = "confirmation_time"
        case gasLimit = "gas_limit"
        case gasPrice = "gas_price"
        case gasUsed = "gas_used"
        case confirmBlockNumber = "confirm_block_number"
    }
}

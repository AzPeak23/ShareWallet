//
//  TransactionDetailsNotificationModel.swift
//  WalletSDK
//
//  Created by ashahrouj on 20/02/2023.
//

import Foundation

// MARK: - Welcome
struct TransactionDetailsNotificationModel: Codable {
    let coinType: Int
    let publicAddress, transactionHash: String

    enum CodingKeys: String, CodingKey {
        case coinType = "coin_type"
        case publicAddress = "public_address"
        case transactionHash = "transaction_hash"
    }
}

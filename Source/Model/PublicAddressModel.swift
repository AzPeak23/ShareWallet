//
//  PublicAddressModel.swift
//  WalletSDK
//
//  Created by ashahrouj on 02/02/2023.
//

import Foundation

//typealias publicAddressReponse = [PublicAddressModel]

struct PublicAddressModel: Codable {
    let name: String
    let coinType: Int
    let address, contractAddress: String

    enum CodingKeys: String, CodingKey {
        case name
        case coinType = "coin_type"
        case address
        case contractAddress = "contract_address"
    }
}


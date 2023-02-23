//
//  ConfigurationModel.swift
//  WalletSDK
//
//  Created by ashahrouj on 04/01/2023.
//

import Foundation

struct ConfigurationModel: Codable {
    var platform: Int = 2
    //var apiAddr: String = "http://devwalletapi.ddns.net:81"//"https://api.sharewallet-test.com"// // http://192.168.1.134:20001
    var apiAddr: String = "https://api.sharewallet-test.com"
    var dataDir: String = LocalFileManager.shared.getPath(for: .walletSdk)
    var logLevel: Int = 1
    
    enum CodingKeys: String, CodingKey {
        case platform = "platform"
        case apiAddr = "api_addr"
        case dataDir = "data_dir"
        case logLevel = "log_level"
    }
    
    init () { }
}

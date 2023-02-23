//
//  TransactionsHistoryModel.swift
//  WalletSDK
//
//  Created by ashahrouj on 21/12/2022.
//

import Foundation

// MARK: - DataClass
class TransactionsHistoryModel: Codable {
    let operationID: String
    let transaction: [TransactionHistoryModel]
    let tranNums, page, pageSize: Int

    enum CodingKeys: String, CodingKey {
        case operationID, transaction
        case tranNums = "tran_nums"
        case page
        case pageSize = "page_size"
    }
}

class TransactionAddressModel: Codable {
    let name: String
    let address: String
}

class TransactionHistoryModel: Codable {
    
    let transactionID: Int
    let uuID: String
    let currentTransactionType: Int
    let senderAccount, receiverAccount: TransactionAddressModel?
    let senderAddress, receiverAddress: String
    let confirmTimeDouble: Double
    let transactionHash: String
    let sentTime: Int
    let amount, fee: Double
    let gasPriceConv: String?
    let isSend: Bool
    let gasUsed, gasLimit: Double?
    //let gasPrice: Int?
    let confirmBlockNumber: String
    let status: TransactionsStatus
    
    var currencyAssetsType: CurrencyAssetsEnum?
    var receiverAddressForDisplay: (title: String, hideBackgoundColor: Bool) {
        switch isSend {
        case true:
            guard let receiverAccount = receiverAccount else {
                return ("transaction_details_save_to_my_address".localized, false)
            }
            return (String(format: "transaction_details_name_title".localized, receiverAccount.name), true)
        case false: return ("transaction_details_myself_address_title".localized, true)
        }
    }
    
    var senderAddressForDisplay: (title: String, hideBackgoundColor: Bool) {
        switch isSend {
        case true:
            return ("transaction_details_myself_address_title".localized, true)
        case false:
            guard let senderAccount = senderAccount else {
                return ("transaction_details_save_to_my_address".localized, false)
            }
            return (String(format: "transaction_details_name_title".localized, senderAccount.name), true)
        }
    }
    
    
    var amountForDisplayInHistoryList: String {
        switch option {
        case .send:
            switch currencyAssetsType {
            case .usdtErc20, .usdtTrc20: return "\("-")\(amount.descriptionFor8Digits)"
            default: return "\("-")\((amount + fee).descriptionFor8Digits)"
            }
        case .receive: return "\("+")\(amount.descriptionFor8Digits)"
        default: return amount.descriptionFor8Digits
        }
    }
    
    var option: TransactionsHistoryOptions {
        return isSend ? .send : .receive
    }

    var confirmTime: String {
        let date = Date(timeIntervalSince1970: confirmTimeDouble)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm:ss"
        //dateFormatter.timeStyle = DateFormatter.Style.medium //Set time style
        //dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
        dateFormatter.timeZone = .current
        let localDate = dateFormatter.string(from: date)
        return localDate
    }
    
    enum CodingKeys: String, CodingKey {
        case transactionID, uuID
        case currentTransactionType = "current_transaction_type"
        case senderAccount = "sender_account"
        case senderAddress = "sender_address"
        case receiverAccount = "receiver_account"
        case receiverAddress = "receiver_address"
        case confirmTimeDouble = "confirm_time"
        case transactionHash = "transaction_hash"
        case sentTime = "sent_time"
        case status
        case amount = "amount_conv"
        case fee = "fee_conv"
        case gasPriceConv = "gas_price_conv"
        case isSend = "is_send"
        case gasUsed = "gas_used"
        case gasLimit = "gas_limit"
        //case gasPrice = "gas_price"
        case confirmBlockNumber = "confirm_block_number"
    }
}

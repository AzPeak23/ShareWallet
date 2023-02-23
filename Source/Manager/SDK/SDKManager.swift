//
//  SDKManager.swift
//  WalletSDK
//
//  Created by ashahrouj on 04/01/2023.
//

import Foundation
import WalletSdkCore

enum UserStatus {
    case registered
    case other
}

enum SDKError: Error {
    case badURL
    case other(String)
}

enum Result<Value> {
    case success(Value)
    case failure(SDKError)
}

class SDKManager {
    
    static let shared = SDKManager()
    let lang: String = "en"
    var userId: String = DefaultsKeys.getUserId
    var pinCode: String = ""
    var publicAddress: String = ""
    var currencyModel: CurrencyModel?
    var generatedArray: [MnemonicPhrasesModel] = []
    var currencySymbol: CurrencySymbol = .yuan
    
    var serialQueue = DispatchQueue(label: "SDKManager.serialQueue")
    //typealias completionHandler = (Result<Int, SDKError>) -> Void
    private init() { }
    
    func initWalletSDK(config: String, completionHandler: @escaping (Result<Int>) -> Void) {
        serialQueue.async {
            let data = WalletSdkCore.Cold_walletInitWalletSDK(self.userId, config)
            let result = data ? Result.success(1) : Result.failure(SDKError.badURL)
            completionHandler(result)
        }
    }
    
    func checkUserStatus(completionHandler: @escaping (Result<UserStatus>) -> Void) {
        serialQueue.async {
            let data = WalletSdkCore.Cold_walletGetUserStatus()
            let result = data == 4 ? Result.success(UserStatus.registered) : Result.success(UserStatus.other)
            completionHandler(result)
        }
    }
    
    func getCoinRatio(completionHandler: @escaping (Result<CoinRatios>) -> Void) {
        serialQueue.async {
            let data = WalletSdkCore.Hot_walletGetCoinRatio()
            guard let result = Helper.shared.convertJsonToObject(with: CoinRatios.self, with: data) else {
                return completionHandler(.failure(.badURL))
            }
            completionHandler(.success(result))
        }
    }
    
    func generateUserAccount(completionHandler: @escaping (Result<String>) -> Void) {
        serialQueue.async {
            let data = WalletSdkCore.Cold_walletGenerateUserAccount(self.lang, self.pinCode)
            completionHandler(.success(data))
        }
    }
    
    func fetchSeedPhrase(by word: String, completionHandler: @escaping (Result<String>) -> Void) {
        serialQueue.async {
            DispatchQueue.main.async {
                let data = WalletSdkCore.Cold_walletFetchSeedPhraseWord(word)
                completionHandler(.success(data))
            }
        }
    }
    
    func recoverUserAccount(for phrases: String, completionHandler: @escaping (Result<Bool>) -> Void) {
        serialQueue.async {
            DispatchQueue.main.async {
                let data = WalletSdkCore.Cold_walletRecoverUserAccount(self.pinCode, phrases)
                completionHandler(.success(data))
            }
        }
    }
    
    func verifyPasscode(for password: String, completionHandler: @escaping (Result<Bool>) -> Void) {
        serialQueue.async {
            DispatchQueue.main.async {
                let data = WalletSdkCore.Cold_walletVerifyPasscode(password)
                completionHandler(.success(data))
            }
        }
    }
    
    func fetchLocalCoins(completionHandler: @escaping (Result<[CurrencyModel]>) -> Void) {
        serialQueue.async {
            DispatchQueue.main.async {
                let data = WalletSdkCore.Cold_walletFetchLocalCoins()
                let result = Helper.shared.convertJsonToObject(with: [CurrencyModel].self, with: data)
                completionHandler(.success(result ?? []))
            }
        }
    }
    
    
    func updateCoinStatuses() {
        serialQueue.async {
            DispatchQueue.main.async {
               let _ = WalletSdkCore.Hot_walletGetCoinStatuses()
            }
        }
    }
    
    func getSeedPhrase(completionHandler: @escaping (Result<String>) -> Void) {
        serialQueue.async {
            DispatchQueue.main.async {
                let data = WalletSdkCore.Cold_walletGetUserSeedPhrase(self.pinCode)
                completionHandler(.success(data))
            }
        }
    }
    
    func getAllPublicAddresses(completionHandler: @escaping (Result<[PublicAddressModel]>) -> Void) {
        serialQueue.async {
            DispatchQueue.main.async {
                let coinType = 0 // Zero This means get all addresses
                let data = WalletSdkCore.Hot_walletGetPublicAddress(coinType)
                let result = Helper.shared.convertJsonToObject(with: [PublicAddressModel].self, with: data)
                guard let result = result else {
                    completionHandler(.failure(.badURL))
                    return
                }
                completionHandler(.success(result))
            }
        }
    }
    
    func getPublicAddress(with coidId: Int, completionHandler: @escaping (Result<String>) -> Void) {
        serialQueue.async {
            DispatchQueue.main.async {
                let data = WalletSdkCore.Hot_walletGetPublicAddress(coidId)
                let result = Helper.shared.convertJsonToObject(with: [PublicAddressModel].self, with: data)
                guard let result = result, let model = result.first, !model.address.isEmpty else {
                    completionHandler(.failure(.badURL))
                    return
                }
                self.publicAddress = model.address
                completionHandler(.success(model.address))
            }
        }
    }
    
    func getPrivateKey(with privateKeyType: Int, completionHandler: @escaping (Result<String>) -> Void) {
        serialQueue.async {
            DispatchQueue.main.async {
                let data = WalletSdkCore.Cold_walletGetUserPrivateKey(self.pinCode,
                                                                      self.currencyModel?.coinType ?? 0,
                                                                      privateKeyType)
                completionHandler(.success(data))
            }
        }
    }
    
    //TODO: 'SHAHROUJ' The functionalities must be used in separate protocols ex: 'SDKAddressProtocol'
    func addAddressBook(with coinType: Int, address: String, name: String, completionHandler: @escaping (Result<Bool>) -> Void) {
        serialQueue.async {
            let stop: UnsafeMutablePointer<ObjCBool> = UnsafeMutablePointer.allocate(capacity: 1)
            var error: NSError?
            let data = WalletSdkCore.Cold_walletAddAddressBook(coinType, address, name, stop, &error)
            DispatchQueue.main.async {
                if !data {
                    completionHandler(.failure(.other(error?.localizedDescription ?? "")))
                } else {
                    completionHandler(.success(data))
                }
            }
        }
    }
    
    func deleteAddressBook(with coinType: Int, address: String, completionHandler: @escaping (Result<Bool>) -> Void) {
        serialQueue.async {
            let data = WalletSdkCore.Cold_walletDeleteAddressBook(coinType, address)
            DispatchQueue.main.async {
                completionHandler(.success(data))
            }
        }
    }
    
    func getAddressesBook(with coinType: Int, completionHandler: @escaping (Result<[AddressModel]>) -> Void) {
        serialQueue.async {
            let data = WalletSdkCore.Cold_walletGetLocalUserAddressBook(coinType)
            let result = Helper.shared.convertJsonToObject(with: [AddressModel].self, with: data)

            DispatchQueue.main.async {
                completionHandler(.success(result ?? []))
            }
        }
    }
    
    func getBalance(with coinType: Int, publicAddress: String = SDKManager.shared.publicAddress, completionHandler: @escaping (Result<String>) -> Void) {
        serialQueue.async {
            let data = WalletSdkCore.Hot_walletGetBalance(coinType, publicAddress)
            DispatchQueue.main.async {
                completionHandler(Result.success(data))
            }
        }
    }
    
    func getGas(with coinType: Int, completionHandler: @escaping (Result<String>) -> Void) {
        serialQueue.async {
            let data = WalletSdkCore.Hot_walletGetGasPrice(coinType)
            DispatchQueue.main.async {
                completionHandler(Result.success(data))
            }
        }
    }
    
    func getEstimatedGas(with coinType: Int, and gasPrice: Double, completionHandler: @escaping (Result<String>) -> Void) {
        serialQueue.async {
            let data = WalletSdkCore.Hot_walletGetTransactionFee(Int64(coinType), gasPrice)
            DispatchQueue.main.async {
                completionHandler(Result.success(data))
            }
        }
    }
    
    func transfer(to address: String, coinType: Int , amount: Double, gasPrice: Double, completionHandler: @escaping (Result<String>) -> Void) {
        serialQueue.async {
            SDKManager.shared.getPublicAddress(with: coinType) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let publicAddress):
                    self.publicAddress = publicAddress
                    var error: NSError?
                    let data = WalletSdkCore.Hot_walletTransfer(coinType, publicAddress, address, self.pinCode, amount, gasPrice, &error)
                    DispatchQueue.main.async {
                        if data.isEmpty {
                            completionHandler(.failure(.other(error?.localizedDescription ?? "")))
                        } else {
                            completionHandler(Result.success(data))
                        }
                    }
                case .failure(let error):
                    print("something wronge when get public address \(error)")
                    completionHandler(.failure(.badURL))
                }
            }
        }
    }
    
    func transactionList(with transactionType: Int, coinType: Int, pageNumber: Int = 1, pageSize: Int, completionHandler: @escaping (Result<TransactionsHistoryModel?>) -> Void) {
        serialQueue.async {
            SDKManager.shared.getPublicAddress(with: coinType) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let publicAddress):
                    self.publicAddress = publicAddress
                    let data = WalletSdkCore.Hot_walletGetTransactionList(coinType, publicAddress, transactionType, pageNumber, pageSize, "create_time:desc")
                    let result = Helper.shared.convertJsonToObject(with: TransactionsHistoryModel.self, with: data)

                    DispatchQueue.main.async {
                        completionHandler(.success(result))
                    }
                case .failure(let error):
                    print("something wronge when get public address \(error)")
                    completionHandler(.failure(.badURL))
                }
            }
        }
    }
    
    func getRecentTransactions(pageNumber: Int = 1, pageSize: Int, completionHandler: @escaping (Result<RecentTransactions?>) -> Void) {
        serialQueue.async {
            let data = WalletSdkCore.Hot_walletGetRecentTransactions(pageNumber, pageSize)
            let result = Helper.shared.convertJsonToObject(with: RecentTransactions.self, with: data)

            DispatchQueue.main.async {
                completionHandler(.success(result))
            }
        }
    }
    
    func getTransaction(by hash: String, and coinType: Int ,completionHandler: @escaping (Result<TransactionHistoryModel?>) -> Void) {
        serialQueue.async {
            SDKManager.shared.getPublicAddress(with: coinType) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let publicAddress):
                    self.publicAddress = publicAddress
                    let data = WalletSdkCore.Hot_walletGetTransaction(coinType, publicAddress, hash)
                    let result = Helper.shared.convertJsonToObject(with: TransactionHistoryModel.self, with: data)

                    DispatchQueue.main.async {
                        completionHandler(.success(result))
                    }
                case .failure(let error):
                    print("something wronge when get public address \(error)")
                    completionHandler(.failure(.badURL))
                }
            }
        }
    }
}

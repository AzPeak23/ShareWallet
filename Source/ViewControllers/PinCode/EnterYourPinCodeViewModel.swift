//
//  EnterYourPinCodeViewModel.swift
//  WalletSDK
//
//  Created by ashahrouj on 02/01/2023.
//

import Foundation

public class EnterYourPinCodeViewModel {
    
    init() {
        
    }
    
    public func verifyPasscode(with password: String, completionHandler: @escaping (Bool) -> Void) {
        SDKManager.shared.verifyPasscode(for: password) { [weak self] result in
            guard let _ = self else { return }
            switch result {
            case .success(let data):
                completionHandler(data)
            case .failure(let error):
                print("something wronge when verify \(error)")
                completionHandler(false)
            }
        }
    }
}

//
//  MnemonicPhrasesModel.swift
//  WalletSDK
//
//  Created by ashahrouj on 22/12/2022.
//

import Foundation

enum MnemonicPhrasesType {
    case removable
    case clickable
    case displayOnly(shouldGenerating: Bool)
}

struct MnemonicPhrasesModel: Equatable {
    static func == (lhs: MnemonicPhrasesModel, rhs: MnemonicPhrasesModel) -> Bool {
        return lhs.phraseId == rhs.phraseId
    }
    
    var phraseId: String = UUID().uuidString
    var phrase: String = ""
    var isSelected: Bool = false
     
    init(phrase: String, isSelected: Bool) {
        self.phrase = phrase
        self.isSelected = isSelected
    }
}

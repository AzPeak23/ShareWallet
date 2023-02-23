//
//  RecentRecordsTransactionDetails.swift
//  WalletSDK
//
//  Created by ashahrouj on 16/12/2022.
//

import UIKit
import SnapKit

class RecentRecordsTransactionDetails: UIView {

    private let containerView: UIView = {
        let view = UIView()
        return view
    }()

    private let txIDTransactionRow: ToFromTransactionDetailsView = {
        let view = ToFromTransactionDetailsView()
        return view
    }()
    
    private let timeGasRowView: TimeGasTransactionDetailsView = {
        let view = TimeGasTransactionDetailsView()
        return view
    }()
    
    var didTapOnSaveToMyAddress: (ToFromTransactionRow.ToFromRowTapAction) -> Void = {_ in }
    init(shouldHideTimeGasSection: Bool) {
        super.init(frame: .zero)
        setupViews(with: shouldHideTimeGasSection)
        setupConstraints(with: shouldHideTimeGasSection)
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        containerView.backgroundColor = .wWhite
        containerView.corner()
        containerView.dropShadow(with: UIColor.wDarkGray.cgColor, onlyBottom: false, shadowOpacity: 0.1)
    
        txIDTransactionRow.backgroundColor = .wWhite
        txIDTransactionRow.corner()
        txIDTransactionRow.dropShadow(with: UIColor.wDarkGray.cgColor, onlyBottom: false, shadowOpacity: 0.1)
        
    }
    
    func setupViews(with shouldHideTimeGasSection: Bool) {
        addSubview(containerView)
        if !shouldHideTimeGasSection {
            containerView.addSubview(timeGasRowView)
        }
        containerView.addSubview(txIDTransactionRow)
        
        txIDTransactionRow.didTapOnSaveToMyAddress = {[weak self] address in
            guard let self = self else { return }
            self.didTapOnSaveToMyAddress(address)
        }
    }
    
    func setupConstraints(with shouldHideTimeGasSection: Bool) {
        containerView.snp.makeConstraints { make in
            make.top.equalTo(15)
            make.leading.equalTo(24)
            make.trailing.equalTo(-24)
            make.bottom.equalTo(-15)
        }
        
        if !shouldHideTimeGasSection {
            timeGasRowView.snp.makeConstraints { make in
                make.top.equalTo(15)
                make.leading.equalTo(20)
                make.trailing.equalTo(-20)
            }
        }
        
        txIDTransactionRow.snp.makeConstraints { make in
            if shouldHideTimeGasSection { make.top.equalTo(15) }
            else { make.top.equalTo(timeGasRowView.snp.bottom).offset(10) }
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.bottom.equalTo(-15)
        }
    }

    func setData(with transactionHistoryModel: TransactionHistoryModel) {
        txIDTransactionRow.setData(with: transactionHistoryModel)
        timeGasRowView.setData(with: transactionHistoryModel)
    }
    
}

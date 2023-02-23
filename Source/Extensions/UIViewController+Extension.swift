//
//  UIViewController+Extension.swift
//  WalletSDK
//
//  Created by ashahrouj on 14/12/2022.
//

import UIKit
import ToastViewSwift

extension UIViewController {
    
    func showToast(with text: String) {
        let config = ToastConfiguration(
            direction: .bottom,
            autoHide: true,
            enablePanToClose: true,
            displayTime: 0.8,
            animationTime: 0.2
        )
        
        let attributes = [
            NSAttributedString.Key.font: UIFont.font(name: .semiBold, and: 15),
            NSAttributedString.Key.foregroundColor: UIColor.black
        ]
        let attributedString  = NSMutableAttributedString(string: text , attributes: attributes)
        
        let toast = Toast.text(attributedString, config: config)
        toast.show()
    }
    
    func displayTryAgain(completionHandler: @escaping () -> Void) {
        let view =  PopUpTwoActionsViewController(text: "something_wrong_try_again".localized, titleLeftButton: "cancel_title".localized, titleRightButton: "other_try_again_title".localized)
        
        view.rightPressed = { 
            view.dismiss(animated: true)
            completionHandler()
        }
        
        view.leftPressed = {[weak self] in
            view.dismiss(animated: true)
            self?.navigationController?.popViewController(animated: true)
        }
        
        self.present(view, animated: true)
    }
}

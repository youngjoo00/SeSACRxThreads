//
//  UIViewController+.swift
//  SeSACRxThreads
//
//  Created by youngjoo on 3/29/24.
//

import UIKit

extension BaseViewController {
    
    func showAlert(title: String?, message: String?, btnTitle: String?, complectionHandler: @escaping () -> Void) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: btnTitle, style: .default) { _ in
            complectionHandler()
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(action)
        alert.addAction(cancel)
        
        present(alert, animated: true)
    }
    
    func showAlert(title: String?) {
        
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "확인", style: .cancel)
        
        alert.addAction(cancel)
        
        present(alert, animated: true)
    }
}

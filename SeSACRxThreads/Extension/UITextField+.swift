//
//  UITextField+.swift
//  SeSACRxThreads
//
//  Created by youngjoo on 4/2/24.
//

import UIKit

extension UITextField {
    
    func addLeftPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        // 텍스트필드의 leftView 를 항상 보이게 함으로써 10의 공백을 띄워줌
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
    }
    
}

//
//  DetailShoppingView.swift
//  SeSACRxThreads
//
//  Created by youngjoo on 4/3/24.
//

import UIKit
import Then

final class DetailShoppingView: BaseView {
    
    let label = UILabel()
    
    override func configureHierarchy() {
        [
            label
        ].forEach { addSubview($0) }
    }
    
    override func configureLayout() {
        
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    override func configureView() {
        
    }
}

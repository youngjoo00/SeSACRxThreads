//
//  PhoneViewModel.swift
//  SeSACRxThreads
//
//  Created by youngjoo on 4/4/24.
//

import Foundation
import RxSwift
import RxCocoa

final class PhoneViewModel: BaseViewModel {
    
    let inputPhone = PublishSubject<String>()
    
    let outputValid = BehaviorRelay(value: false)
    let outputInitialText = BehaviorRelay(value: "010")
    
    override init() {
        super.init()
        
        transform()
    }
    
    private func transform() {
        inputPhone
            .map {
                let isValid = $0.count >= 10 && $0.count <= 11
                let isInteger = Int($0) != nil
                let is010Number = $0.hasPrefix("010")
                return isValid && isInteger && is010Number
            }
            .subscribe(with: self) { owner, value in
                owner.outputValid.accept(value)
            }
            .disposed(by: disposeBag)
    }
}

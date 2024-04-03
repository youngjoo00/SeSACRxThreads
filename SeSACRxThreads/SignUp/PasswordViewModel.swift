//
//  PasswordViewModel.swift
//  SeSACRxThreads
//
//  Created by youngjoo on 4/3/24.
//

import Foundation
import RxSwift
import RxCocoa

final class PasswordViewModel: BaseViewModel {

    let inputPassword = PublishSubject<String>()
    
    let outputValid = BehaviorRelay(value: false)

    override init() {
        super.init()
        
        transform()
    }
    
    private func transform() {
        inputPassword
            .map { $0.count >= 5 }
            .subscribe(with: self) { owner, value in
                owner.outputValid.accept(value)
            }
            .disposed(by: disposeBag)
    }
}

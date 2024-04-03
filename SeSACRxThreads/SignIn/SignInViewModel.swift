//
//  SignInViewModel.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import Foundation
import RxSwift
import RxCocoa

final class SignInViewModel: BaseViewModel {
    
    let inputEmail = PublishSubject<String>()
    let inputPassword = PublishSubject<String>()
    
    let outputEmailValid = BehaviorRelay(value: false)
    let outputPasswordValid = BehaviorRelay(value: false)
    let outputSignInValid = BehaviorRelay(value: false)
    
    override init() {
        super.init()
        
        transform()
    }
    
    private func transform() {
        Observable.combineLatest(outputEmailValid, outputPasswordValid) { $0 && $1 }
            .bind(to: outputSignInValid)
            .disposed(by: disposeBag)
        
        inputEmail
            .subscribe(with: self) { owner, text in
                let valid = owner.validateEmail(text)
                owner.outputEmailValid.accept(valid)
            }
            .disposed(by: disposeBag)
        
        inputPassword
            .map { $0.count >= 5 }
            .subscribe(with: self) { owner, value in
                owner.outputPasswordValid.accept(value)
            }
            .disposed(by: disposeBag)
    }
}

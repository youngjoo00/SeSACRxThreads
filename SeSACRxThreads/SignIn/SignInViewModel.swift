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
    
    struct Input {
        let email: ControlProperty<String?>
        let password: ControlProperty<String?>
        let signUpButtonTap: ControlEvent<Void>
        let signInButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let signUpButtonTap: ControlEvent<Void>
        let signInButtonTap: ControlEvent<Void>
        let enabled: Driver<Bool>
    }
    
    override init() {
        super.init()
    }
    
    func transform(input: Input) -> Output {
        
        let email = input.email
            .orEmpty
            .map { $0.count >= 8 && $0.contains("@") }
        
        let password = input.password
            .orEmpty
            .map { $0.count >= 5 }
        
        let enabled = Observable.combineLatest(email, password) { $0 && $1 }
            .asDriver(onErrorJustReturn: false)
        
        return Output(signUpButtonTap: input.signUpButtonTap,
                      signInButtonTap: input.signInButtonTap,
                      enabled: enabled)
    }
}

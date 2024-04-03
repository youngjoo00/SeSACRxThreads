//
//  SignUpViewModel.swift
//  SeSACRxThreads
//
//  Created by youngjoo on 4/3/24.
//

import RxSwift
import RxCocoa

final class SignUpViewModel: BaseViewModel {
    
    // input
    let inputEmail = PublishSubject<String>()
    let inputValidButtonTap = PublishSubject<Void>()
    
    // output
    let outputValidText = BehaviorRelay(value: "유효한 형식이 아닙니다.")
    let outputValidButton = BehaviorRelay(value: false)
    let outputValidNextButton = BehaviorRelay(value: false)
    
    override init() {
        super.init()
        
        transform()
    }
    
    private func transform() {
        inputEmail
            .subscribe(with: self) { owner, text in
                owner.emailTextValid(text)
            }
            .disposed(by: disposeBag)
        
        inputValidButtonTap
            .subscribe(with: self) { owner, _ in
                owner.outputValidNextButton.accept(true)
            }
            .disposed(by: disposeBag)
    }
    
}

extension SignUpViewModel {
    
    private func emailTextValid(_ text: String) {
        let isValid = validateEmail(text)
        
        outputValidText.accept(isValid ? "" : "유효한 형식이 아닙니다.")
        outputValidButton.accept(isValid)
        
        guard isValid else {
            return outputValidNextButton.accept(false)
        }
        
    }
}

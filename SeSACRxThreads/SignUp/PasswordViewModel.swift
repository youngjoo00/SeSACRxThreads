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

    struct Input {
        let password: ControlProperty<String?>
        let nextButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let valid: Driver<Bool>
        let description: Driver<String>
        let nextButtonTap: ControlEvent<Void>
    }

    override init() {
        super.init()
    }
    
    func transform(input: Input) -> Output {
        let valid = input.password
            .orEmpty
            .map { $0.count >= 5 }
            .asDriver(onErrorJustReturn: false)
        
        let description = valid
            .map { $0 ? "" : "비밀번호는 최소 5자 이상입니다" }
            .asDriver(onErrorJustReturn: "")
        
        return Output(valid: valid, 
                      description: description,
                      nextButtonTap: input.nextButtonTap)
    }
}

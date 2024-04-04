//
//  NicknameViewModel.swift
//  SeSACRxThreads
//
//  Created by youngjoo on 4/4/24.
//

import Foundation
import RxSwift
import RxCocoa

final class NicknameViewModel: BaseViewModel {
    
    struct Input {
        let nickname: ControlProperty<String?>
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
        let valid = input.nickname
            .orEmpty
            .map { $0.count >= 2 }
            .asDriver(onErrorJustReturn: false)
        
        let description = valid
            .map { $0 ? "" : "닉네임은 최소 두 글자 이상입니다" }
            .asDriver()
        
        return Output(valid: valid, 
                      description: description, 
                      nextButtonTap: input.nextButtonTap)
    }
}

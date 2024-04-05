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
    
    struct Input {
        let viewDidLoad: Observable<Void>
        let phone: ControlProperty<String?>
        let nextButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let valid: Driver<Bool>
        let description: Driver<String>
        let nextButtonTap: ControlEvent<Void>
        let initialPhoneNumber: Driver<String>
    }
    
    override init() {
        super.init()
    }
    
    func transform(input: Input) -> Output {
        let initialPhoneNumber = BehaviorRelay(value: "")

        let valid = input.phone
            .orEmpty
            .map {
                let isValid = $0.count >= 10 && $0.count <= 11
                let isInteger = Int($0) != nil
                let is010Number = $0.hasPrefix("010")
                return isValid && isInteger && is010Number
            }
            .asDriver(onErrorJustReturn: false)
        
        let description = valid
            .map { $0 ? "" : "유효한 휴대폰 번호 형식이 아닙니다"}
            .asDriver()
        
        input.viewDidLoad
            .debug()
            .subscribe(with: self) { owner, _ in
                initialPhoneNumber.accept("010")
            }
            .disposed(by: disposeBag)
        
        let initialPhoneNumberResult = initialPhoneNumber
            .asDriver(onErrorJustReturn: "")
            .debug()
        
        return Output(valid: valid,
                      description: description,
                      nextButtonTap: input.nextButtonTap,
                      initialPhoneNumber: initialPhoneNumberResult
        )
    }
}

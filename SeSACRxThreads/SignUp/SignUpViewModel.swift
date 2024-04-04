//
//  SignUpViewModel.swift
//  SeSACRxThreads
//
//  Created by youngjoo on 4/3/24.
//

import RxSwift
import RxCocoa

final class SignUpViewModel: BaseViewModel {
    
    struct Input {
        let email: ControlProperty<String?>
        let validationButtonTap: ControlEvent<Void>
        let nextButtonTap: ControlEvent<Void>
        let nextButtonEnabled: Observable<Void>
    }
    
    struct Output {
        let valid: Driver<Bool>
        let description: Driver<String>
        let validationButtonTap: ControlEvent<Void>
        let nextButtonTap: ControlEvent<Void>
        let nextButtonEnabled: Driver<Bool>
    }
    
    override init() {
        super.init()
    }
    
    func transform(input: Input) -> Output {
        
        let valid = input.email
            .orEmpty
            .map { [weak self] email in
                return self?.validateEmail(email) ?? false
            }
            .asDriver(onErrorJustReturn: false)
        
        let description = valid
            .map { $0 ? "" : "유효하지 않은 이메일 형식입니다" }
            .asDriver()
        
        let nextButtonEnabled = input.nextButtonEnabled
            .map { true }
            .asDriver(onErrorJustReturn: false)

        return Output(valid: valid,
                      description: description,
                      validationButtonTap: input.validationButtonTap,
                      nextButtonTap: input.nextButtonTap,
                      nextButtonEnabled: nextButtonEnabled
        )
    }
    
}

//extension SignUpViewModel {
//    
//    private func emailTextValid(_ text: String) {
//        let isValid = validateEmail(text)
//        
//        outputValidText.accept(isValid ? "" : "유효한 형식이 아닙니다.")
//        outputValidButton.accept(isValid)
//        
//        guard isValid else {
//            return outputValidNextButton.accept(false)
//        }
//        
//    }
//}

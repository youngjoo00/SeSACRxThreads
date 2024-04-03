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
    
    let inputNickanme = PublishSubject<String>()
    
    let outputValid = BehaviorRelay(value: false)
    
    override init() {
        super.init()
        
        transform()
    }
    
    private func transform() {
        inputNickanme
            .map { $0.count >= 2}
            .subscribe(with: self) { owner, value in
                owner.outputValid.accept(value)
            }
            .disposed(by: disposeBag)
    }
}

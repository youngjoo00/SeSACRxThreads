//
//  BirthdayViewModel.swift
//  SeSACRxThreads
//
//  Created by youngjoo on 3/30/24.
//

import Foundation
import RxSwift
import RxRelay

final class BirthdayViewModel: BaseViewModel {
    
    let inputBirthday: BehaviorSubject<Date> = BehaviorSubject(value: .now)
    
    let outputIsInfo = PublishRelay<Bool>()
    let outputYear = PublishRelay<String>()
    let outputMonth = PublishRelay<String>()
    let outputDay = PublishRelay<String>()
    
    override init() {
        super.init()
        transform()
    }
    
    private func transform() {
        inputBirthday.subscribe(with: self) { owner, date in
            let birth = Calendar.current.dateComponents([.year, .month, .day], from: date)
            let now = Calendar.current.dateComponents([.year, .month, .day], from: .now)

            guard let birthYear = birth.year, let birthMonth = birth.month, let birthDay = birth.day,
                  let nowYear = now.year, let nowMonth = now.month, let nowDay = now.day else { return }
            
            owner.outputYear.accept("\(birthYear)년")
            owner.outputMonth.accept("\(birthMonth)월")
            owner.outputDay.accept("\(birthDay)일")
            
            let possibleYear = nowYear - 17
            if (birthYear < possibleYear) ||
                (birthYear == possibleYear && birthMonth < nowMonth) ||
                (birthYear == possibleYear && birthMonth == nowMonth && birthDay < nowDay) {
                owner.outputIsInfo.accept(true)
            } else {
                owner.outputIsInfo.accept(false)
            }
        }
        .disposed(by: disposeBag)
    }
}

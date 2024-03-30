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
    
    let birthday: BehaviorSubject<Date> = BehaviorSubject(value: .now)
    
    let isInfo = PublishRelay<Bool>()
    let year = PublishRelay<Int>()
    let month = PublishRelay<Int>()
    let day = PublishRelay<Int>()
    
    override init() {
        super.init()
        transform()
    }
    
    private func transform() {
        birthday.subscribe(with: self) { owner, date in
            let birth = Calendar.current.dateComponents([.year, .month, .day], from: date)
            let now = Calendar.current.dateComponents([.year, .month, .day], from: .now)

            guard let birthYear = birth.year, let birthMonth = birth.month, let birthDay = birth.day,
                  let nowYear = now.year, let nowMonth = now.month, let nowDay = now.day else { return }
            
            owner.year.accept(birthYear)
            owner.month.accept(birthMonth)
            owner.day.accept(birthDay)
            
            let possibleYear = nowYear - 17
            if (birthYear < possibleYear) ||
                (birthYear == possibleYear && birthMonth < nowMonth) ||
                (birthYear == possibleYear && birthMonth == nowMonth && birthDay < nowDay) {
                owner.isInfo.accept(true)
            } else {
                owner.isInfo.accept(false)
            }
            
        } onDisposed: { owner in
            print("birthday dispose")
        }
        .disposed(by: disposeBag)
    }
}

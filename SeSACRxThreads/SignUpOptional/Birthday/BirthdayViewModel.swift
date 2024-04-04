//
//  BirthdayViewModel.swift
//  SeSACRxThreads
//
//  Created by youngjoo on 3/30/24.
//

import Foundation
import RxSwift
import RxCocoa

final class BirthdayViewModel: BaseViewModel {
    
    struct Input {
        let birthday: ControlProperty<Date>
    }
    
    struct Output {
        let year: Driver<String>
        let month: Driver<String>
        let day: Driver<String>
        let valid: Driver<Bool>
        let description: Driver<String>
    }
    
    override init() {
        super.init()
    }
    
    func transform(input: Input) -> Output {
        
        let year = PublishRelay<Int>()
        let month = PublishRelay<Int>()
        let day = PublishRelay<Int>()
        
        let valid = PublishRelay<Bool>()
        
        input.birthday
            .subscribe(with: self) { owner, date in
            let birth = Calendar.current.dateComponents([.year, .month, .day], from: date)
            let now = Calendar.current.dateComponents([.year, .month, .day], from: .now)

            guard let birthYear = birth.year, let birthMonth = birth.month, let birthDay = birth.day,
                  let nowYear = now.year, let nowMonth = now.month, let nowDay = now.day else { return }
            
            year.accept(birthYear)
            month.accept(birthMonth)
            day.accept(birthDay)
            
            let possibleYear = nowYear - 17
            if (birthYear < possibleYear) ||
                (birthYear == possibleYear && birthMonth < nowMonth) ||
                (birthYear == possibleYear && birthMonth == nowMonth && birthDay < nowDay) {
                valid.accept(true)
            } else {
                valid.accept(false)
            }
        }
        .disposed(by: disposeBag)
        
        let yearResult = year
            .map { "\($0)년" }
            .asDriver(onErrorJustReturn: "")
        
        let monthResult = month
            .map { "\($0)월" }
            .asDriver(onErrorJustReturn: "")
        
        let dayResult = day
            .map { "\($0)일" }
            .asDriver(onErrorJustReturn: "")
        
        let validResult = valid
            .asDriver(onErrorJustReturn: false)
        
        let description = valid
            .map { $0 ? "가입 가능한 나이입니다" : "만 17세 이상만 가입 가능합니다"}
            .asDriver(onErrorJustReturn: "오류입니다.")
        
        return Output(year: yearResult,
                      month: monthResult,
                      day: dayResult,
                      valid: validResult, 
                      description: description)
    }
}

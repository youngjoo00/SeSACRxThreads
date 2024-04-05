//
//  BoxOfficeViewModel.swift
//  SeSACRxThreads
//
//  Created by jack on 2024/04/05.
//

import Foundation
import RxSwift
import RxCocoa

class BoxOfficeViewModel {
     
    let disposeBag = DisposeBag()
    
    var recent = ["테스트", "테스트1", "테스트2"]
    
    struct Input {
        let searchButtonTap: ControlEvent<Void>
        let searchText: ControlProperty<String?>
        let recentText: PublishSubject<String>
    }
    
    struct Output {
        let recentList: BehaviorRelay<[String]>
        let movieList: PublishRelay<[DailyBoxOfficeList]>
    }
    
    
    func transform(input: Input) -> Output {
         
        let recentList = BehaviorRelay(value: recent)
        let movieList = PublishRelay<[DailyBoxOfficeList]>()
        
        input.searchButtonTap
            .throttle(.seconds(1), scheduler: MainScheduler.instance) // 버튼은 1초에 한번만 눌리게
            .withLatestFrom(input.searchText.orEmpty)
            .map {
                if let isInt = Int($0) {
                    return isInt
                } else {
                    return 20240101
                }
            }
            .map { String($0) }
            // 일반 map 을 사용하게 되면, Observable<Movie> 타입으로 나오게 되어 문제가 발생함
            // 그래서, flatMap 을 사용해서 movie 타입만 갖게 만든다.
            .flatMap { BoxOfficeNetwork.fetchBoxOfficeData(date: $0) }
            .subscribe { movie in
                movieList.accept(movie.boxOfficeResult.dailyBoxOfficeList)
            } onError: { error in
                print(error)
            } onCompleted: {
                print("complete")
            } onDisposed: {
                print("dispose")
            }
            .disposed(by: disposeBag)
            
        // 여기서 배열 어떻게 추가하죠?
        // recent 를 String 배열로 만들어서 append
        input.recentText
            .subscribe(with: self) { owner, text in
                owner.recent.append(text)
                recentList.accept(owner.recent)
            }
            .disposed(by: disposeBag)
        
        return Output(recentList: recentList,
                      movieList: movieList)
    }
    
    
}





//
//  ShoppingViewModel.swift
//  SeSACRxThreads
//
//  Created by youngjoo on 4/4/24.
//

import Foundation
import RxSwift
import RxCocoa

final class ShoppingViewModel: BaseViewModel {
    
    var data = [
        Shopping(complete: false, todo: "할 일을 추가해보세요", favorite: false)
    ]
    
    lazy var items = BehaviorSubject(value: data)
    
    let inputSearchText = PublishSubject<String>()
    let inputTextFieldText = PublishSubject<String>()
    let inputAddButtonTap = PublishSubject<Void>()
    let inputSearchButtonTap = PublishSubject<Void>()
    
    override init() {
        super.init()
        
        transform()
    }
    
    private func transform() {
        
        // RealTime Search
        inputSearchText
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(with: self) { owner, text in
                let filterData = text.isEmpty ? owner.data : owner.data.filter { $0.todo.contains(text) }
                owner.items.onNext(filterData)
            }
            .disposed(by: disposeBag)
        
        // searchButtonTap
        inputSearchButtonTap
            .withLatestFrom(inputSearchText)
            .distinctUntilChanged()
            .subscribe(with: self) { owner, text in
                let filterData = text.isEmpty ? owner.data : owner.data.filter { $0.todo.contains(text) }
                owner.items.onNext(filterData)
            }
            .disposed(by: disposeBag)
        
        // addButton Tap
        inputAddButtonTap
            .withLatestFrom(inputTextFieldText)
            .bind(with: self) { owner, text in
                if !text.isEmpty {
                    let newData = Shopping(complete: false, todo: text, favorite: false)
                    owner.data.append(newData)
                    owner.items.onNext(owner.data)
                }
            }
            .disposed(by: disposeBag)
        
        
    }
    
    func updateTodo(_ index: Int, text: String) {
        data[index].todo = text
        items.onNext(data)
    }
    
    func deleteTodo(_ index: Int) {
        data.remove(at: index)
        items.onNext(data)
    }
    
    func completeButtonTap(_ index: Int) {
        data[index].complete.toggle()
        items.onNext(data)
    }
    
    func favoriteButtonTap(_ index: Int) {
        data[index].favorite.toggle()
        items.onNext(data)
    }
}

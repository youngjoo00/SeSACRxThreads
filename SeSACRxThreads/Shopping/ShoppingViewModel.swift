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
    
    lazy var items = BehaviorRelay(value: data)
    
    struct Input {
        let searchText: ControlProperty<String?>
        let todoText: ControlProperty<String?>
        let addButtonTap: ControlEvent<Void>
        let searchButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let items: Driver<[Shopping]>
    }
    
    override init() {
        super.init()
    }
    
    func transform(input: Input) -> Output {
        
        let items = items.asDriver()
        
        // RealTime Search
        input.searchText
            .orEmpty
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(with: self) { owner, text in
                let filterData = text.isEmpty ? owner.data : owner.data.filter { $0.todo.contains(text) }
                owner.items.accept(filterData)
            }
            .disposed(by: disposeBag)
        
        // searchButtonTap
        input.searchButtonTap
            .withLatestFrom(input.searchText.orEmpty)
            .distinctUntilChanged()
            .subscribe(with: self) { owner, text in
                let filterData = text.isEmpty ? owner.data : owner.data.filter { $0.todo.contains(text) }
                owner.items.accept(filterData)
            }
            .disposed(by: disposeBag)
            
        // addButton Tap
        input.addButtonTap
            .withLatestFrom(input.todoText.orEmpty)
            .bind(with: self) { owner, text in
                if !text.isEmpty {
                    let newData = Shopping(complete: false, todo: text, favorite: false)
                    owner.data.append(newData)
                    owner.items.accept(owner.data)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(items: items)
    }
    
    func updateTodo(_ index: Int, text: String) {
        data[index].todo = text
        items.accept(data)
    }
    
    func deleteTodo(_ index: Int) {
        data.remove(at: index)
        items.accept(data)
    }
    
    func completeButtonTap(_ index: Int) {
        data[index].complete.toggle()
        items.accept(data)
    }
    
    func favoriteButtonTap(_ index: Int) {
        data[index].favorite.toggle()
        items.accept(data)
    }
}

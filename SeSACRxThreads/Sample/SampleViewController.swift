//
//  SampleViewController.swift
//  SeSACRxThreads
//
//  Created by youngjoo on 3/30/24.
//

struct Sample {
    let name: String
    let age: Int
}

import UIKit
import RxSwift
import RxCocoa

final class SampleViewController: BaseViewController {
    
    private let mainView = SampleView()
    
    var items = BehaviorRelay(value: [
        Sample(name: "너굴맨", age: 5),
        Sample(name: "RTA", age: 10),
        Sample(name: "농심", age: 15)
    ])
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    func bind() {
        
        items.bind(to: mainView.tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { row, element, cell in
            cell.textLabel?.text = "name: \(element.name), age: \(element.age)"
        }.disposed(by: disposeBag)
        
        // zip 연습
        Observable.zip(
            mainView.tableView.rx.modelSelected(Sample.self),
            mainView.tableView.rx.itemSelected
        ).subscribe(with: self) { owner, value in
            var model = owner.items.value
            model.remove(at: value.1.row)
            owner.items.accept(model)
        }.disposed(by: disposeBag)
        
        mainView.addButton.rx.tap
            .bind(with: self) { owner, _ in
                let data = Sample(name: owner.mainView.textField.text ?? "", age: .random(in: 1...50))
                // value 프로퍼티를 통해 모델 배열로 변환
                var model = owner.items.value
                model.append(data)
                owner.items.accept(model)
            }.disposed(by: disposeBag)
    }
}

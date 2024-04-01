//
//  SearchViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2024/04/01.
//

import UIKit
import RxSwift
import RxCocoa

final class SearchViewController: BaseViewController {
    
    private var data = ["A", "B", "C", "AB", "D", "ABC", "BBB", "EC", "SA", "AAAB", "ED", "F", "G", "H"]
    
    private lazy var items = BehaviorSubject(value: data)
    
    private let mainView = SearchView()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationItem()
        bind()
    }
    
    private func configureNavigationItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "추가", style: .plain, target: self, action: #selector(plusButtonClicked))
    }
    
    private func bind() {
        items
            .bind(to: mainView.tableView.rx.items(cellIdentifier: SearchTableViewCell.identifier,
                                                  cellType: SearchTableViewCell.self)) { row, element, cell in
                cell.updateCell(element)
            }
        .disposed(by: disposeBag)

        // 터치한 셀의 item, model 값 확인
        // zip: 합친 Observable 모두 이벤트가 방출된 후 -> 함께 짝을 이루어 사용해야하는 경우에 사용
        // 지금같은 경우에 셀 터치 시 indexPath, model 이 같은 곳을 바라봐야 하기에 사용
        // combineLatest: 모든 이벤트가 방출이 된 후 -> 하나의 이벤트가 실행되더라도 다른 Observable 도 같이 방출되어야할 때 사용
        // 회원가입 같은 경우에 아이디 or 비밀번호 유효성 검사가 구분되어 있기에 따로 방출되더라도 같이 로그인 버튼을 변경하게끔 함
        Observable.zip(mainView.tableView.rx.itemSelected, mainView.tableView.rx.modelSelected(String.self))
            .bind(with: self) { owner, value in
                owner.data.remove(at: value.0.row)
                owner.items.onNext(owner.data)
            }
        .disposed(by: disposeBag)
        
        // 실시간 검색 Flow
        mainView.searchBar.rx.text
            .orEmpty
            .debounce(.seconds(1), scheduler: MainScheduler.instance) // 사용자가 마지막으로 입력한 값을 인식하고 1초 뒤에 구독
            .distinctUntilChanged() // 마지막으로 입력한 값과 같은지 판별 -> 같으면 구독 안해버림
            .subscribe(with: self) { owner, text in
                // SearchBarText 가 비어있는 경우를 대응
                let data = text.isEmpty ? owner.data : owner.data.filter { $0.contains(text) }
                owner.items.onNext(data)
            }
        .disposed(by: disposeBag)
        
        // 카보드 검색버튼 Flow
        mainView.searchBar.rx.searchButtonClicked // 클릭 이벤트를 방출했을 때
            .withLatestFrom(mainView.searchBar.rx.text.orEmpty) // 마지막으로 사용한 SearchText 값을 갖고 방출
            .distinctUntilChanged()
            .subscribe(with: self) { owner, text in
                let data = text.isEmpty ? owner.data : owner.data.filter { $0.contains(text) }
                owner.items.onNext(data)
            }
        .disposed(by: disposeBag)
    }
    
    @objc func plusButtonClicked() {
        let sample = ["A", "B", "C", "D", "E"]
        data.append(sample.randomElement()!)
        
        items.onNext(data)
    }
    
}

//
//  RxDataSources.swift
//  SeSACRxThreads
//
//  Created by youngjoo on 4/3/24.
//

// MARK: - RxDataSources
//import UIKit
//import RxSwift
//import RxCocoa
//import RxDataSources
//
//final class ShoppingViewController: BaseViewController {
//
//    // 2. 섹션을 기준으로 하기에 배열로 만들어진 data 타입 생성
//    private var data = [
//        ShoppingData(items: [
//        Shopping(complete: false, todo: "할 일을 입력해보세요!", favorite: false)
//        ])
//    ]
//
//    private lazy var items = BehaviorSubject(value: data)
//    private let mainView = ShoppingView()
//
//    override func loadView() {
//        view = mainView
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        configureNavigationItem()
//        bind()
//    }
//
//    private func configureNavigationItem() {
//        navigationItem.titleView = mainView.searchBar
//    }
//
//    private func bind() {
//        mainView.addButton.rx.tap
//            .withLatestFrom(mainView.textField.rx.text.orEmpty)
//            .bind(with: self) { owner, text in
//                if !text.isEmpty {
//                    let newData = Shopping(complete: false, todo: text, favorite: false)
//                    // 여기서 first 프로퍼티는 get-only,,
//                    owner.data[0].items.append(newData)
//                    owner.items.onNext(owner.data)
//                }
//            }
//            .disposed(by: disposeBag)
//
//        // 3. 데이터 소스 생성
//        let dataSource = RxTableViewSectionedReloadDataSource<ShoppingData> { dataSource, tableView, indexPath, item in
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: ShoppingTableViewCell.identifier, for: indexPath) as? ShoppingTableViewCell else { return UITableViewCell() }
//
//            cell.updateCell(item)
//
//            return cell
//        }
//
//        // 4. 편집 설정 여부까지 해야 구독이 가능합니다,,,,,,,,,,,,,,,,,,,,
//        dataSource.canEditRowAtIndexPath = { _, _ in
//            return true
//        }
//
//        // 5. 구독
//        items
//            .bind(to: mainView.tableView.rx.items(dataSource: dataSource))
//            .disposed(by: disposeBag)
//
//        // 6. itemDeleted
//        mainView.tableView.rx.itemDeleted
//            .bind(with: self) { owner, indexPath in
//                owner.data[0].items.remove(at: indexPath.row)
//                owner.items.onNext(owner.data)
//            }
//        .disposed(by: disposeBag)
//
//    }
//
//
//}

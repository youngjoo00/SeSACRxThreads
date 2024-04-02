//
//  ShoppingViewController.swift
//  SeSACRxThreads
//
//  Created by youngjoo on 4/2/24.
//

import UIKit
import RxSwift
import RxCocoa

final class ShoppingViewController: BaseViewController {
    
    private var data = [
        Shopping(complete: false, todo: "할 일을 추가해보세요", favorite: false)
    ]
    
    private lazy var items = BehaviorSubject(value: data)
    private let mainView = ShoppingView()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.tableView.delegate = self
        configureNavigationItem()
        bind()
    }
    
    private func configureNavigationItem() {
        navigationItem.titleView = mainView.searchBar
    }
    
    // MVVM 감이 안잡히네요,,
    private func bind() {
        
        // addButton Tap
        mainView.addButton.rx.tap
            .withLatestFrom(mainView.textField.rx.text.orEmpty)
            .bind(with: self) { owner, text in
                if !text.isEmpty {
                    let newData = Shopping(complete: false, todo: text, favorite: false)
                    owner.data.append(newData)
                    owner.items.onNext(owner.data)
                }
            }
            .disposed(by: disposeBag)
        
        // TableView.dequeReuseable
        items
            .bind(to: mainView.tableView.rx.items(cellIdentifier: ShoppingTableViewCell.identifier,
                                                  cellType: ShoppingTableViewCell.self)) { row, element, cell in
                cell.configureCell(element)
                
                cell.completeButton.rx.tap
                    .map { element.complete }
                    .subscribe(with: self) { owner, value in
                        print(value)
                        owner.data[row].complete.toggle()
                        owner.items.onNext(owner.data)
                    }
                    .disposed(by: cell.disposeBag)
                
                cell.favoriteButton.rx.tap
                    .map { element.favorite }
                    .subscribe(with: self) { owner, value in
                        owner.data[row].favorite.toggle()
                        owner.items.onNext(owner.data)
                    }
                    .disposed(by: cell.disposeBag)
            }
        .disposed(by: disposeBag)
        
        // RealTime Search
        mainView.searchBar.rx.text
            .orEmpty
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(with: self) { owner, text in
                let filterData = text.isEmpty ? owner.data : owner.data.filter { $0.todo.contains(text) }
                owner.items.onNext(filterData)
            }
            .disposed(by: disposeBag)
        
        // Cell Select
        Observable.zip(mainView.tableView.rx.itemSelected, mainView.tableView.rx.modelSelected(Shopping.self))
            .bind(with: self) { owner, value in
                let vc = DetailShoppingViewController()
                vc.todo = value.1.todo
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
}


// MARK: - TableView
extension ShoppingViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // Edit Flow
        let editAction = UIContextualAction(style: .normal, title: "수정") { [weak self] action, view, completion in
            guard let self else { return }
            
            
            let alert = UIAlertController(title: nil, message: "할 일을 수정합니다", preferredStyle: .alert)
            
            let update = UIAlertAction(title: "수정", style: .default) { action in
                let updatedNames = self.mainView.changeTextField.text
                self.data[indexPath.row].todo = updatedNames ?? ""
                self.items.onNext(self.data)
            }
            
            let cancel = UIAlertAction(title: "취소", style: .cancel)
            
            alert.addAction(update)
            alert.addAction(cancel)
            alert.addTextField { textField in
                self.mainView.changeTextField = textField
                self.mainView.changeTextField.text = self.data[indexPath.row].todo
                self.mainView.changeTextField.placeholder = "할 일을 작성하세요"
            }
            present(alert, animated: true)
            completion(true)
        }
        
        // Delete Flow
        let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { [weak self] action, view, completion in
            guard let self else { return }
            
            showAlert(title: "삭제", message: "할 일을 삭제하시겠습니까?", btnTitle: "삭제") {
                self.data.remove(at: indexPath.row)
                self.items.onNext(self.data)
            }
            completion(true)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
}

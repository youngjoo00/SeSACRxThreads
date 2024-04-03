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
    
    private let mainView = ShoppingView()
    private let viewModel = ShoppingViewModel()
    
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
    
    private func bind() {
        
        // TableView.dequeReuseable
        viewModel.items
            .bind(to: mainView.tableView.rx.items(cellIdentifier: ShoppingTableViewCell.identifier,
                                                  cellType: ShoppingTableViewCell.self)) { row, element, cell in
                cell.configureCell(element)
                
                cell.completeButton.rx.tap
                    .map { row }
                    .bind(with: self) { owner, index in
                        owner.viewModel.completeButtonTap(index)
                    }
                    .disposed(by: cell.disposeBag)
                
                cell.favoriteButton.rx.tap
                    .map { row }
                    .bind(with: self) { owner, index in
                        owner.viewModel.favoriteButtonTap(index)
                    }
                    .disposed(by: cell.disposeBag)
            }
        .disposed(by: disposeBag)
        
        mainView.addButton.rx.tap
            .bind(to: viewModel.inputAddButtonTap)
            .disposed(by: disposeBag)
        
        mainView.textField.rx.text
            .orEmpty
            .bind(to: viewModel.inputTextFieldText)
            .disposed(by: disposeBag)
        
        mainView.searchBar.rx.text
            .orEmpty
            .bind(to: viewModel.inputSearchText)
            .disposed(by: disposeBag)
        
        mainView.searchBar.rx.searchButtonClicked
            .bind(to: viewModel.inputSearchButtonTap)
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
        
        // Edit
        let editAction = UIContextualAction(style: .normal, title: "수정") { [weak self] action, view, completion in
            guard let self else { return }
            
            
            let alert = UIAlertController(title: nil, message: "할 일을 수정합니다", preferredStyle: .alert)
            
            let update = UIAlertAction(title: "수정", style: .default) { action in
                self.mainView.changeTextField.rx.text
                    .orEmpty
                    .bind(with: self) { owner, text in
                        owner.viewModel.updateTodo(indexPath.row, text: text)
                    }
                    .disposed(by: self.disposeBag)
            }
            
            let cancel = UIAlertAction(title: "취소", style: .cancel)
            
            alert.addAction(update)
            alert.addAction(cancel)
            alert.addTextField { textField in
                self.mainView.changeTextField = textField
                self.mainView.changeTextField.text = self.viewModel.data[indexPath.row].todo
                self.mainView.changeTextField.placeholder = "할 일을 작성하세요"
            }
            present(alert, animated: true)
            completion(true)
        }
        
        // Delete
        let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { [weak self] action, view, completion in
            guard let self else { return }
            
            showAlert(title: "삭제", message: "할 일을 삭제하시겠습니까?", btnTitle: "삭제") {
                self.viewModel.deleteTodo(indexPath.row)
            }
            completion(true)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
}

//
//  ShoppingView.swift
//  SeSACRxThreads
//
//  Created by youngjoo on 4/2/24.
//

import UIKit
import Then

final class ShoppingView: BaseView {
    
    let searchBar = UISearchBar().then {
        $0.placeholder = "할 일을 검색해보세요!"
        $0.searchBarStyle = .minimal
    }
    
    let textField = UITextField().then {
        $0.placeholder = "무엇을 구매하실 건가요?"
        $0.backgroundColor = .systemGray5
        $0.layer.cornerRadius = 8
    }
    
    let addButton = UIButton().then {
        var configuration = UIButton.Configuration.gray()
        configuration.title = "추가"
        configuration.baseForegroundColor = .black
        $0.configuration = configuration
    }
    
    let tableView: UITableView = {
       let view = UITableView()
        view.register(ShoppingTableViewCell.self, forCellReuseIdentifier: ShoppingTableViewCell.identifier)
        view.backgroundColor = .clear
        view.separatorStyle = .none
        view.rowHeight = 60
       return view
     }()
    
    var changeTextField = UITextField()
    
    override func configureHierarchy() {
        [
            textField,
            addButton,
            tableView,
        ].forEach { addSubview($0) }
    }
    
    override func configureLayout() {
        
        textField.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(20)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(60)
        }
    
        addButton.snp.makeConstraints { make in
            make.centerY.equalTo(textField)
            make.trailing.equalTo(textField).inset(10)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(20)
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        textField.addLeftPadding()
    }
}

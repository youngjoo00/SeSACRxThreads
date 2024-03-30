//
//  SampleView.swift
//  SeSACRxThreads
//
//  Created by youngjoo on 3/30/24.
//

import UIKit
import Then

final class SampleView: BaseView {
    
    let textField = SignTextField(placeholderText: "뭐든지 입력해보세요")
    
    let addButton = PointButton(title: "추가")
    
    let tableView = UITableView().then {
        $0.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        $0.backgroundColor = .clear
    }
    
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
            make.leading.equalToSuperview().inset(16)
            make.trailing.equalTo(addButton.snp.leading).offset(-16)
            make.height.equalTo(44)
        }
        
        addButton.snp.makeConstraints { make in
            make.top.equalTo(textField)
            make.trailing.equalToSuperview().inset(16)
            make.size.equalTo(44)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(20)
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        
    }
}

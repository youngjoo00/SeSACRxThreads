//
//  NicknameViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class NicknameViewController: BaseViewController {
    
    private let mainView = NicknameView()
    private let viewModel = NicknameViewModel()
        
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    private func bind() {
        mainView.nextButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.navigationController?.pushViewController(BirthdayViewController(), animated: true)
            }.disposed(by: disposeBag)
        
        mainView.nicknameTextField.rx.text
            .orEmpty
            .bind(to: viewModel.inputNickanme)
            .disposed(by: disposeBag)
        
        viewModel.outputValid
            .asDriver()
            .drive(with: self) { owner, value in
                owner.mainView.descriptionLabel.isHidden = value
                owner.mainView.descriptionLabel.text = value ? "" : "닉네임은 두 글자 이상입니다"
                owner.mainView.nextButton.isEnabled = value
                
                let color = value ? UIColor.systemPink : UIColor.lightGray
                owner.mainView.nextButton.backgroundColor = color
            }
            .disposed(by: disposeBag)
    }
    
}

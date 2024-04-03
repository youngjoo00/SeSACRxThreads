//
//  PasswordViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class PasswordViewController: BaseViewController {
   
    private let mainView = PasswordView()
    private let viewModel = PasswordViewModel()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
        bind()
    }

    private func bind() {
//        descriptionLabel ValidText
//        비번 8자 이상
//        조건 안맞으면, NextButton LightGray, descriptionLabel 로 상태를 알려줌
//        비번 조건 맞추면, nextButton Pick - 클릭가능 , descriotionLabel ishidden
        
        mainView.nextButton.rx.tap.bind(with: self) { owner, _ in
            owner.navigationController?.pushViewController(PhoneViewController(), animated: true)
        }.disposed(by: disposeBag)
        
        // validText 에서 값이 방출될 때 마다 descriptionLabel.rx.text 로 전달
        mainView.passwordTextField.rx.text
            .orEmpty
            .bind(to: viewModel.inputPassword)
            .disposed(by: disposeBag)
        
        viewModel.outputValid
            .asDriver()
            .drive(with: self) { owner, value in
                owner.mainView.nextButton.isEnabled = value
                owner.mainView.descriptionLabel.isHidden = value
                owner.mainView.descriptionLabel.text = value ? "" : "비밀번호는 최소 5자 이상입니다"
                let color: UIColor = value ? .systemPink : .lightGray
                owner.mainView.nextButton.backgroundColor = color
            }
            .disposed(by: disposeBag)
    }
}

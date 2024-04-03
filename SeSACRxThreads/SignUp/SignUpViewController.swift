//
//  SignUpViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SignUpViewController: BaseViewController {
    
    private let mainView = SignUpView()
    private let viewModel = SignUpViewModel()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    private func bind() {
        mainView.nextButton.rx.tap.bind(with: self) { owner, _ in
            owner.navigationController?.pushViewController(PasswordViewController(), animated: true)
        }.disposed(by: disposeBag)
        
        mainView.emailTextField.rx.text
            .orEmpty
            .bind(to: viewModel.inputEmail)
            .disposed(by: disposeBag)
        
        viewModel.outputValidText
            .asDriver(onErrorJustReturn: "")
            .drive(mainView.descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.outputValidButton
            .asDriver()
            .drive(with: self) { owner, value in
                owner.mainView.validationButton.setTitleColor(value ? .systemPink : .systemGray, for: .normal)
                owner.mainView.validationButton.isEnabled = value
            }
            .disposed(by: disposeBag)
        
        mainView.validationButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.showAlert(title: "성공!")
                owner.viewModel.inputValidButtonTap.onNext(())
            }.disposed(by: disposeBag)
        
        viewModel.outputValidNextButton
            .asDriver()
            .drive(with: self, onNext: { owner, value in
                owner.mainView.nextButton.backgroundColor = value ? .systemPink : .lightGray
                owner.mainView.nextButton.isEnabled = value
            })
            .disposed(by: disposeBag)
    }
}

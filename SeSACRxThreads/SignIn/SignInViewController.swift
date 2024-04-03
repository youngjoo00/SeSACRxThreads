//
//  SignInViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SignInViewController: BaseViewController {

    private let mainView = SignInView()
    private let viewModel = SignInViewModel()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }

    private func bind() {
        mainView.signUpButton.rx.tap.bind(with: self) { owner, _ in
            owner.navigationController?.pushViewController(SignUpViewController(), animated: true)
        }.disposed(by: disposeBag)
        
        mainView.emailTextField.rx.text
            .orEmpty
            .bind(to: viewModel.inputEmail)
            .disposed(by: disposeBag)
        
        mainView.passwordTextField.rx.text
            .orEmpty
            .bind(to: viewModel.inputPassword)
            .disposed(by: disposeBag)
        
        viewModel.outputEmailValid.bind(to: mainView.emailValidLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.outputPasswordValid.bind(to: mainView.passwordValidLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.outputSignInValid
            .asDriver()
            .drive(with: self) { owner, value in
                owner.mainView.signInButton.backgroundColor = value ? .systemPink : .lightGray
                owner.mainView.signInButton.isEnabled = value
            }
            .disposed(by: disposeBag)
        
        mainView.signInButton.rx.tap.bind(with: self) { owner, _ in
            owner.showAlert(title: "로그인 성공!")
        }.disposed(by: disposeBag)
    }
    
}

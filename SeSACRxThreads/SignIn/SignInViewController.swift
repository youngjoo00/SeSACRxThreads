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
        
        let input = SignInViewModel.Input(email: mainView.emailTextField.rx.text,
                                          password: mainView.passwordTextField.rx.text,
                                          signUpButtonTap: mainView.signUpButton.rx.tap,
                                          signInButtonTap: mainView.signInButton.rx.tap)
        
        let output = viewModel.transform(input: input)
    
        output.enabled
            .drive(mainView.signInButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.enabled
            .map { $0 ? UIColor.systemPink : UIColor.lightGray }
            .drive(mainView.signInButton.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        output.signUpButtonTap
            .bind(with: self) { owner, _ in
                owner.navigationController?.pushViewController(SignUpViewController(), animated: true)
            }
            .disposed(by: disposeBag)
        
        output.signInButtonTap
            .bind(with: self) { owner, _ in
                owner.showAlert(title: "로그인 성공!")
            }
            .disposed(by: disposeBag)
    }
    
}

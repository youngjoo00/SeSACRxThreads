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
    
    private let minimalPasswordLength = 5
    
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
        
        let emailValid = mainView.emailTextField.rx.text
            .orEmpty
            .map { self.validateEmail($0) }
        
        let passwordValid = mainView.passwordTextField.rx.text
            .orEmpty
            .map { $0.count >= self.minimalPasswordLength }
        
        let everyThingValid = Observable.combineLatest(emailValid, passwordValid) { $0 && $1 }
        
        emailValid.bind(to: mainView.emailValidLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        passwordValid.bind(to: mainView.passwordValidLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        everyThingValid.bind(to: mainView.signInButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        mainView.signInButton.rx.tap.bind(with: self) { owner, _ in
            owner.showAlert(title: "로그인 성공!")
        }.disposed(by: disposeBag)
    }
    
}

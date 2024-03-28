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

    private let validText = Observable.just("유효한 이메일 형식이 아닙니다")
    private let validButton = BehaviorSubject(value: false)
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
        
        // 초기값
        validText.bind(to: mainView.descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        let validTextField = mainView.emailTextField.rx.text
            .orEmpty
            .map { [weak self] in
                guard let self else { return false }
                let isValid = self.validateEmail($0)
                if isValid {
                    return true
                } else {
                    // 이메일이 유효한 형식이 아니라면 onNext 로 false 를 보내주기
                    validButton.onNext(false)
                    return false
                }
            }
        
        validTextField.bind(to: mainView.descriptionLabel.rx.isHidden, mainView.validationButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        validTextField
            .map { $0 ? UIColor.systemPink : UIColor.lightGray }
            .bind(with: self) { owner, color in
                // 왜 rx.isHidden 이런건 있지만 rx.setTitleColor 는 없을까요,,
                owner.mainView.validationButton.setTitleColor(color, for: .normal)
            }.disposed(by: disposeBag)
        
        mainView.validationButton.rx.tap.bind(with: self) { owner, _ in
            owner.showAlert(title: "성공!")
            owner.validButton.onNext(true)
        }.disposed(by: disposeBag)
        
        validButton
            .map { $0 ? UIColor.systemPink : UIColor.lightGray }
            .bind(to: mainView.nextButton.rx.backgroundColor)
            .disposed(by: disposeBag)
        

    }
}

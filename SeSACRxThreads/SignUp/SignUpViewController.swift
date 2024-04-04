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
        
        let input = SignUpViewModel.Input(email: mainView.emailTextField.rx.text,
                                          validationButtonTap: mainView.validationButton.rx.tap,
                                          nextButtonTap: mainView.nextButton.rx.tap, 
                                          nextButtonEnabled: Observable.just(())
        )
        
        let output = viewModel.transform(input: input)
        
        output.valid
            .map { $0 ? UIColor.systemPink : UIColor.systemGray }
            .drive(mainView.validationButton.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        output.valid
            .drive(mainView.validationButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.nextButtonTap
            .bind(with: self) { owner, _ in
                owner.navigationController?.pushViewController(PasswordViewController(), animated: true)
            }
            .disposed(by: disposeBag)
        
        output.description
            .drive(mainView.descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.validationButtonTap
            .bind(with: self) { owner, _ in
                owner.showAlert(title: "성공!")
            }
            .disposed(by: disposeBag)
        
//        viewModel.outputValidNextButton
//            .asDriver()
//            .drive(with: self, onNext: { owner, value in
//                owner.mainView.nextButton.backgroundColor = value ? .systemPink : .lightGray
//                owner.mainView.nextButton.isEnabled = value
//            })
//            .disposed(by: disposeBag)
    }
}

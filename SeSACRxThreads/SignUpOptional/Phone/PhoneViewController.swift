//
//  PhoneViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//
 
import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class PhoneViewController: BaseViewController {
   
    private let mainView = PhoneView()
    private let viewModel = PhoneViewModel()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bind()
    }

    private func bind() {
        
        let input = PhoneViewModel.Input(viewDidLoad: Observable.just(()),
                                         phone: mainView.phoneTextField.rx.text,
                                         nextButtonTap: mainView.nextButton.rx.tap)
        
        let output = viewModel.transform(input: input)
        
        output.initialPhoneNumber
            .drive(mainView.phoneTextField.rx.text)
            .disposed(by: disposeBag)
        
        output.description
            .drive(mainView.descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        // nextButton
        output.valid
            .drive(mainView.nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.valid
            .map { $0 ? UIColor.systemPink : UIColor.lightGray }
            .drive(mainView.nextButton.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        output.nextButtonTap
            .bind(with: self) { owner, _ in
                owner.navigationController?.pushViewController(NicknameViewController(), animated: true)
            }
            .disposed(by: disposeBag)
    }
}

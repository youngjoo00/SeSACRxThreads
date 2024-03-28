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
   
    private let validText = Observable.just("8자 이상 입력해주세요")
    
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
        validText.bind(to: mainView.descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        let valid = mainView.passwordTextField.rx.text
            .orEmpty
            .map { $0.count >= 8 }
        
        valid.bind(to: mainView.nextButton.rx.isEnabled, mainView.descriptionLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        valid.bind(with: self) { owner, value in
            let color: UIColor = value ? .systemPink : .lightGray
            owner.mainView.nextButton.backgroundColor = color
        }.disposed(by: disposeBag)
    }
}

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
    
    private let validText = Observable.just("닉네임은 두 글자 이상부터 가능합니다.")
    
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
        
        validText.bind(to: mainView.descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        let valid = mainView.nicknameTextField.rx.text
            .orEmpty
            .map { $0.count >= 2 }
        
        valid.bind(to: mainView.descriptionLabel.rx.isHidden, mainView.nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        valid
            .map{ $0 ? UIColor.blue : UIColor.lightGray }
            .bind(to: mainView.nextButton.rx.backgroundColor)
            .disposed(by: disposeBag)
    }
    
}

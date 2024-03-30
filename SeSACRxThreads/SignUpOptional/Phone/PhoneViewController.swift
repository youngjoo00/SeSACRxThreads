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
    
    private let validText = Observable.just("유효한 휴대폰 번호 형식이 아닙니다.")
    private let initialText = Observable.just("010")
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bind()
    }

    //    첫 화면 진입시 010
    //    TF 에는 숫자만, 10자 이상
    //    조건이 안되면 PasswordVC 로직처럼 처리
    // 010 이 아니면 안됨, 10~11 자리까지만 가능함
    private func bind() {
        mainView.nextButton.rx.tap.bind(with: self) { owner, _ in
            owner.navigationController?.pushViewController(NicknameViewController(), animated: true)
        }.disposed(by: disposeBag)
        
        validText.bind(to: mainView.descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        initialText.bind(to: mainView.phoneTextField.rx.text)
            .disposed(by: disposeBag)
        
        let valid = mainView.phoneTextField.rx.text
            .orEmpty
            .map {
                let isValid = $0.count >= 10 && $0.count <= 11
                let isInteger = Int($0) != nil
                let is010Number = $0.hasPrefix("010")
                return isValid && isInteger && is010Number
            }
        
        valid.bind(to: mainView.descriptionLabel.rx.isHidden, mainView.nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        valid.bind(with: self) { owner, value in
            let color: UIColor = value ? .systemPink : .lightGray
            owner.mainView.nextButton.backgroundColor = color
        }.disposed(by: disposeBag)
        
    }
}

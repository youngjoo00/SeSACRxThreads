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

    //    첫 화면 진입시 010
    //    TF 에는 숫자만, 10자 이상
    //    조건이 안되면 PasswordVC 로직처럼 처리
    // 010 이 아니면 안됨, 10~11 자리까지만 가능함
    private func bind() {
        mainView.nextButton.rx.tap.bind(with: self) { owner, _ in
            owner.navigationController?.pushViewController(NicknameViewController(), animated: true)
        }.disposed(by: disposeBag)
        
        viewModel.outputInitialText
            .asDriver()
            .drive(mainView.phoneTextField.rx.text)
            .disposed(by: disposeBag)
        
        mainView.phoneTextField.rx.text
            .orEmpty
            .bind(to: viewModel.inputPhone)
            .disposed(by: disposeBag)
        
        viewModel.outputValid
            .asDriver()
            .drive(with: self) { owner, value in
                owner.mainView.descriptionLabel.isHidden = value
                owner.mainView.descriptionLabel.text = value ? "" : "유효한 휴대폰 번호 형식이 아닙니다"
                
                owner.mainView.nextButton.isEnabled = value
                
                let color: UIColor = value ? .systemPink : .lightGray
                owner.mainView.nextButton.backgroundColor = color
            }
            .disposed(by: disposeBag)
        
    }
}

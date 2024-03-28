//
//  SignInView.swift
//  SeSACRxThreads
//
//  Created by youngjoo on 3/29/24.
//

import UIKit
import Then
import RxSwift

final class SignInView: BaseView {
    
    let emailTextField = SignTextField(placeholderText: "이메일을 입력해주세요")
    let emailValidLabel = UILabel().then {
        $0.text = "유효한 이메일 형식이 아닙니다"
    }

    let passwordTextField = SignTextField(placeholderText: "비밀번호를 입력해주세요")
    let passwordValidLabel = UILabel().then {
        $0.text = "비밀번호는 최소 5자리 이상입니다"
    }

    let signInButton = PointButton(title: "로그인")
    let signUpButton = UIButton()
    
    override func configureHierarchy() {
        [
            emailTextField,
            emailValidLabel,
            passwordTextField,
            passwordValidLabel,
            signInButton,
            signUpButton,
        ].forEach { addSubview($0) }
    }

    override func configureLayout() {
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
        }
        
        emailValidLabel.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(5)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(emailTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
        }
        
        passwordValidLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(5)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
        }
        
        signInButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(signInButton.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
        }

    }
    
    override func configureView() {
        signUpButton.setTitle("회원이 아니십니까?", for: .normal)
        signUpButton.setTitleColor(Color.black, for: .normal)
    }
}

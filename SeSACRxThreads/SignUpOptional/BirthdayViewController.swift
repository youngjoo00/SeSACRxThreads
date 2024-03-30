//
//  BirthdayViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//
 
import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class BirthdayViewController: BaseViewController {
    
    private let mainView = BirthdayView()
    private let viewModel = BirthdayViewModel()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bind()
    }
    
    private func bind() {
        mainView.nextButton.rx.tap.bind(with: self) { owner, _ in
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            let sceneDelegate = windowScene?.delegate as? SceneDelegate

            let tabBar = UITabBarController()

            let firstTab = SampleViewController()
            let firstTabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
            firstTab.tabBarItem = firstTabBarItem
            
            tabBar.viewControllers = [firstTab]
            
            sceneDelegate?.window?.rootViewController = tabBar
            sceneDelegate?.window?.makeKeyAndVisible()
        }.disposed(by: disposeBag)
        
        viewModel.year
            .map { "\($0)년" }
            .bind(to: mainView.yearLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.month
            .map { "\($0)월" }
            .bind(to: mainView.monthLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.day
            .map { "\($0)일" }
            .bind(to: mainView.dayLabel.rx.text)
            .disposed(by: disposeBag)
        
        // 만 17세 이상인지 아닌지 확인
        viewModel.isInfo.bind(with: self) { owner, bool in
            if bool {
                owner.mainView.infoLabel.text = "가입 가능한 나이입니다."
                owner.mainView.infoLabel.textColor = .blue
                owner.mainView.nextButton.backgroundColor = .blue
            } else {
                owner.mainView.infoLabel.text = "만 17세 이상만 가입 가능합니다."
                owner.mainView.infoLabel.textColor = .red
                owner.mainView.nextButton.backgroundColor = .lightGray
            }
            owner.mainView.nextButton.isEnabled = bool
        }.disposed(by: disposeBag)
            
        // 위에서 구독을 먼저 진행하고 난 뒤, date 값 보내면 PublishRelay 사용 가능
        mainView.birthDayPicker.rx.date
            .bind(to: viewModel.birthday)
            .disposed(by: disposeBag)
    }

}

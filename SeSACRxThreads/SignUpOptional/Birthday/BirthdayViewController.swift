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
            
            let secondTab = ShoppingViewController()
            let secondTabBarItem = UITabBarItem(title: "Shop", image: UIImage(systemName: "house"), tag: 1)
            secondTab.tabBarItem = secondTabBarItem
            
            tabBar.viewControllers = [firstTab, secondTab]
            
            sceneDelegate?.window?.rootViewController = tabBar
            sceneDelegate?.window?.makeKeyAndVisible()
        }.disposed(by: disposeBag)
        
        viewModel.outputYear
            .asDriver(onErrorJustReturn: "0000년")
            .drive(mainView.yearLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.outputMonth
            .asDriver(onErrorJustReturn: "00월")
            .drive(mainView.monthLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.outputDay
            .asDriver(onErrorJustReturn: "00일")
            .drive(mainView.dayLabel.rx.text)
            .disposed(by: disposeBag)
        
        // 만 17세 이상인지 아닌지 확인
        viewModel.outputIsInfo.bind(with: self) { owner, bool in
            if bool {
                owner.mainView.infoLabel.text = "가입 가능한 나이입니다."
                owner.mainView.infoLabel.textColor = .systemPink
                owner.mainView.nextButton.backgroundColor = .systemPink
            } else {
                owner.mainView.infoLabel.text = "만 17세 이상만 가입 가능합니다."
                owner.mainView.infoLabel.textColor = .red
                owner.mainView.nextButton.backgroundColor = .lightGray
            }
            owner.mainView.nextButton.isEnabled = bool
        }.disposed(by: disposeBag)
            
        // 위에서 구독을 먼저 진행하고 난 뒤, date 값 보내면 PublishRelay 사용 가능
        mainView.birthDayPicker.rx.date
            .bind(to: viewModel.inputBirthday)
            .disposed(by: disposeBag)
    }

}

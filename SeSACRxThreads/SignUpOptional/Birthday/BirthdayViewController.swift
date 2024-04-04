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
        
        let input = BirthdayViewModel.Input(birthday: mainView.birthDayPicker.rx.date)
        
        let output = viewModel.transform(input: input)
        
        output.year
            .drive(mainView.yearLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.month
            .drive(mainView.monthLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.day
            .drive(mainView.dayLabel.rx.text)
            .disposed(by: disposeBag)

        output.valid
            .map { $0 ? UIColor.systemPink : UIColor.lightGray }
            .drive(mainView.nextButton.rx.backgroundColor,
                   mainView.descriptionLabel.rx.textColor)
            .disposed(by: disposeBag)
        
        output.valid
            .drive(mainView.nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.description
            .drive(mainView.descriptionLabel.rx.text)
            .disposed(by: disposeBag)
            
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
    }

}

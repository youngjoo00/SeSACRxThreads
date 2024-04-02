//
//  DetailShoppingViewController.swift
//  SeSACRxThreads
//
//  Created by youngjoo on 4/3/24.
//

import UIKit
import RxSwift
import RxCocoa

final class DetailShoppingViewController: BaseViewController {
    
    var todo: String = ""
    
    private let mainView = DetailShoppingView()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationItem()
        mainView.label.text = todo
    }
    
    private func configureNavigationItem() {
        navigationItem.title = "DetailShopping"
    }
    
}

//
//  BaseViewModel.swift
//  SeSACRxThreads
//
//  Created by youngjoo on 3/30/24.
//

import Foundation
import RxSwift

protocol ViewModel: AnyObject { }

class BaseViewModel: ViewModel {
    
    let disposeBag = DisposeBag()
}

//
//  BoxOfficeViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2024/04/05.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class BoxOfficeViewController: UIViewController {
    
    let tableView = UITableView()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout() )
    let searchBar = UISearchBar()
    
    let disposeBag = DisposeBag()
   
    let viewModel = BoxOfficeViewModel()
    
    func bind() {
        
        // 어떻게 선택한 값을 뷰모델로 보내지? 에 대한 결과
        let recentText = PublishSubject<String>()
         
        let input = BoxOfficeViewModel.Input(searchButtonTap: searchBar.rx.searchButtonClicked,
                                             searchText: searchBar.rx.text, 
                                             recentText: recentText)
        
        let output = viewModel.transform(input: input)
        
        output.movieList
            .bind(
                to: tableView.rx.items(
                    cellIdentifier: SearchTableViewCell.identifier,
                    cellType: SearchTableViewCell.self)
            ) { (row, element, cell) in
                cell.updateCell(element.movieNm)
            }
            .disposed(by: disposeBag)

        output.recentList
            .bind(
                to: collectionView.rx.items(
                    cellIdentifier: MovieCollectionViewCell.identifier,
                    cellType: MovieCollectionViewCell.self)
            ) { (row, element, cell) in
                cell.label.text = "\(element) @ row \(row) \(element)"
            }
            .disposed(by: disposeBag)
         
        Observable.zip(
            tableView.rx.modelSelected(DailyBoxOfficeList.self),
            tableView.rx.itemSelected
        )
            .map { $0.0 }
            .subscribe(with: self) { owner, value in
                print(value.movieNm, "Selected")
                // 이벤트를 보내는 observable 역할
                recentText.onNext(value.movieNm)
            }
            .disposed(by: disposeBag)
         
    }
    
    override func viewDidLoad() {
        super.viewDidLoad() 
        configure()
        bind()
    }

    
    func configure() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(collectionView)
        view.addSubview(searchBar)
        
        navigationItem.titleView = searchBar
        
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
        tableView.backgroundColor = .clear
        tableView.rowHeight = 100
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        collectionView.backgroundColor = .clear
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(50)
        }
    }
     
    static func layout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 40)
        layout.scrollDirection = .horizontal
        return layout
    }
   
}

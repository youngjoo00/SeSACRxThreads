//
//  SearchTableViewCell.swift
//  SeSACRxThreads
//
//  Created by jack on 2024/04/01.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SearchTableViewCell: BaseTableViewCell {
    
    private let appNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private let appIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemMint
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    private let downloadButton: UIButton = {
        let button = UIButton()
        button.setTitle("받기", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.isUserInteractionEnabled = true
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 16
        return button
    }()
     
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        contentView.addSubview(appNameLabel)
        contentView.addSubview(appIconImageView)
        contentView.addSubview(downloadButton)
        
        appIconImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(20)
            $0.size.equalTo(60)
        }
        
        appNameLabel.snp.makeConstraints {
            $0.centerY.equalTo(appIconImageView)
            $0.leading.equalTo(appIconImageView.snp.trailing).offset(8)
            $0.trailing.equalTo(downloadButton.snp.leading).offset(-8)
        }
        
        downloadButton.snp.makeConstraints {
            $0.centerY.equalTo(appIconImageView)
            $0.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(32)
            $0.width.equalTo(72)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
}

extension SearchTableViewCell {
    
    // 테이블뷰의 재사용 메커니즘으로 인해 재사용 큐에 데이터는 잘 들어가지만,
    // 셀에 구독 정보가 남아있어서, 구독 정보를 해제하지 않는 한 중복되어 구독이 쌓이게 되는 문제가 발생한다.
    // 이를 해결하기 위해 재사용 되기 직전 호출되는 prepareForReuse 메서드에서 구독를 해제해주자.
    func updateCell(_ data: String) {
        appNameLabel.text = data
        
        downloadButton.rx.tap
            .map { data }
            .subscribe(with: self) { owner, data in
                print("\(data) tapped!")
            }
        .disposed(by: disposeBag)
    }
}

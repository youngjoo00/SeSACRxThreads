//
//  ShoppingTableViewCell.swift
//  SeSACRxThreads
//
//  Created by youngjoo on 4/2/24.
//

import UIKit
import Then
import RxSwift
import RxCocoa

final class ShoppingTableViewCell: BaseTableViewCell {
        
    let completeButton = UIButton().then {
        var configuration = UIButton.Configuration.gray()
        configuration.image = UIImage(systemName: "checkmark.square")
        configuration.baseForegroundColor = .black
        configuration.baseBackgroundColor = .systemGray5
        $0.configuration = configuration
    }
    
    private let todoLabel = UILabel()
    
    let favoriteButton = UIButton().then {
        $0.setImage(UIImage(systemName: "star"), for: .normal)
        $0.tintColor = .black
    }
    
    override func configureHierarchy() {
        [
            completeButton,
            todoLabel,
            favoriteButton,
        ].forEach { contentView.addSubview($0) }
    }
    
    override func configureLayout() {
        completeButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.size.equalTo(30)
        }
        
        todoLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(completeButton.snp.trailing).offset(20)
        }
        
        favoriteButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-16)
        }
    }
    
    override func configureView() {
        contentView.layer.cornerRadius = 8
        contentView.backgroundColor = .systemGray5
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 16, bottom: 5, right: 16))
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
}

extension ShoppingTableViewCell {
    
    func configureCell(_ data: Shopping) {
        todoLabel.text = data.todo
        updateCompleteButton(data.complete)
        updateFavoriteButton(data.favorite)
    }
    
    private func updateCompleteButton(_ complete: Bool) {
        if complete {
            var configuration = UIButton.Configuration.gray()
            configuration.image = UIImage(systemName: "checkmark.square.fill")
            configuration.baseForegroundColor = .black
            configuration.baseBackgroundColor = .systemGray5
            completeButton.configuration = configuration
        } else {
            var configuration = UIButton.Configuration.gray()
            configuration.image = UIImage(systemName: "checkmark.square")
            configuration.baseForegroundColor = .black
            configuration.baseBackgroundColor = .systemGray5
            completeButton.configuration = configuration
        }
    }
    
    private func updateFavoriteButton(_ favortie: Bool) {
        if favortie {
            favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        } else {
            favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
        }
    }
}

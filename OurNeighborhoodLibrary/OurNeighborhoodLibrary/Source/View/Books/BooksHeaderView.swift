//
//  BooksHeaderView.swift
//  OurNeighborhoodLibrary
//
//  Created by brad on 2023/04/20.
//

import UIKit
import SnapKit
import Then

final class BooksHeaderView: UICollectionReusableView {
    
    static let id = Setup.id
    
    private lazy var titleLabel = UILabel().then { label in
        label.font = .systemFont(ofSize: Setup.titleFontSize, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.addBorder([.top], color: .secondarySystemFill, width: Setup.borderWidth)

        setupView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with data: String) {
        titleLabel.text = data
    }
    
}

private extension BooksHeaderView {
    
    enum Setup {
        static let id: String = "BooksHeaderView"
        static let titleFontSize: CGFloat = 20
        static let borderWidth: Double = 1.0
    }
    
    func setupView() {
        self.addSubview(titleLabel)
    }
    
    func setupLayout() {
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalTo(self)
        }
    }
    
}

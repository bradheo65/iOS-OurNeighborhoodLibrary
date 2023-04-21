//
//  HotBookListCell.swift
//  OurNeighborhoodLibrary
//
//  Created by brad on 2023/04/21.
//

import UIKit
import SnapKit
import Then

final class HotBookListCell: UICollectionViewListCell {
    
    static let id = "HotBookListCell"
    
    private lazy var bookImageView = UIImageView().then { imageView in
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var verticalStackView = UIStackView().then { stackView in
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var bookNameLabel = UILabel().then { label in
        label.font = .preferredFont(forTextStyle: .headline)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var authorsLabel = UILabel().then { label in
        label.font = .preferredFont(forTextStyle: .footnote)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
    }

    private lazy var publisherAndYearLabel = UILabel().then { label in
        label.font = .preferredFont(forTextStyle: .footnote)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = .secondarySystemBackground
        
        setupView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        bookImageView.image = nil
        bookNameLabel.text = ""
        authorsLabel.text = ""
        publisherAndYearLabel.text = ""
    }
    
    func configure(with data: HotBookDocElement) {
        URLSessionManager.shared.getImage(urlString: data.doc.bookImageURL) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.bookImageView.image = UIImage(data: data)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        bookNameLabel.text = data.doc.bookname
        authorsLabel.text = "저자: \(data.doc.authors)"
        publisherAndYearLabel.text = "출판: \(data.doc.publisher) | \(data.doc.publicationYear)"
    }
    
}

private extension HotBookListCell {
    
    func setupView() {
        [bookImageView, verticalStackView].forEach { view in
            self.contentView.addSubview(view)
        }
        
        [bookNameLabel, authorsLabel, publisherAndYearLabel].forEach { view in
            verticalStackView.addArrangedSubview(view)
        }
    }
    
    func setupLayout() {
        bookImageView.snp.makeConstraints { make in
            make.leading.equalTo(self.contentView)
            make.width.height.equalTo(self.contentView.snp.width).multipliedBy(0.2)
        }
        
        verticalStackView.snp.makeConstraints { make in
            make.bottom.top.trailing.equalTo(self.contentView)
            make.leading.equalTo(bookImageView.snp.trailing).offset(10)
        }
    }
    
}

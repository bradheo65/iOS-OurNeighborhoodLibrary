//
//  PopularBookListCell.swift
//  OurNeighborhoodLibrary
//
//  Created by brad on 2023/04/20.
//

import UIKit
import SnapKit
import Then

final class PopularBookListCell: UICollectionViewListCell {
    
    static let id = Setup.id
    
    private lazy var bookImageView = UIImageView().then { imageView in
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Setup.cornerRadius
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
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
    
    func configure(with data: PopularBookDocDoc) {
        URLSessionManager.shared.getImage(urlString: data.bookImageURL) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.bookImageView.image = UIImage(data: data)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}

private extension PopularBookListCell {
    
    enum Setup {
        static let id: String = "PopularBookListCell"
        static let cornerRadius: CGFloat = 16
    }
    
    func setupView() {
        self.contentView.addSubview(bookImageView)
    }
    
    func setupLayout() {
        bookImageView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalTo(self.contentView)
        }
    }
    
}

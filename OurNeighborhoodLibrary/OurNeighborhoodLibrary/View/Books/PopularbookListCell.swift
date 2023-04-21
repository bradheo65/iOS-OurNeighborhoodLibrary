//
//  PopularbookListCell.swift
//  OurNeighborhoodLibrary
//
//  Created by brad on 2023/04/20.
//

import UIKit
import SnapKit
import Then

final class PopularbookListCell: UICollectionViewListCell {
    
    static let id = "PopularbookListCell"
    
    private lazy var bookImageView = UIImageView().then { imageView in
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
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
    
    func configure(with data: DocDoc) {
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

private extension PopularbookListCell {
    
    func setupView() {
        self.contentView.addSubview(bookImageView)
    }
    
    func setupLayout() {
        bookImageView.snp.makeConstraints { make in
            make.left.right.bottom.top.equalTo(self.contentView)
            make.height.equalTo(self.contentView.snp.width).multipliedBy(0.4).priority(750)
        }
    }
    
}

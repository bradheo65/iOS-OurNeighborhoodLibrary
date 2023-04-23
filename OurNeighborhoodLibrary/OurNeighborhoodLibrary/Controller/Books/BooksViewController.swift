//
//  BooksViewController.swift
//  OurNeighborhoodLibrary
//
//  Created by brad on 2023/04/19.
//

import UIKit
import SnapKit
import Then

final class BooksViewController: UIViewController {
    
    enum Section: String, CaseIterable {
        case PopularBookList = "인기 도서"
        case HotBookList = "대출 급상승 도서"
    }
    
    private lazy var collectionView = UICollectionView(
        frame: .zero, collectionViewLayout: setupCompositionalLayout()
    ).then { collectionView in
        collectionView.register(
            BooksHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: BooksHeaderView.id
        )
        collectionView.register(
            HotBookListCell.self,
            forCellWithReuseIdentifier: HotBookListCell.id
        )
        collectionView.register(
            PopularBookListCell.self,
            forCellWithReuseIdentifier: PopularBookListCell.id
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var diffableDataSource: UICollectionViewDiffableDataSource<Section, AnyHashable> = .init(collectionView: self.collectionView) { collectionView, indexPath, object in
        if let object = object as? PopularBookDocElement {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PopularBookListCell.id,
                for: indexPath
            ) as? PopularBookListCell else {
                return nil
            }
            cell.configure(
                with: object.doc
            )
            return cell
        }
        if let object = object as? HotBookDocElement {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: HotBookListCell.id,
                for: indexPath
            ) as? HotBookListCell else {
                return nil
            }
            cell.configure(with: object)
            return cell
        }
        
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.backgroundColor = .secondarySystemBackground
        
        setupView()
        setupLayout()
        setupNavigationBar()
        setupHeaderView()
        
        fetchBooks()
    }
    
}

private extension BooksViewController {
    
    func setupView() {
        self.view.addSubview(collectionView)
    }
    
    func setupLayout() {
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalTo(self.view)
        }
    }
    
    func setupNavigationBar() {
        navigationItem.title = "Books"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setupCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { sectionNumber, _ in
            if sectionNumber == 0 {
                return BooksViewController.PopularBookListLayout()
            } else if sectionNumber == 1 {
                return BooksViewController.HotBookListLayout()
            }
            return nil
        }
        return layout
    }
    
    static func PopularBookListLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
            )
        )
        item.contentInsets.trailing = 15
        item.contentInsets.bottom = 30
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: .fractionalWidth(0.4),
                heightDimension: .absolute(200)
            ),
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.contentInsets.leading = 15
        section.contentInsets.trailing = 15
        
        let kind = UICollectionView.elementKindSectionHeader
        section.boundarySupplementaryItems = [
            .init(
                layoutSize:
                        .init(
                            widthDimension: .fractionalWidth(1),
                            heightDimension: .absolute(50)
                        ),
                elementKind: kind,
                alignment: .topLeading
            )
        ]
        return section
    }
    
    static func HotBookListLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1/3)
            )
        )
        item.contentInsets.trailing = 15
        item.contentInsets.bottom = 30
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: .init(
                widthDimension: .fractionalWidth(0.9),
                heightDimension: .absolute(300)
            ),
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.contentInsets.leading = 15
        section.contentInsets.trailing = 15
        
        let kind = UICollectionView.elementKindSectionHeader
        section.boundarySupplementaryItems = [
            .init(
                layoutSize:
                        .init(
                            widthDimension: .fractionalWidth(1),
                            heightDimension: .absolute(50)
                        ),
                elementKind: kind,
                alignment: .topLeading
            )
        ]
        return section
    }
    
    func setupHeaderView() {
        diffableDataSource.supplementaryViewProvider = { (collectionView, elementKind, indexPath) -> UICollectionReusableView? in
            
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: elementKind,
                withReuseIdentifier: BooksHeaderView.id,
                for: indexPath
            ) as! BooksHeaderView
            
            let snapshot = self.diffableDataSource.snapshot()
            let object = self.diffableDataSource.itemIdentifier(for: indexPath)
            let section = snapshot.sectionIdentifier(containingItem: object!)!
            
            if section == .PopularBookList {
                header.configure(with: Section.PopularBookList.rawValue)
            } else if section == .HotBookList {
                header.configure(with: Section.HotBookList.rawValue)
            }
            return header
        }
    }
    
    func fetchBooks() {
        URLSessionManager.shared.fetchPopularBookList(
            to: PopularBookAPIInfo(
                startDt: "2023-04-15",
                endDt: "2023-04-20",
                fromeAge: "6",
                toAge: "18",
                pageSize: "10"
            )
        ) { popularBook, err  in
            URLSessionManager.shared.fetchHotBookList(
                to: HotBookAPIInfo(
                    searchDt: "2023-04-23"
                )
            ) { hotBook, err in
                var snapShot = self.diffableDataSource.snapshot()
                snapShot.appendSections([.PopularBookList, .HotBookList])
                
                snapShot.appendItems(
                    popularBook,
                    toSection: .PopularBookList
                )
                snapShot.appendItems(
                    hotBook,
                    toSection: .HotBookList
                )
                self.diffableDataSource.apply(snapShot, animatingDifferences: true)
            }
        }
    }
        
}

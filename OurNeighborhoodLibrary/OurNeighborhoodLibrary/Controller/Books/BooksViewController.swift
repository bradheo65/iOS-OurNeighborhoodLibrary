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
    
    enum Section: CaseIterable {
        case PopularbookList
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
            PopularbookListCell.self,
            forCellWithReuseIdentifier: PopularbookListCell.id
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var diffableDataSource: UICollectionViewDiffableDataSource<Section, AnyHashable> = .init(collectionView: self.collectionView) { collectionView, indexPath, object in
        if let object = object as? DocElement {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PopularbookListCell.id,
                for: indexPath
            ) as? PopularbookListCell else {
                return nil
            }
            cell.configure(
                with: object.doc
            )
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

        getDocsInfo()
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
                return BooksViewController.topSection()
            }
            return nil
        }
        return layout
    }
    
    static func topSection() -> NSCollectionLayoutSection {
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
            
            if section == .PopularbookList {
                header.configure(with: "인기 도서 목록")
            }
            return header
        }
    }
    
    func getDocsInfo() {
        URLSessionManager.shared.getDocsInfo(
            to: GetDocsAPI(
                startDt: "2023-04-15", endDt: "2023-04-20", fromeAge: "6", toAge: "18", pageSize: "10"
            )
        ) { result in
            switch result {
            case .success(let data):
                do {
                    let docsData = try JSONDecoder().decode(PopularBook.self, from: data)
                    DispatchQueue.main.async {
                        self.applySnapShot(data: docsData.response.docs)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func applySnapShot(data: [AnyHashable]) {
        var snapShot = diffableDataSource.snapshot()
        snapShot.appendSections([.PopularbookList])
        snapShot.appendItems(data, toSection: .PopularbookList)
        
        self.diffableDataSource.apply(snapShot, animatingDifferences: true)
    }
  
}

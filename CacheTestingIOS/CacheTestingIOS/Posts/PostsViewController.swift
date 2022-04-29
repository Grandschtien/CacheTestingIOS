//
//  PostsViewController.swift
//  CacheTestingIOS
//
//  Created by Егор Шкарин on 22.04.2022.
//  
//

import UIKit

final class PostsViewController: UIViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Section, PostViewModel>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, PostViewModel>
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: setupLayoutOfCollection())
        collectionView.register(UINib(nibName: PostCell.nibName, bundle: nil),
                                forCellWithReuseIdentifier: PostCell.reuseIdentifier)
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        return collectionView
    }()
    private lazy var dataSource: DataSource = setupDataSource()
    enum Section {
        case main
    }
    
    private let output: PostsViewOutput
    //TODO: Поменять
    
    private lazy var posts = [PostViewModel]()
    init(output: PostsViewOutput) {
        self.output = output
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewDidLoad()
        setupUI()
    }
    private func setupUI() {
        title = "Посты"
        view.backgroundColor = .white
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupLayoutOfCollection() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(300))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func setupDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: collectionView) { (collectionView, indexPath, post) -> UICollectionViewCell in
            let cell = collectionView.dequeueCell(cellType: PostCell.self, for: indexPath)
            cell.configure(post)
            return cell
        }
        return dataSource
    }
    
    private func applySnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(posts, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension PostsViewController: PostsViewInput {
    func didMadeViewModels(_ viewModels: [PostViewModel]) {
        posts = viewModels
        applySnapshot()
    }
}
extension PostsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let postId = posts[indexPath.item].id
        output.didTapOnPost(withId: postId)
    }
}

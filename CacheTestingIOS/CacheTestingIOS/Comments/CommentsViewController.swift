//
//  CommentsViewController.swift
//  CacheTestingIOS
//
//  Created by Егор Шкарин on 25.04.2022.
//  
//

import UIKit

final class CommentsViewController: UIViewController {
    
    typealias DataSource = UITableViewDiffableDataSource<Section, CommentViewModel>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, CommentViewModel>
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(UINib(nibName: CommentCell.nibName, bundle: nil),
                       forCellReuseIdentifier: CommentCell.reuseIdentifier)
        table.separatorStyle = .none
        table.allowsSelection = false
        table.delegate = self
        return table
    }()
    
    private let output: CommentsViewOutput
    
    private lazy var viewModels: [CommentViewModel] = []
    private lazy var dataSource: DataSource = makeDataSource()
    
    enum Section {
        case main
    }
    
    init(output: CommentsViewOutput) {
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
        title = "Комментарии"
        view.backgroundColor = .white
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    private func makeDataSource() -> DataSource {
        let dataSource = DataSource(tableView: tableView) {[weak self] tableView, indexPath, itemIdentifier in
            let cell = tableView.dequeueCell(cellType: CommentCell.self, for: indexPath)
            guard let `self` = self else {
                return UITableViewCell()
            }
            cell.configure(withViewModel: self.viewModels[indexPath.row])
            return cell
        }
        
        return dataSource
    }
    
    private func applySnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(viewModels, toSection: .main)
        dataSource.apply(snapshot)
    }
}

extension CommentsViewController: CommentsViewInput {
    func didMadeViewModels(_ viewModels: [CommentViewModel]) {
        self.viewModels = viewModels
        applySnapshot()
    }
}
extension CommentsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}

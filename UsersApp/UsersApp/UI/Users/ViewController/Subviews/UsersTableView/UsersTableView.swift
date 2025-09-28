//
//  UsersTableView.swift
//  UsersApp
//
//  Created by Assistant on 28.09.2025.
//

import UIKit
import Combine

protocol UsersTableViewDelegate: AnyObject {
    func didSelectUser(_ user: UserEntity)
    func didTapFavoriteButton(for user: UserEntity)
    func shouldLoadMoreData(currentCount: Int)
    func didPullToRefresh()
}

class UsersTableView: UIView {
    
    // MARK: - Properties
    weak var delegate: UsersTableViewDelegate?
    
    // MARK: - Diffable Data Source
    private typealias DataSource = UITableViewDiffableDataSource<Section, CellDataWrapper>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, CellDataWrapper>
    
    private enum Section: CaseIterable {
        case main
    }

    private lazy var dataSource: DataSource = {
        DataSource(tableView: tableView) { [weak self] tableView, indexPath, cellDataWrapper in
            guard let self = self,
                  let cell = tableView.dequeueReusableCell(
                    withIdentifier: UserTableViewCell.reuseID,
                    for: indexPath
                  ) as? UserTableViewCell else {
                return UITableViewCell()
            }
            
            cell.setData(cellData: cellDataWrapper.cellData)
            
            // Configure favorite button callback
            cell.buttonTapCallback = { [weak self] in
                guard let self = self else { return }
                self.delegate?.didTapFavoriteButton(for: cellDataWrapper.user)
            }
            
            // Check if need to load more data
            self.checkForPagination(at: indexPath)
            
            return cell
        }
    }()

    // MARK: - Helper Struct for Diffable Data Source
    private struct CellDataWrapper: Hashable {
        let user: UserEntity
        let cellData: UserTableViewCellData
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(user.id)
        }
        
        static func == (lhs: CellDataWrapper, rhs: CellDataWrapper) -> Bool {
            return lhs.user.id == rhs.user.id && 
                   lhs.user.isSaved == rhs.user.isSaved
        }
    }
    
    // MARK: - UI Components
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .systemMint
        tableView.delegate = self
        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: UserTableViewCell.reuseID)
        
        // Setup refresh control
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        return tableView
    }()
    
    // MARK: - Data
    private var cellDataWrappers: [CellDataWrapper] = []
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - Setup
    private func setupUI() {
        addSubview(tableView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    // MARK: - Public Methods
    func updateUsers(with users: [UserEntity], cellDataArray: [UserTableViewCellData], animated: Bool = true) {
        guard users.count == cellDataArray.count else {
            assertionFailure("Users and cellData arrays must have same count")
            return
        }
        
        self.cellDataWrappers = zip(users, cellDataArray).map { user, cellData in
            CellDataWrapper(user: user, cellData: cellData)
        }
        
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(cellDataWrappers, toSection: .main)
        
        dataSource.apply(snapshot, animatingDifferences: animated)
        dataSource.defaultRowAnimation = .fade
        DispatchQueue.main.async { [weak self] in
            self?.tableView.refreshControl?.endRefreshing()
        }
    }
    
    func updateUser(_ user: UserEntity, with cellData: UserTableViewCellData, animated: Bool = true) {
        let newWrapper = CellDataWrapper(user: user, cellData: cellData)
        
        var snapshot = dataSource.snapshot()
        if let existingIndex = cellDataWrappers.firstIndex(where: { $0.user.id == user.id }) {
            cellDataWrappers[existingIndex] = newWrapper
            let existingWrapper = snapshot.itemIdentifiers[existingIndex]
            snapshot.reloadItems([existingWrapper])
            dataSource.apply(snapshot, animatingDifferences: animated)
        }
    }
    
    // MARK: - Private Methods
    private func checkForPagination(at indexPath: IndexPath) {
        let lastIndex = cellDataWrappers.count - 3
        if indexPath.row == lastIndex {
            delegate?.shouldLoadMoreData(currentCount: cellDataWrappers.count)
        }
    }
    
    @objc private func handleRefresh() {
        delegate?.didPullToRefresh()
    }
}

// MARK: - UITableViewDelegate
extension UsersTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard indexPath.row < cellDataWrappers.count else { return }
        let user = cellDataWrappers[indexPath.row].user
        delegate?.didSelectUser(user)
    }
}
